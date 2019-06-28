Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7070259908
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF1LMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:12:21 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33430 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfF1LMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 07:12:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so9123879wme.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 04:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=54jyw0pGTDpQCq1hRAdoetGwQm4XMLXLsh0TvEN/39E=;
        b=eF1vxc4HT1gNfVcxwDWRmtuImIW4mLbJrYgXsNhWDAydsjddzvbLEQRs/w1K2hhEiB
         eLElc6Ta5biGsHxik2CRF1vQaxjc0snjIJ+7zKoY3EJv9K+CGCXpwCDQlhwXoE3FsKhP
         LLuuS8iI8dp2ejIAyBK+YODZqv6gBIKMuvgubN00gvz7HoiaM53GhJ3CKK7ZHdrnJXOG
         1Ejz1FDpS0CEUTSx2k6ZYzOYAbjtPWqDDqqX1w2pRGfWD8QJLosP5dRtp8dh3wddMcLQ
         2FzXMWOTbt5U5g5WQAyud8lWDhbMdIx2jJlF8VAPQ2VOJ+b4EQ7KUn6PPPlN5CvvFFvF
         NkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=54jyw0pGTDpQCq1hRAdoetGwQm4XMLXLsh0TvEN/39E=;
        b=GYvjJZX+gmr3K3vG9yY/9yGtzdJpV4mZdLn1xsE7EHQdJ2dURWfgDY7gCmMM8D3JNv
         OB+J7KsrMpzebM13aF1J5zgPmVotj716g7XWbc7x60P166KM2srjot4yn5dAijcwfttz
         LXDuG6/wnzXS1Ld+ruX0fGz1F/jJouYB2CVGuXvVt3voUpqllHRFAZtqs3jFG8Z+rpW1
         CvG6SKd34bKePIWCSBF0G0Z0QcKcraNdjNjYE4rATPYXwdCqNYKNeX4FOxxAysSak8m0
         NW8mc+coXbXO2XROKjlxp8N5uerEwhtArKpV7g6cpTnp8YEsE77kKwOMANhhpmORXvlD
         Z8Zw==
X-Gm-Message-State: APjAAAUyZI+WViOBgkjtep3mhjFVKwtcrMj6YGY4LZ6/vlZErhWkaiVl
        tgbheu61EjrC/9T7CUqK0/SrkQ==
X-Google-Smtp-Source: APXvYqx7WTzBBbEcTFc+ZdQ3QyYit6sUIuANS6hoOXz2bDm8ND50AmgBMjQnP/JLCLEohRD99yPwWQ==
X-Received: by 2002:a1c:99ca:: with SMTP id b193mr6743830wme.31.1561720339589;
        Fri, 28 Jun 2019 04:12:19 -0700 (PDT)
Received: from localhost (89-24-40-69.nat.epc.tmcz.cz. [89.24.40.69])
        by smtp.gmail.com with ESMTPSA id f2sm2219472wrq.48.2019.06.28.04.12.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 04:12:19 -0700 (PDT)
Date:   Fri, 28 Jun 2019 13:12:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, David Ahern <dsahern@gmail.com>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190628111216.GA2568@nanopsycho>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
 <20190627180803.GJ27240@unicorn.suse.cz>
 <20190627112305.7e05e210@hermes.lan>
 <20190627183538.GI31189@lunn.ch>
 <20190627183948.GK27240@unicorn.suse.cz>
 <20190627122041.18c46daf@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627122041.18c46daf@hermes.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 27, 2019 at 09:20:41PM CEST, stephen@networkplumber.org wrote:
>On Thu, 27 Jun 2019 20:39:48 +0200
>Michal Kubecek <mkubecek@suse.cz> wrote:
>
>> > 
>> > $ ip li set dev enp3s0 alias "Onboard Ethernet"
>> > # ip link show "Onboard Ethernet"
>> > Device "Onboard Ethernet" does not exist.
>> > 
>> > So it does not really appear to be an alias, it is a label. To be
>> > truly useful, it needs to be more than a label, it needs to be a real
>> > alias which you can use.  
>> 
>> That's exactly what I meant: to be really useful, one should be able to
>> use the alias(es) for setting device options, for adding routes, in
>> netfilter rules etc.
>> 
>> Michal
>
>The kernel doesn't enforce uniqueness of alias.
>Also current kernel RTM_GETLINK doesn't do filter by alias (easily fixed).
>
>If it did, then handling it in iproute would be something like:

I think that it is desired for kernel to work with "real alias" as a
handle. Userspace could either pass ifindex, IFLA_NAME or "real alias".
Userspace mapping like you did here might be perhaps okay for iproute2,
but I think that we need something and easy to use for all.

Let's call it "altname". Get would return:

IFLA_NAME  eth0
IFLA_ALT_NAME_LIST
   IFLA_ALT_NAME  eth0
   IFLA_ALT_NAME  somethingelse
   IFLA_ALT_NAME  somenamethatisreallylong

then userspace would pass with a request (get/set/del):
IFLA_ALT_NAME eth0/somethingelse/somenamethatisreallylong
or
IFLA_NAME eth0 if it is talking with older kernel

Then following would do exactly the same:
ip link set eth0 addr 11:22:33:44:55:66
ip link set somethingelse addr 11:22:33:44:55:66
ip link set somenamethatisreallylong addr 11:22:33:44:55:66

We would have to figure out the iproute2 iface to add/del altnames:
ip link add eth0 altname somethingelse
ip link del eth0 altname somethingelse
  this might be also:
  ip link del somethingelse altname somethingelse

How does this sound?


