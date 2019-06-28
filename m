Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC8C459F2C
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfF1Poz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:44:55 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41060 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfF1Poy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:44:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id m7so3440556pls.8
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DKZ1Zh9K5Ac3vNccaMSnPXomUet+GSnezvL0DT85CD8=;
        b=ZwxR9v640eQRNBhYAtKvi3V2FtnYaOEs+0gtWm7EcHZcAA+WHlnT9VKidG5/Tq7w31
         W1sdxNSQbu3ZlWZ8U7W8Gxe0AW1bMgyb7CAkx0eSwLsgEbyPb9wr5CryUu3dOr+LNAo8
         Zg/eNApqMUV9IKFVfnqb200W4C3X5eBFgWZxoy+4zSaAUv5IsmHGjGTUX6x6aouDQdW9
         OEg/JXC+ZcgDI+rv/BEnWDknxrAMVDI1NwRWTIOiG37Q8vHrqx7ZWWyCHHfEWw4wLhPm
         VoSkCYLChuNwvYWOjMmFf/QyReuYz/2qcbhQ0xhO0JLj67U31+ycJXRIGBTK3zZISTpZ
         jiyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DKZ1Zh9K5Ac3vNccaMSnPXomUet+GSnezvL0DT85CD8=;
        b=I1Yuh7FTmYGGnVFFPih16mWwU3a0IvzdP6SGQ9eWvPR/dVuZolTyRCBVnaBJAoiCIw
         BtWhwQhdL74kxNbYznfUndwUlrV5CICbfLnTUZNaNFhI1Fvm42IbGFgCqQBCBuH1Uh2C
         m1r5Zza3bYHRHE92rJ6hatBQzm1Y8o8Kv8aHYyccE4Fp8CWytmC2erqTRcbgbOR0Haos
         UJTgbqLQPsyblg2MsD6sudK/AlCbncSXCvuclRJMlh+exyUdsDWPAHmZjgjf3RJN8TSf
         enfc7geLsvRIdjoWBCzbcP+/SrqxBOhVcNxVX2rrnhSC5tBdHvc0GOWe5EfO8i8lzn1d
         NsHg==
X-Gm-Message-State: APjAAAUN+iaFHMIcFAq9CuELC2tJc7E+ZtI76BLVtiUDliVzKYySji5B
        VYd28MrYz4NbJVQbrNiCmSsGPQ==
X-Google-Smtp-Source: APXvYqyvlG8XOi/Sq/vYjXHCKd2wVw1cjYVjPfJKim7B7YVuV0TY4EyKh58vbxsTXesDrfJUHc3hTQ==
X-Received: by 2002:a17:902:aa41:: with SMTP id c1mr12231086plr.201.1561736694261;
        Fri, 28 Jun 2019 08:44:54 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t5sm2020364pgh.46.2019.06.28.08.44.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 08:44:54 -0700 (PDT)
Date:   Fri, 28 Jun 2019 08:44:47 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190628084447.186a0efb@hermes.lan>
In-Reply-To: <20190628135553.GA6640@nanopsycho>
References: <20190627094327.GF2424@nanopsycho>
        <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
        <20190627180803.GJ27240@unicorn.suse.cz>
        <20190627112305.7e05e210@hermes.lan>
        <20190627183538.GI31189@lunn.ch>
        <20190627183948.GK27240@unicorn.suse.cz>
        <20190627122041.18c46daf@hermes.lan>
        <20190628111216.GA2568@nanopsycho>
        <20190628131401.GA27820@lunn.ch>
        <20190628135553.GA6640@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 15:55:53 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Fri, Jun 28, 2019 at 03:14:01PM CEST, andrew@lunn.ch wrote:
> >On Fri, Jun 28, 2019 at 01:12:16PM +0200, Jiri Pirko wrote:  
> >> Thu, Jun 27, 2019 at 09:20:41PM CEST, stephen@networkplumber.org wrote:  
> >> >On Thu, 27 Jun 2019 20:39:48 +0200
> >> >Michal Kubecek <mkubecek@suse.cz> wrote:
> >> >  
> >> >> > 
> >> >> > $ ip li set dev enp3s0 alias "Onboard Ethernet"
> >> >> > # ip link show "Onboard Ethernet"
> >> >> > Device "Onboard Ethernet" does not exist.
> >> >> > 
> >> >> > So it does not really appear to be an alias, it is a label. To be
> >> >> > truly useful, it needs to be more than a label, it needs to be a real
> >> >> > alias which you can use.    
> >> >> 
> >> >> That's exactly what I meant: to be really useful, one should be able to
> >> >> use the alias(es) for setting device options, for adding routes, in
> >> >> netfilter rules etc.
> >> >> 
> >> >> Michal  
> >> >
> >> >The kernel doesn't enforce uniqueness of alias.
> >> >Also current kernel RTM_GETLINK doesn't do filter by alias (easily fixed).
> >> >
> >> >If it did, then handling it in iproute would be something like:  
> >> 
> >> I think that it is desired for kernel to work with "real alias" as a
> >> handle. Userspace could either pass ifindex, IFLA_NAME or "real alias".
> >> Userspace mapping like you did here might be perhaps okay for iproute2,
> >> but I think that we need something and easy to use for all.
> >> 
> >> Let's call it "altname". Get would return:
> >> 
> >> IFLA_NAME  eth0
> >> IFLA_ALT_NAME_LIST
> >>    IFLA_ALT_NAME  eth0
> >>    IFLA_ALT_NAME  somethingelse
> >>    IFLA_ALT_NAME  somenamethatisreallylong  
> >
> >Hi Jiri
> >
> >What is your user case for having multiple IFLA_ALT_NAME for the same
> >IFLA_NAME?  
> 
> I don't know about specific usecase for having more. Perhaps Michal
> does.
> 
> From the implementation perspective it is handy to have the ifname as
> the first alt name in kernel, so the userspace would just pass
> IFLA_ALT_NAME always. Also for avoiding name collisions etc.

I like the alternate name proposal. The kernel would have to impose  uniqueness.
Does alt_name have to be unique across both regular and alt_name?
Having multiple names list seems less interesting but it could be useful.
