Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0F35B773
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 11:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbfGAJGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 05:06:51 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36746 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbfGAJGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 05:06:51 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so7018030plt.3;
        Mon, 01 Jul 2019 02:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zyv4q9EGM1CdD7ChrPZEfCjXpHIw1XhG13en0sw9xH4=;
        b=Uz/oKGOvMEp2zUHMHJe47Cf7+oRDlx63v9VTEeYkk26TUcFGUHfUo8cvvfAC5tvgNE
         okgHM3PDCD3FQhPH36L0RqKknLvb5cXwM4yy2qG+9eL3uejvkr4NKBHAMgKaWUw1DhwM
         MLubvQHaO8eZiOiKQ5CbSj1Hc05uynZarz0b46/IMa/d9RiBC5sZUzuEoO3FQZuEZZbv
         aPTKEV62+suuJzPYsPfPyxGzYzNLR8VwsfzSVttyFWcThj4iFiPc6AGgieVbfOtnZkD2
         JtC8v8nBZKf3bLZSyvV3+3GWznGX/5GwMnkoXeLU9qLIShwkPwSvIRrC3chynagwddI8
         voQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zyv4q9EGM1CdD7ChrPZEfCjXpHIw1XhG13en0sw9xH4=;
        b=MJWpfKC8rR0p9xYFeCDM7DsplLA/NFvP3o88JdrIQssqnvBtdFxPuXdkG9fHs5wDUg
         6yXpj4lmP9atQhK3YZ+S9FtGJoJpQcR1t9FssInxwirlzI/GfgCwxA2H068/7+TUQRuS
         CyaV5o8Hha2sUcSGPkKips5l71JXVtV46Bya3yPfUh8ysta7e0bJ3iHPBuLo8b2VswbD
         siTGUag2BIv5ikZQ8Z9e7mQUBl127oFf9cqV7pP8wSsUgiC6U4UFNvgds74oJCLscS/3
         BeoUBrvAhI0bj0AfuKFauS5UHZe2EQtVhqKLHH56VP6K0OeJYR2wv5Aj2aw8Zs5bs2y9
         93NA==
X-Gm-Message-State: APjAAAUjnaGWwFLN13AT9vAyhawn9yEiDng8nwE7QqeZp3IycXTqfSVv
        nKz2kV3fW8QnovJkW4dXJyl2QYIJfeUwtQ==
X-Google-Smtp-Source: APXvYqzbUenPrZbCJbaJV+y1L8+ydJop9YV2WYADFI511rE0dHvaRDGxxSqZbdf5WeWlV04IcCwaQQ==
X-Received: by 2002:a17:902:1004:: with SMTP id b4mr28286589pla.325.1561972010687;
        Mon, 01 Jul 2019 02:06:50 -0700 (PDT)
Received: from ubuntu ([104.192.108.10])
        by smtp.gmail.com with ESMTPSA id q4sm10152534pjq.27.2019.07.01.02.06.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 02:06:50 -0700 (PDT)
Date:   Mon, 1 Jul 2019 02:06:44 -0700
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6_sockglue: Fix a missing-check bug in
 ip6_ra_control()
Message-ID: <20190701090644.GA88924@ubuntu>
References: <20190524031946.GA6463@zhanggen-UX430UQ>
 <1b5f82ae-31a7-db36-dc9d-efc46cda2af3@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b5f82ae-31a7-db36-dc9d-efc46cda2af3@suse.cz>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 10:57:36AM +0200, Jiri Slaby wrote:
> On 24. 05. 19, 5:19, Gen Zhang wrote:
> > In function ip6_ra_control(), the pointer new_ra is allocated a memory 
> > space via kmalloc(). And it is used in the following codes. However, 
> > when there is a memory allocation error, kmalloc() fails. Thus null 
> > pointer dereference may happen. And it will cause the kernel to crash. 
> > Therefore, we should check the return value and handle the error.
> > 
> > Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> > 
> > ---
> > diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> > index 40f21fe..0a3d035 100644
> > --- a/net/ipv6/ipv6_sockglue.c
> > +++ b/net/ipv6/ipv6_sockglue.c
> > @@ -68,6 +68,8 @@ int ip6_ra_control(struct sock *sk, int sel)
> >  		return -ENOPROTOOPT;
> >  
> >  	new_ra = (sel >= 0) ? kmalloc(sizeof(*new_ra), GFP_KERNEL) : NULL;
> > +	if (sel >= 0 && !new_ra)
> > +		return -ENOMEM;
> >  
> >  	write_lock_bh(&ip6_ra_lock);
> >  	for (rap = &ip6_ra_chain; (ra = *rap) != NULL; rap = &ra->next) {
> > 
> 
> Was this really an omission? There is (!new_ra) handling below the for loop:
>         if (!new_ra) {
>                 write_unlock_bh(&ip6_ra_lock);
>                 return -ENOBUFS;
>         }
> 
> It used to handle both (sel >= 0) and (sel == 0) cases and it used to
> return ENOBUFS in case of failure. For (sel >= 0) it also could at least
> return EADDRINUSE when a collision was found -- even if memory was
> exhausted.
> 
> In anyway, how could this lead to a pointer dereference? And why/how did
> this get a CVE number?
> 
> thanks,
> -- 
> js
> suse labs
This CVE is already disputed by other maintainers and marked *DISPUTED*
on the website.

Thanks
Gen
