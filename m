Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F51A59D4E
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfF1Nz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:55:56 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41389 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfF1Nz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:55:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so6393826wrm.8
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 06:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1HN8hG9nrUKoQPDPuAMUKQBGu5+QtUQCbeYUEgmAc60=;
        b=vdJzxg309abySh+l8KPnghi/55ss5jcjq9byszQg2w4UrMGs59CLnMxW1WjHs2SW6I
         WwsnKV7OgVLWQns86Nvq20X3NKgjkbMrzjfW5WmQzAN/LniPBBFgOFCfhjnS1CwGxMFW
         RvCrv+1OrrMStgoSno6LTNUD0p3G1vEMJNzuuvmvjBrEHxfeMaQPC5hI2HNB6KKEPBYE
         S2DmJQf5TMXdiqJyLqFjpmNxhcPRYTpVrIxRvIt8w+doWdIkT1W7a0Slnr9vFFUiuuIu
         y3T8rkeOsafdhDQ45IQWlbp/UreffQWGKzFO5z974HbGgSD/UQDaRrmHa2wwEcj4ap7M
         4X2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1HN8hG9nrUKoQPDPuAMUKQBGu5+QtUQCbeYUEgmAc60=;
        b=Qzm98Ag/K4Prc5cRkR1OisP7n8NlxvpYFnvCckX8NxaHbCFp8EC5JQzkbsUlKI46Se
         CIiyQzH5BQq9NiVkqMrPszcb+TunUYliPK41w1yYVt7y5y9qVOdfwyrMvb+85IGqI67V
         e/gD/q4i0YaHrLkylQFC7DqM6Kd90+JjLGdvhptt8f6z3a0145As4voJVJzZl5IfcNmw
         XHohfOS8Cw7/8V933GE7GqKXoxlNO1jSoO3Muumjp/MU6oRe2dCYwoLd8cuUF8NyOUuv
         90DbX9rswV9hSD/eql9t01SW8J3iSQurzRs1FXXeZujG1LhP2mirConwTrpvjtSL9lP5
         bDcw==
X-Gm-Message-State: APjAAAVqfL2PyDEAHfYWiFuno08sCeJxpjsH9+sG7PCmGLlT37WLtqgB
        i25Zknd+fpayjljPg7PrwMCrWg==
X-Google-Smtp-Source: APXvYqwCTIHLSFK+GmO4W0wmij5o/L9Qw+IwAni+2I7HEhwRHHwk225ZyBEhCoHFrXdjMso2uDYRIQ==
X-Received: by 2002:adf:ff84:: with SMTP id j4mr7733134wrr.71.1561730154650;
        Fri, 28 Jun 2019 06:55:54 -0700 (PDT)
Received: from localhost (ip-89-176-222-26.net.upcbroadband.cz. [89.176.222.26])
        by smtp.gmail.com with ESMTPSA id f12sm4765993wrg.5.2019.06.28.06.55.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 06:55:54 -0700 (PDT)
Date:   Fri, 28 Jun 2019 15:55:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190628135553.GA6640@nanopsycho>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
 <20190627180803.GJ27240@unicorn.suse.cz>
 <20190627112305.7e05e210@hermes.lan>
 <20190627183538.GI31189@lunn.ch>
 <20190627183948.GK27240@unicorn.suse.cz>
 <20190627122041.18c46daf@hermes.lan>
 <20190628111216.GA2568@nanopsycho>
 <20190628131401.GA27820@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628131401.GA27820@lunn.ch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jun 28, 2019 at 03:14:01PM CEST, andrew@lunn.ch wrote:
>On Fri, Jun 28, 2019 at 01:12:16PM +0200, Jiri Pirko wrote:
>> Thu, Jun 27, 2019 at 09:20:41PM CEST, stephen@networkplumber.org wrote:
>> >On Thu, 27 Jun 2019 20:39:48 +0200
>> >Michal Kubecek <mkubecek@suse.cz> wrote:
>> >
>> >> > 
>> >> > $ ip li set dev enp3s0 alias "Onboard Ethernet"
>> >> > # ip link show "Onboard Ethernet"
>> >> > Device "Onboard Ethernet" does not exist.
>> >> > 
>> >> > So it does not really appear to be an alias, it is a label. To be
>> >> > truly useful, it needs to be more than a label, it needs to be a real
>> >> > alias which you can use.  
>> >> 
>> >> That's exactly what I meant: to be really useful, one should be able to
>> >> use the alias(es) for setting device options, for adding routes, in
>> >> netfilter rules etc.
>> >> 
>> >> Michal
>> >
>> >The kernel doesn't enforce uniqueness of alias.
>> >Also current kernel RTM_GETLINK doesn't do filter by alias (easily fixed).
>> >
>> >If it did, then handling it in iproute would be something like:
>> 
>> I think that it is desired for kernel to work with "real alias" as a
>> handle. Userspace could either pass ifindex, IFLA_NAME or "real alias".
>> Userspace mapping like you did here might be perhaps okay for iproute2,
>> but I think that we need something and easy to use for all.
>> 
>> Let's call it "altname". Get would return:
>> 
>> IFLA_NAME  eth0
>> IFLA_ALT_NAME_LIST
>>    IFLA_ALT_NAME  eth0
>>    IFLA_ALT_NAME  somethingelse
>>    IFLA_ALT_NAME  somenamethatisreallylong
>
>Hi Jiri
>
>What is your user case for having multiple IFLA_ALT_NAME for the same
>IFLA_NAME?

I don't know about specific usecase for having more. Perhaps Michal
does.

From the implementation perspective it is handy to have the ifname as
the first alt name in kernel, so the userspace would just pass
IFLA_ALT_NAME always. Also for avoiding name collisions etc.



>
>	Thanks
>		Andrew
> 
