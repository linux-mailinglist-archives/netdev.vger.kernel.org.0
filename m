Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010485C638
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 02:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfGBAJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 20:09:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44639 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfGBAJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 20:09:28 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so7314061pfe.11
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 17:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gyYPV1zUp1CDzG3zhADVpKBs/ZxT7Kh02i96xmC7Rzw=;
        b=W7O7NVqRWTH+/d8jYL+xWrHVdDh7+iMMhrdj/CimFwLUj9u8d+I1G+RiUUz91+wZmY
         yArB3xj4AodjJ1YfRkoQAvTNTLUnJebDkjTlaYYgYECQPEeFp+zj+twi6j+nSOkla+RS
         +qA8Ld4iDfCHNEOUElJsEyIsqsn0+iaprUD/g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gyYPV1zUp1CDzG3zhADVpKBs/ZxT7Kh02i96xmC7Rzw=;
        b=dMAuvNb1s5MBG7COXv04p8+56mu2qnFiwptYDugXjbddD3PjdwyqDDDk78hUvnbq1x
         lmAWagMOyFxDMwC3s/ZO7yiELFsOKBw0EknRD0+N2k+EFlj80DDe6GKNKvcxB1faWrW3
         VeDKvM8GNdq5jwFLo3BjhpihAsDRSQwA51QhqT/MSjSZuKM8BjgR8370zDbK96pwHq0q
         iJ3rYP3MH/tC5khYvVtW6VIqz0Lalz/IWqQ2GOlqWlk+0OtNNJzN+ippkLqvtdP+HVcj
         QKhhd5lQpQwi4J1p26ZefO33hxKghuNGoQg3vAmJs5FNHcRaWwULhujE31e1ZImcdbcx
         Czsw==
X-Gm-Message-State: APjAAAV8a7H6zgAT6pICWRkgdFXqFXQOvn/ueMcouJzFC6AEEmLeey4j
        Kbz0zxX5uEAuNinAuSagpUUlwA==
X-Google-Smtp-Source: APXvYqyPWuqQHIRJfCr/5/k9c5oSj6FIo9l4K3WY/UJBi8hfz5Yorr+fBinMFTC68NlS9NqK4/2amw==
X-Received: by 2002:a17:90a:5887:: with SMTP id j7mr2155165pji.136.1562026167563;
        Mon, 01 Jul 2019 17:09:27 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id 23sm13701301pfn.176.2019.07.01.17.09.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 17:09:26 -0700 (PDT)
Date:   Mon, 1 Jul 2019 17:09:25 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH 2/3] net: phy: realtek: Enable accessing RTL8211E
 extension pages
Message-ID: <20190702000925.GD250418@google.com>
References: <20190701195225.120808-1-mka@chromium.org>
 <20190701195225.120808-2-mka@chromium.org>
 <20190701200248.GJ30468@lunn.ch>
 <35db1bff-f48e-5372-06b7-3140cb7cbb71@gmail.com>
 <20190701210902.GL30468@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190701210902.GL30468@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 11:09:02PM +0200, Andrew Lunn wrote:
> On Mon, Jul 01, 2019 at 10:37:16PM +0200, Heiner Kallweit wrote:
> > On 01.07.2019 22:02, Andrew Lunn wrote:
> > > On Mon, Jul 01, 2019 at 12:52:24PM -0700, Matthias Kaehlcke wrote:
> > >> The RTL8211E has extension pages, which can be accessed after
> > >> selecting a page through a custom method. Add a function to
> > >> modify bits in a register of an extension page and a few
> > >> helpers for dealing with ext pages.
> > >>
> > >> rtl8211e_modify_ext_paged() and rtl821e_restore_page() are
> > >> inspired by their counterparts phy_modify_paged() and
> > >> phy_restore_page().
> > > 
> > > Hi Matthias
> > > 
> > > While an extended page is selected, what happens to the normal
> > > registers in the range 0-0x1c? Are they still accessible?
> > > 
> > AFAIK: no
> 
> This it would be better to make use of the core paged access support,
> so that locking is done correctly.

Do I understand correctly that this would involve assigning
.read/write_page and use phy_select_page() and phy_restore_page()?

Besides the benefit of locking this would also result in less code and
we could get rid of the custom _restore_page().
