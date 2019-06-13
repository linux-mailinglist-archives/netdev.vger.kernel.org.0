Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAD843BEB
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfFMPcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:32:36 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42484 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfFMPce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 11:32:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so12058642pff.9
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 08:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TD2H9Hhj3S+Krmty7ZqGdgy5CKS4QMDwo6kREYn96xQ=;
        b=Cq6HuyO4bDdlNTIqwl6xwH9kgUiKInbq+xLqOLxh/BeqTnneGb9Urvf34iqJu+7rTQ
         ssFL6laY7TJFMfMCJkwwrRkjCMaeiErU9nuYYp7lDWQBJjRBXiqa8PZAh2VySdjxZ1Id
         Thbx9VOwFTQQAiOIEkBf6hIo+5z5ZegX6Ruj+gDKhYiK8tiSM68ea61JDrLpzmeus+a2
         9Sg4TzBDoB0AaGlZXk0ttN6VLmt9GmJmeu+TsHGuTrZpm+BAbxvK4a0PCKNaPUpUHSQB
         GfvESD767p6+aGZskS97M8xVm7+Zt0KqpcbH2J996qzD3EJ6ZpVaV65S+ynyjswi0SOa
         P63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TD2H9Hhj3S+Krmty7ZqGdgy5CKS4QMDwo6kREYn96xQ=;
        b=e4rj12KVNK1WJTn0NbNTINIHv+g/NBUVgHxxbccDjCRttF7dM8gMujeThb4UiJH9Q5
         WSX1Ko30nIkkFgIckWperJL60xpxmJ0GmpSOjdX7zFPzu4OmruKdBvGOuP6O0eb/WprH
         PxCHKpgQPnZjcZP76YRqVM2uNblh/XtEWTahyoRM0rkOdtPVhSk+3sSdoQzFnW+digUB
         LmkJzRItj2Os4D+XLENLrG3xHZxZbIe+eNk8tu0gVekTCLzexNeKQbmtsC6FUCcwKGuT
         3x0VodPUqkpXvvWPvQkUzV9NJ7A5WD9PEcUtV8dIxvZXMRB/2KD2Uf0OiXUJJhxoWxZL
         wcIA==
X-Gm-Message-State: APjAAAULCtTN87mOI0l+KnAH1ERS9GHuw+dtQrkNbiOPYFHtCowxRNGF
        9TaH6QkgMkOD964gNz/+xVcMNQA=
X-Google-Smtp-Source: APXvYqyFnQ03x2HJTRPqVGsDA/9/mGuMdKnhJezVh3cDN5MYou1XCC+JjN52BXsiFMUHEb5HrN32Kw==
X-Received: by 2002:a62:fb18:: with SMTP id x24mr93174922pfm.76.1560439954161;
        Thu, 13 Jun 2019 08:32:34 -0700 (PDT)
Received: from ubuntu ([12.38.14.8])
        by smtp.gmail.com with ESMTPSA id s5sm147300pgj.60.2019.06.13.08.32.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Jun 2019 08:32:33 -0700 (PDT)
Date:   Thu, 13 Jun 2019 11:32:26 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipv4: Support multipath hashing on inner IP
 pkts for GRE tunnel
Message-ID: <20190613153226.GA4250@ubuntu>
References: <20190611003142.11626-1-ssuryaextr@gmail.com>
 <076bc564-7c97-f591-6b4c-2e540db4cb87@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <076bc564-7c97-f591-6b4c-2e540db4cb87@cumulusnetworks.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 10:29:56AM +0300, Nikolay Aleksandrov wrote:
> 
> Have you considered using the flow dissector and doing something similar to the bonding ?
> It does a full flow dissect via skb_flow_dissect_flow_keys() and uses whatever headers
> it needs, but that will support any tunneling protocol which the flow dissector
> recognizes and will be improved upon automatically by people adding to it.
> Also would avoid doing dissection by yourself.
> 
> The bond commit which added that was:
>  32819dc18348 ("bonding: modify the old and add new xmit hash policies")
> 

I didn't consider it and should. Thanks for pointing me to that
direction. It's simpler.

> >  /* if skb is set it will be used and fl4 can be NULL */
> >  int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
> >  		       const struct sk_buff *skb, struct flow_keys *flkeys)
> > @@ -1828,12 +1876,13 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
> >  	struct flow_keys hash_keys;
> >  	u32 mhash;
> >  
> > +	memset(&hash_keys, 0, sizeof(hash_keys));
> > +
> 
> This was an optimization, it was done on purpose to avoid doing anything when we
> have L3+4 configured (1) and the skb has its hash already calculated.
> 
Will revert to the original lines.

Thanks.
