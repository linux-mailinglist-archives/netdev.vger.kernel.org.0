Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD11E390B95
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 23:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhEYViw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 17:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhEYViv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 17:38:51 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70C4C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 14:37:21 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v14so21083248pgi.6
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 14:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rRmvTeU//SmQEOsbkq8wsTrrFA+E1bsgoIT7Qra9P8Y=;
        b=oC7cjVNfiP5aGFmDPP8lu5UWSsUlL9/s9dXGaE2TSoKLK6ujDbxy1EVCl/9WH0ihkG
         f708V0UBvegKCl6IGv3EqVxQ7k+/WUrVq1CRxDnTXAOdKBeGD5go9cFEmprL/Gpzzmp4
         G9mmmMRi545au8/U1K2lvMPwZKgtxQSV2GiYIWADNnEybfM1gscOus4QhBiHWoUQ7DKn
         pFV9JgLkuo3QvZ6pS6uOvDej0WgeT44OyKJKGPOrF+WmqNi1gD1PHPUQHBcsarZErYPi
         bBbV8jZzbNKDBPcCifvyAMrD2bFE/myo83QK76d3nSkqMO1T78EAICE9SfQ0niBCjoob
         Qp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rRmvTeU//SmQEOsbkq8wsTrrFA+E1bsgoIT7Qra9P8Y=;
        b=QByPo0adDK6cRJNAoxa0+H1uTfOafzxs4w5peL/tIIiOVJF76juPL2KohVzFMjgQri
         Om/QINFyxwh5Ud01wJQTZlqOYOi8jWA7zAeHUvLc5SpRLBWYKRIAAPDGf7fSMzBQezRI
         NCbzN8w7hWVH6yTyCNvy/5WmnUEnlI3ti1YmU3J7Zxk50OQqzxUgzOj3d2H9LHIcGMpi
         mFa4Iy6IpPpuBF5xdxYPsUNz3+RPjKfKGcwFEWU4uRsZ3l4OiBT/MHfMJQSH8fRZwBTQ
         FxfEX8SXT3gTrG4PVC+d2NeLzu6comDwAjJJu5eennHnEEBZyPIk1KjQC/q3fingRe2s
         9gmQ==
X-Gm-Message-State: AOAM533wSRvILI8EqeafLItZ8xP03lXQebRj+IsujmCe6mUifmCWRf2O
        AgWBB3qQuTG/9yMxoKoXoHrXNYR3/PyZVQ==
X-Google-Smtp-Source: ABdhPJyztiGSU5uCrqOCyhcPE3GOsy/8nulEMAXltngQMoTmnQKdSTS3QNzoIDUHBLYvBLRMKcHUUQ==
X-Received: by 2002:a63:4607:: with SMTP id t7mr20792637pga.269.1621978641128;
        Tue, 25 May 2021 14:37:21 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id s12sm2763426pji.5.2021.05.25.14.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 14:37:20 -0700 (PDT)
Date:   Tue, 25 May 2021 14:37:12 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org
Subject: Re: Crosscompiling iproute2
Message-ID: <20210525142331.39594c34@hermes.local>
In-Reply-To: <trinity-3a2b0fba-68a6-47d1-8ed1-6f3fc0cf8200-1621966719535@3c-app-gmx-bs13>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
        <20210516141745.009403b7@hermes.local>
        <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57>
        <20210517123628.13624eeb@hermes.local>
        <D24044ED-FAC6-4587-B157-A2082A502476@public-files.de>
        <20210524143620.465dd25d@hermes.local>
        <AACFD746-4047-49D5-81B2-C0CD5D037FAB@public-files.de>
        <20210525090846.513dddb1@hermes.local>
        <trinity-3a2b0fba-68a6-47d1-8ed1-6f3fc0cf8200-1621966719535@3c-app-gmx-bs13>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 May 2021 20:18:39 +0200
Frank Wunderlich <frank-w@public-files.de> wrote:

> > Gesendet: Dienstag, 25. Mai 2021 um 18:08 Uhr
> > Von: "Stephen Hemminger" <stephen@networkplumber.org>
> > An: "Frank Wunderlich" <frank-w@public-files.de>
> > Cc: netdev@vger.kernel.org
> > Betreff: Re: Crosscompiling iproute2
> >
> > On Tue, 25 May 2021 17:56:09 +0200
> > Frank Wunderlich <frank-w@public-files.de> wrote:
> >  
> > > Am 24. Mai 2021 23:36:20 MESZ schrieb Stephen Hemminger <stephen@networkplumber.org>:  
> > > >On Mon, 24 May 2021 21:06:02 +0200
> > > >Frank Wunderlich <frank-w@public-files.de> wrote:
> > > >  
> > > >> Am 17. Mai 2021 21:36:28 MESZ schrieb Stephen Hemminger  
> > > ><stephen@networkplumber.org>:  
> > > >> >On Mon, 17 May 2021 09:44:21 +0200
> > > >> >This works for me:
> > > >> >
> > > >> >make CC="$CC" LD="$LD" HOSTCC=gcc  
> > > >>
> > > >> Hi,
> > > >>
> > > >> Currently have an issue i guess from install. After compile i install  
> > > >into local directory,pack it and unpack on target system
> > > >(/usr/local/sbin).tried  
> > > >>
> > > >> https://github.com/frank-w/iproute2/blob/main/crosscompile.sh#L17  
> > > >  
> > > >>
> > > >> Basic ip commands work,but if i try e.g. this
> > > >>
> > > >> ip link add name lanbr0 type bridge vlan_filtering 1  
> > > >vlan_default_pvid 500  
> > > >>
> > > >> I get this:
> > > >>
> > > >> Garbage instead of arguments "vlan_filtering ...". Try "ip link  
> > > >help".  
> > > >>
> > > >> I guess ip tries to call bridge binary from wrong path (tried  
> > > >$PRFX/usr/local/bin).  
> > > >>
> > > >> regards Frank  
> > > >
> > > >No ip command does not call bridge.
> > > >
> > > >More likely either your kernel is out of date with the ip command (ie
> > > >new ip command is asking for
> > > >something kernel doesn't understand);  
> > > I use 5.13-rc2 and can use the same command with debians ip command
> > >  
> > > >or the iplink_bridge.c was not
> > > >compiled as part of your compile;
> > > >or simple PATH issue
> > > >or your system is not handling dlopen(NULL) correctly.  
> > >
> > > Which lib does ip load when using the vlanfiltering option?  
> > It is doing dlopen of itself, no other library
> >  
> > >  
> > > >What happens is that the "type" field in ip link triggers the code
> > > >to use dlopen as form of introspection (see get_link_kind)  
> 
> this seems to be the problem:
> 
> openat(AT_FDCWD, "/usr/lib/ip/link_bridge.so", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = -1 ENOENT (No such file or directory)
> write(2, "Garbage instead of arguments \"vl"..., 71Garbage instead of arguments "vlan_filtering ...". Try "ip link help".
> 
> i have no /usr/lib/ip directory, my package contains only lib-folder for tc (with dist files only because i use static linking). also there is no *.so in my building-directory

That only gets called if you haven't got the bridge part in the original ip command.
The shared library stuff is for other non-static libraries to extend iproute2.
This is unused by most distro's and you shouldn't need it.

I think the bridge part was just not built in your version.
