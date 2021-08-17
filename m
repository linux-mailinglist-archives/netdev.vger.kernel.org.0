Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBDB3EEE30
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 16:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbhHQOLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 10:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbhHQOLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 10:11:51 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44172C0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 07:11:18 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id dj8so23904017edb.2
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 07:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=/NgdSTCYnaqOPQW0yqkV2LjXi3FiFTPBy5EgGyyYOAU=;
        b=rE0YaTqBF+aZE9pZKmfTx5ou393jeLPRpuYPDg+O7SfMVgWnckLx7kU6lFjZ1oEBip
         sExxcn+Ga3bbM+Y7wvJKXx8aF1giZKyiTD085acpdER6FQZsEHGWMRFBcnEhjuUyTWsJ
         HLvIKhVUePhRNDjDrGSie/Y0tuGJ20miPI0Pk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=/NgdSTCYnaqOPQW0yqkV2LjXi3FiFTPBy5EgGyyYOAU=;
        b=TVvO+JNpPz5JIJbwY1Ui4kTNl16JnQeD1MNFrd3APDYCav15J8ObxoqDq1yk7GWaby
         8Ifv81DC866CU6nlm5b34ENz2hZDtiUzJ7Cu1vvvuQDShDOA9QG8T8G5//wCzvESFlbd
         sI+cvtmrOuvWv0UPy7CsD5uw2NkQfQBy8bpPGXfa8Irnpk7xSbIik7aDu8BShtoEyCKB
         R61ZTM6+A3UZeKRfG/H6LBjCPKVmhgQePKrl2ylOhuw4DM6eMzEtuxgCT9E4gKh+Q4UB
         ssiT20BCW+N3VSjegoSTWAAM5LNguSxeJGzaeSHwzgb8zY0fN/Ab2F7yuzUK2hMSd9jb
         cVyA==
X-Gm-Message-State: AOAM532ONy70kXBY7LcLYiaff4u7GehO3ycTmTGva86R0nQrNAu0dbsc
        TWKjDbAL8B7Savua35tC387sIQ==
X-Google-Smtp-Source: ABdhPJzSXUfDESLdAGKdVt8LDz0ICQ2mFis9rlo5KAAw6uuOajvQ3CS963SYfUUKMfDIc2DvxEImJA==
X-Received: by 2002:a05:6402:18ec:: with SMTP id x44mr4367084edy.317.1629209476897;
        Tue, 17 Aug 2021 07:11:16 -0700 (PDT)
Received: from p310.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id cq12sm1000191edb.43.2021.08.17.07.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 07:11:16 -0700 (PDT)
Date:   Tue, 17 Aug 2021 17:11:15 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: usb: pegasus: ignore the return value from
 set_registers();
Message-ID: <YRvDg/TTuTlAcEsM@p310.k.g>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        paskripkin@gmail.com, stable@vger.kernel.org, davem@davemloft.net
References: <20210812082351.37966-1-petko.manolov@konsulko.com>
 <20210813162439.1779bf63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRjWXzYrQsGZiISc@carbon>
 <20210816070640.2a7a6f5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRq5JyLbkU8hN/fG@carbon>
 <20210816131815.4e4e09de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816131815.4e4e09de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-08-16 13:18:15, Jakub Kicinski wrote:
> On Mon, 16 Aug 2021 22:14:47 +0300 Petko Manolov wrote:
> > On 21-08-16 07:06:40, Jakub Kicinski wrote:
> > > On Sun, 15 Aug 2021 11:54:55 +0300 Petko Manolov wrote:  
> > > > Mostly because for this particular adapter checking the read failure makes much
> > > > more sense than write failure.  
> > > 
> > > This is not an either-or choice.
> > >   
> > > > Checking the return value of set_register(s) is often usless because device's
> > > > default register values are sane enough to get a working ethernet adapter even
> > > > without much prodding.  There are exceptions, though, one of them being
> > > > set_ethernet_addr().
> > > > 
> > > > You could read the discussing in the netdev ML, but the essence of it is that
> > > > set_ethernet_addr() should not give up if set_register(s) fail.  Instead, the
> > > > driver should assign a valid, even if random, MAC address.
> > > > 
> > > > It is much the same situation with enable_net_traffic() - it should continue
> > > > regardless.  There are two options to resolve this: a) remove the error check
> > > > altogether; b) do the check and print a debug message.  I prefer a), but i am
> > > > also not strongly opposed to b).  Comments?  
> > > 
> > > c) keep propagating the error like the driver used to.  
> > 
> > If you carefully read the code, which dates back to at least 2005, you'll see
> > that on line 436 (v5.14-rc6) 'ret' is assigned with the return value of
> > set_registers(), but 'ret' is never evaluated and thus not acted upon.
> 
> It's no longer evaluated because of your commit 8a160e2e9aeb ("net:
> usb: pegasus: Check the return value of get_geristers() and friends;")
> IOW v5.14-rc6 has your recent patch. Which I quoted earlier in this
> thread. That commit was on Aug 3 2021. The error checking (now
> accidentally removed) was introduced somewhere in 2.6.x days.
> 
> If you disagree with that please show me the code you're referring to,
> because I just don't see it.
> 
> > > I don't understand why that's not the most obvious option.  
> > 
> > Which part of "this is not a fatal error" you did not understand?
> 
> That's not the point. The error checking was removed accidentally, it should
> be brought back in net to avoid introducing regressions.

Not introducing regressions is the argument that sold me on.  If i don't get too
lazy i may further change this part of the code, but that's in the future.  I've
sent a patch that restores the original behavior in addition of a few small
tweaks.


		Petko
