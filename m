Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D6A5A012
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfF1P42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:56:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52240 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfF1P42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:56:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so9583143wms.2
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CDhLiF/eEIk8G3O4TQsXrkRKxT5q5gOs2ZF8ZLdzvLg=;
        b=pd2HL+WWTi26rZMmVSnMt4uH/FBGSP7ju0tNJV7HcjRE4WIfajMv+F95MziGx/fp2t
         1Dbk33ieGhLvQkeXEyFDd3ussa1/K8Dj/ZfXkofsvEM4fNQ2xtMMZNTgrevNHzpUnsbT
         IX4e5h+mF2bUpmjEhW6BmCS8h9yrQ2dECSZZV9bfGrqkbO8DIOl7bHdFsywndYK+LHJe
         xp3BW+QtMaVWQ67F2/LyASR3uE/NxIn/A+g31SfJsTUsBtmmOIr/RCvbFSLFPrG+R8yE
         MDlphqZOFCSd/cwxCO9GywAzpluaSSd6130KxdeuSUL7pPiq9l9RV8SL5QNQ4z9P9n6v
         bi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CDhLiF/eEIk8G3O4TQsXrkRKxT5q5gOs2ZF8ZLdzvLg=;
        b=R+dFUXb8DyRZ8HqYdES9iasq0P6DU1I9bSJaU47EYAhpiN0/AMkWyAiJfL0rMVesbA
         mdZK8uecy8RzeVxkL7BQGe2wXQUngd474ZcodMLAaxS+/bYuqSZIpSdInZF+6Ojbt0BG
         2JHo/EyEiQT8Xre+KRJ46BUSqTRcs+lPpSaSuzXZseir8Z4GnkUAe9XT7Qahud9K2QCr
         VTEfkpM02rsI0IqzyCLNJoj2leHCvH+A/szZ+/817lCajguvR0I4hvm7LSJ12asBf6xN
         xO8f6pQ5aJSWhFUafEU/KYw54n2MX4xhmhdOhtcrB3mSZF9cEQeGw8vkCPzHCxnAF0J4
         pcPw==
X-Gm-Message-State: APjAAAUwOCPsDZ7otmuV9MrWOr9pMDFiYh1qn+drh0O8TEeDZd1buc36
        mLuFw2tNbVaHea4F15wN+0UxzA==
X-Google-Smtp-Source: APXvYqx+TGYtoo4k5CwKORkEupEXBReYsGyNOG5lv0Ev+34BDvXvFUhLzNgAwlJ218H7zxunt6Zr7g==
X-Received: by 2002:a1c:7a15:: with SMTP id v21mr7637736wmc.176.1561737386100;
        Fri, 28 Jun 2019 08:56:26 -0700 (PDT)
Received: from localhost (ip-89-176-222-26.net.upcbroadband.cz. [89.176.222.26])
        by smtp.gmail.com with ESMTPSA id y44sm2974663wrd.13.2019.06.28.08.56.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 08:56:25 -0700 (PDT)
Date:   Fri, 28 Jun 2019 17:56:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190628155624.GB6640@nanopsycho>
References: <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
 <20190627180803.GJ27240@unicorn.suse.cz>
 <20190627112305.7e05e210@hermes.lan>
 <20190627183538.GI31189@lunn.ch>
 <20190627183948.GK27240@unicorn.suse.cz>
 <20190627122041.18c46daf@hermes.lan>
 <20190628111216.GA2568@nanopsycho>
 <20190628131401.GA27820@lunn.ch>
 <20190628135553.GA6640@nanopsycho>
 <20190628084447.186a0efb@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628084447.186a0efb@hermes.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jun 28, 2019 at 05:44:47PM CEST, stephen@networkplumber.org wrote:
>On Fri, 28 Jun 2019 15:55:53 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> Fri, Jun 28, 2019 at 03:14:01PM CEST, andrew@lunn.ch wrote:
>> >On Fri, Jun 28, 2019 at 01:12:16PM +0200, Jiri Pirko wrote:  
>> >> Thu, Jun 27, 2019 at 09:20:41PM CEST, stephen@networkplumber.org wrote:  
>> >> >On Thu, 27 Jun 2019 20:39:48 +0200
>> >> >Michal Kubecek <mkubecek@suse.cz> wrote:
>> >> >  
>> >> >> > 
>> >> >> > $ ip li set dev enp3s0 alias "Onboard Ethernet"
>> >> >> > # ip link show "Onboard Ethernet"
>> >> >> > Device "Onboard Ethernet" does not exist.
>> >> >> > 
>> >> >> > So it does not really appear to be an alias, it is a label. To be
>> >> >> > truly useful, it needs to be more than a label, it needs to be a real
>> >> >> > alias which you can use.    
>> >> >> 
>> >> >> That's exactly what I meant: to be really useful, one should be able to
>> >> >> use the alias(es) for setting device options, for adding routes, in
>> >> >> netfilter rules etc.
>> >> >> 
>> >> >> Michal  
>> >> >
>> >> >The kernel doesn't enforce uniqueness of alias.
>> >> >Also current kernel RTM_GETLINK doesn't do filter by alias (easily fixed).
>> >> >
>> >> >If it did, then handling it in iproute would be something like:  
>> >> 
>> >> I think that it is desired for kernel to work with "real alias" as a
>> >> handle. Userspace could either pass ifindex, IFLA_NAME or "real alias".
>> >> Userspace mapping like you did here might be perhaps okay for iproute2,
>> >> but I think that we need something and easy to use for all.
>> >> 
>> >> Let's call it "altname". Get would return:
>> >> 
>> >> IFLA_NAME  eth0
>> >> IFLA_ALT_NAME_LIST
>> >>    IFLA_ALT_NAME  eth0
>> >>    IFLA_ALT_NAME  somethingelse
>> >>    IFLA_ALT_NAME  somenamethatisreallylong  
>> >
>> >Hi Jiri
>> >
>> >What is your user case for having multiple IFLA_ALT_NAME for the same
>> >IFLA_NAME?  
>> 
>> I don't know about specific usecase for having more. Perhaps Michal
>> does.
>> 
>> From the implementation perspective it is handy to have the ifname as
>> the first alt name in kernel, so the userspace would just pass
>> IFLA_ALT_NAME always. Also for avoiding name collisions etc.
>
>I like the alternate name proposal. The kernel would have to impose  uniqueness.
>Does alt_name have to be unique across both regular and alt_name?

Yes. That is my idea. To have one big hashtable to contain them all.


>Having multiple names list seems less interesting but it could be useful.

Yeah. Okay, I'm going to jump on this.

