Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705631565C2
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 18:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgBHRed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 12:34:33 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37723 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgBHRed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 12:34:33 -0500
Received: by mail-qk1-f196.google.com with SMTP id c188so2405240qkg.4
        for <netdev@vger.kernel.org>; Sat, 08 Feb 2020 09:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vFbWXxT3BnnmeXjcvXz0cFQ59E9mn2EdxaVYevY4ALA=;
        b=bMlZk+nIiloW+CHj1HqWU7wkAo99YL+g757LFTnC+Zyxet8pQPwYl3iaXi8qNakCx0
         kWEYn2Pz3NNOzau+wi5mvN2PgihBWPYQ01iCEM/6DurU2uYkE8TQM4d5kgeNicLhkY3n
         rSzrTlBcdKpo7wdSPtXxQkzv6tqt41p0ciaxkJlELaiM7B0ItM5KRnousv2eTjQ9oNzH
         BNjXmZ36UNMXISIbe02wVZMp984OKF0KjDUvTAK+iKC3G8dpdbFWuq/LEi9KZB5ekjwd
         NU1aCUDiJ/XK8vG+oyg+Q3J+eod02xaxHFWp4mQYGmNo5H6zUmclYJnryxj3iJ6j0TDw
         2daw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vFbWXxT3BnnmeXjcvXz0cFQ59E9mn2EdxaVYevY4ALA=;
        b=da1DVbjRBmY8d4R2CwIvLNxmL9O7kRLc9JAe33DHkWl3huN+utFHswDMxNIPePOzTp
         n0t+Ax4fwMn9t7v01acreei9kB2MzRMM3ubvmh3U/iyoAfKTercuWWGvUx3PXAIA+C/a
         xT7heyYHVs8NIEARIdeEqcdUdzXHOpy0xrNOHlgdpblbX6ReSh7Y+1A9nt6RwC2THaWb
         yM/HKo5FQY8Eu+HB4k1Pu5OY90N79Wu0vq6fGReuhicb1SZcUOzaL52OkjTVUDUo99Hp
         1mLkiHdDaJ7jz6jxeNxmL2Azs8Z5C2bSFgnPynCfDhHRwZbc+AK41H5V2x8tZQ4mJZ/n
         juOA==
X-Gm-Message-State: APjAAAVLj7jVDW8qZNZAvczYrSABLblowMSFqyhZU5E+B+7j18dagGYj
        BVlDSsg9QwsDP93RLKPxDsE=
X-Google-Smtp-Source: APXvYqy1pakRsDqS67/T4Q2awWkeN+NIyi3Cnod8SOZmM55m9HQyuICPjURDverBisOeGTbo+Dw6kg==
X-Received: by 2002:a05:620a:8cc:: with SMTP id z12mr3886614qkz.48.1581183271867;
        Sat, 08 Feb 2020 09:34:31 -0800 (PST)
Received: from ryzen (104-222-125-163.cpe.teksavvy.com. [104.222.125.163])
        by smtp.gmail.com with ESMTPSA id 63sm3124005qki.57.2020.02.08.09.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 09:34:31 -0800 (PST)
Date:   Sat, 8 Feb 2020 12:34:23 -0500
From:   Alexander Aring <alex.aring@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, andrea.mayer@uniroma2.it,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org
Subject: Re: [PATCH net 1/2] net: ipv6: seg6_iptunnel: set tunnel headroom to
 zero
Message-ID: <20200208173423.i2oymewkgiriciqh@ryzen>
References: <20200204173019.4437-1-alex.aring@gmail.com>
 <20200204173019.4437-2-alex.aring@gmail.com>
 <20200206.135418.602918242715627740.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200206.135418.602918242715627740.davem@davemloft.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Feb 06, 2020 at 01:54:18PM +0100, David Miller wrote:
> From: Alexander Aring <alex.aring@gmail.com>
> Date: Tue,  4 Feb 2020 12:30:18 -0500
> 
> > diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
> > index ab7f124ff5d7..5b6e88f16e2d 100644
> > --- a/net/ipv6/seg6_iptunnel.c
> > +++ b/net/ipv6/seg6_iptunnel.c
> > @@ -449,8 +449,6 @@ static int seg6_build_state(struct nlattr *nla,
> >  	if (tuninfo->mode != SEG6_IPTUN_MODE_L2ENCAP)
> >  		newts->flags |= LWTUNNEL_STATE_OUTPUT_REDIRECT;
> >  
> > -	newts->headroom = seg6_lwt_headroom(tuninfo);
> > -
> >  	*ts = newts;
> >  
> >  	return 0;
> 
> Even if this change is correct, you are eliminating the one and only
> user of seg6_lwt_headroom() so you would have to kill that in this
> patch as well.

Okay, this is in include/uapi but surrounding by __KERNEL__ so I guess
it's still okay to remove it?

btw: why it is not static in seg6_iptunnel.c then?

Anyway I will wait until I hear something back what the use of headroom
exactly is and why the original authors of segmentation routing sets it.
In my case it will simple not work with a IPv6 min mtu so I will set it
to zero for possible net-next patches.

- Alex
