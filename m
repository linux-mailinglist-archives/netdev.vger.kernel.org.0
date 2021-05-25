Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D137D390637
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 18:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhEYQKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 12:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbhEYQKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 12:10:24 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D821C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 09:08:55 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q16so802466pls.6
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 09:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HcqwBsU7eC6M5QJIqTovK6cmcoODNXg3/XVP0eboCiM=;
        b=Oa0NK/I4FeAeqKCl7C9KEsQ5TsiTZEhFds3eG5++Ju4UwzgaODfzAon/gF9Tt7i7HT
         K/mKtC7wN3zvK0a3CMOPLCnN+jJe7ufAzXDi3JqPsCPHp5BTmsr6g0GYwmc2ICCpgOaT
         BcuyAgeK1VU/5ejyFOoRAH/XkvWPaomkwk501eXDp4UxCm5E5h/9seF71hXJM3jP7LSj
         LiS7s+kCuoKSnfhipA8H7Acl4hp6FcSVx8nLqQnNjWPmeKeJkwnWnjYeEZbRHBFEMho9
         23vKJM+hG7OT3u2SzIYYqWFZxSZoQdOEEfj+CQIn0RflcCxyFLmA8yZ5VP5sa4Lcbh92
         447Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HcqwBsU7eC6M5QJIqTovK6cmcoODNXg3/XVP0eboCiM=;
        b=s/mZB5Pi4O7j7+lJS1PHzXfDQw17fbaMEoXe+o+HVZ5XPc6i+/+mh30yzR09nfV22C
         mGeDQHmz0ND8kv71N0jhJSYA0yIqylP8/osvTb9ruTDyHJXjJpQx3Y5rqQX15LbzydZn
         bhiy9Dq2dzurwef5to+1m37TERGCbjr3mHGM3MKyCFnRvH/zYLbaPP91GStgV0nLW0iX
         Oj0j+yemueyN9FHj7rxSTLfaLkxu9OOSTj5lt47xq1lUoI353e5uwk9FeYYnrnFKQw6S
         l/qYbWA+ZgLo5HxUhxD/gI+6el10aLbGN+N0LilC9m7E7tHYzZDQ9LGY+NE2zDIszpwY
         Hf/g==
X-Gm-Message-State: AOAM530fCq0wVK24C/JtVRVCQ2RykXIU6X/9tgZImHuKx8mlz2GEIjue
        87tSlRtfdCn/couan91/XNDE1sTG/mU2Wg==
X-Google-Smtp-Source: ABdhPJz2wYfu09r5abaLMCIaZFdYwSTtj+La9yGCt/quAvoL921GB7DrB/tUHWV+fyAUqp2rjaot6g==
X-Received: by 2002:a17:902:f68f:b029:ef:919c:39f2 with SMTP id l15-20020a170902f68fb02900ef919c39f2mr31436124plg.41.1621958934573;
        Tue, 25 May 2021 09:08:54 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id m1sm2326398pjo.10.2021.05.25.09.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 09:08:54 -0700 (PDT)
Date:   Tue, 25 May 2021 09:08:46 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org
Subject: Re: Crosscompiling iproute2
Message-ID: <20210525090846.513dddb1@hermes.local>
In-Reply-To: <AACFD746-4047-49D5-81B2-C0CD5D037FAB@public-files.de>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
        <20210516141745.009403b7@hermes.local>
        <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57>
        <20210517123628.13624eeb@hermes.local>
        <D24044ED-FAC6-4587-B157-A2082A502476@public-files.de>
        <20210524143620.465dd25d@hermes.local>
        <AACFD746-4047-49D5-81B2-C0CD5D037FAB@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 May 2021 17:56:09 +0200
Frank Wunderlich <frank-w@public-files.de> wrote:

> Am 24. Mai 2021 23:36:20 MESZ schrieb Stephen Hemminger <stephen@networkplumber.org>:
> >On Mon, 24 May 2021 21:06:02 +0200
> >Frank Wunderlich <frank-w@public-files.de> wrote:
> >  
> >> Am 17. Mai 2021 21:36:28 MESZ schrieb Stephen Hemminger  
> ><stephen@networkplumber.org>:  
> >> >On Mon, 17 May 2021 09:44:21 +0200
> >> >This works for me:
> >> >
> >> >make CC="$CC" LD="$LD" HOSTCC=gcc    
> >> 
> >> Hi,
> >> 
> >> Currently have an issue i guess from install. After compile i install  
> >into local directory,pack it and unpack on target system
> >(/usr/local/sbin).tried  
> >> 
> >> https://github.com/frank-w/iproute2/blob/main/crosscompile.sh#L17  
> >  
> >> 
> >> Basic ip commands work,but if i try e.g. this
> >> 
> >> ip link add name lanbr0 type bridge vlan_filtering 1  
> >vlan_default_pvid 500  
> >> 
> >> I get this:
> >> 
> >> Garbage instead of arguments "vlan_filtering ...". Try "ip link  
> >help".  
> >> 
> >> I guess ip tries to call bridge binary from wrong path (tried  
> >$PRFX/usr/local/bin).  
> >> 
> >> regards Frank  
> >
> >No ip command does not call bridge.
> >
> >More likely either your kernel is out of date with the ip command (ie
> >new ip command is asking for
> >something kernel doesn't understand);  
> I use 5.13-rc2 and can use the same command with debians ip command
> 
> >or the iplink_bridge.c was not
> >compiled as part of your compile;
> >or simple PATH issue
> >or your system is not handling dlopen(NULL) correctly.  
> 
> Which lib does ip load when using the vlanfiltering option?
It is doing dlopen of itself, no other library

> 
> >What happens is that the "type" field in ip link triggers the code
> >to use dlopen as form of introspection (see get_link_kind)  
> 
> I can use the command without vlan_filtering option (including type bridge).
> 
> Maybe missing libnml while compile can cause this? had disabled in config.mk and was not reset by make clean,manual delete causes build error,see my last mail
> 
> You can crosscompile only with CC,LD and HOSTCC set?

libmnl is needed to get the error handling and a few other features.

