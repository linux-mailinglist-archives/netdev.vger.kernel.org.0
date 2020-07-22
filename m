Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F167B22A15A
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbgGVV1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGVV1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 17:27:32 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCA0C0619E1
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 14:27:31 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id t11so1932503pfq.11
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 14:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hl2XuNuNkAqex2SGnJNgB8ZMRNf7wyWxPXDL2QCMQCc=;
        b=mgwniwRsEe3aJN2pXVHZ2zBgVy8NORfYLvjdNRgHWHCEQ4Wkrn9p2yfMuUDiBFb4Fn
         kaqO3XN3wo64Xg9hfvgVIXaUnUrrwnpclaaewiaMO/hXO/KyyWEDyHRaG3MUCFvmOlZy
         ACq78xBj4KFTrrohmGNnOPRN1Ln6a88C3qcuoCh4UZjgMCmVJRYds3aJs1v+oQCagsMN
         /5rG0btcGC/KbooFPkuA2mpgkkmiyndtmGdbz75ZtHx8iceCMcMXy2cBwoxH/kCEQ2hB
         ncN5xjm4wnQ2yXSRjVlMXkjOLFC0Auwae+mBgwKMZbqcuMl4+ttNv9TS+V/RU8FvaC+3
         ktig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hl2XuNuNkAqex2SGnJNgB8ZMRNf7wyWxPXDL2QCMQCc=;
        b=iYgiUHLxqmlb3WIapIAtiLoCyQi00oHANokrqqzqD17CWIhzLpwx1I56u2b3MCHogF
         QCpr9NrCCC+pOZ1dLYOTZBEOs5XQVw08g5BS5bBe3EvZk2kWP1sbqorHIyPpOYbxTvDn
         Y8HvAYy9mMS+mNF6BrDWNEAUNRF5lXlUuX2nEfRmVRkMThdB5k0LODHn5wD6i9NKUx48
         nXSdTGIXbwWWrB7UiKBId80HNcl6slvp2Ij+pbq0uYjGHzlidsg8fMWXczkkqZqhxQS7
         K/BzkhyUEhScGECg2e0418VXPN7JYhhoT2+tPhre/WJgfkRjOtGqeYjG2SGUU8GmmZ7S
         +Ysg==
X-Gm-Message-State: AOAM531NAgVFFcABi6+w2krBv2msulZlxOgrwS76XYQxVIt+srAaKXrr
        rmQX6vVyS8sRL3Dt/MOZFcWdiQ==
X-Google-Smtp-Source: ABdhPJyBYNk1Gesb1dS12vZOz9EIgl5P+POV45wQeYpM5xKGF2/3FchyKvbb8/EHEbFg5mReegGl0Q==
X-Received: by 2002:a63:ca11:: with SMTP id n17mr1485450pgi.439.1595453251341;
        Wed, 22 Jul 2020 14:27:31 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 129sm536531pfv.161.2020.07.22.14.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 14:27:31 -0700 (PDT)
Date:   Wed, 22 Jul 2020 14:27:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Miller <davem@davemloft.net>
Cc:     wangxiongfeng2@huawei.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net-sysfs: add a newline when printing 'tx_timeout'
 by sysfs
Message-ID: <20200722142722.24ce28c7@hermes.lan>
In-Reply-To: <20200722.132311.31388808811810422.davem@davemloft.net>
References: <1595314977-57991-1-git-send-email-wangxiongfeng2@huawei.com>
        <20200721.153632.1416164807029507588.davem@davemloft.net>
        <20200722082741.1675d611@hermes.lan>
        <20200722.132311.31388808811810422.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 13:23:11 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <stephen@networkplumber.org>
> Date: Wed, 22 Jul 2020 08:27:41 -0700
> 
> > On Tue, 21 Jul 2020 15:36:32 -0700 (PDT)
> > David Miller <davem@davemloft.net> wrote:
> >   
> >> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> >> Date: Tue, 21 Jul 2020 15:02:57 +0800
> >>   
> >> > When I cat 'tx_timeout' by sysfs, it displays as follows. It's better to
> >> > add a newline for easy reading.
> >> > 
> >> > root@syzkaller:~# cat /sys/devices/virtual/net/lo/queues/tx-0/tx_timeout
> >> > 0root@syzkaller:~#
> >> > 
> >> > Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>    
> >> 
> >> Applied, thank you.  
> > 
> > Could you add  
> 
> Stephen, of all people you should know by now that all of my commits
> are %100 immutable.  So commit log changes cannot be made after I've
> applied the patch, ever.

Will you send it to stable tree?
It could be added then.
