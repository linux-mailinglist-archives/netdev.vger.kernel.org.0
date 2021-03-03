Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D6632C3F4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354542AbhCDAJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349084AbhCCIQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 03:16:19 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45718C06178A
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 23:39:36 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id r24so16820891qtt.8
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 23:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:in-reply-to:references:mime-version:date
         :message-id;
        bh=lk+kiBh9DxelRABaLk2WvTMpFyQOXyjGxViqp+7RPXI=;
        b=Mz9oTuemrxw7uBR+VcrPGsG6pHB+52KIN6BJeKwUNPx8s84En3Lrhjex+j3/TiQLi+
         tVvUXi2/nNQIwg2M0JCg8pkCpO1GgDwJf6wUx95Ifkl7Cuj4peb15EWdLBG0WhOAG8BK
         FFBvrXYwwiPFjNyUQ5PdiZdOxbfVm6cZJQdCzUPLJXuk11UN8QfVDCtONVa4ZCBV50YP
         40xECXvD4r7w+NXArFKtf8bbx2jcpV5+AWXzyiEd1GqnrimJM+l4G/cB1Z++5m/T3JFS
         d6uw8tIfrpMg1xH5xRVfsUG0EWHlQAU4wkS6nUxr52rpdtyiALtslLS03t/VQz/Sflf/
         xDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :mime-version:date:message-id;
        bh=lk+kiBh9DxelRABaLk2WvTMpFyQOXyjGxViqp+7RPXI=;
        b=e45Gyp/cmo5beCS6XCuvbnIl/Dr/rqVs7I2NoJhBJhNMt7lU3HwUqizGFaga9p3vPV
         +vMI4lAoN8dFly1/nfCSK/w2RsJkwWlg/3EW2TlqDZKCF4Z1xlTEup8oxdCZj0q7Fqjj
         NqvgsYwuASgb6hS8dlOeQ+I9Lv5xBOyx/rnpuUvRtC/0nNKMULobuFy+Obi1yzVaSpmS
         iI5uD79B56UWxE/sb/jUmcKjGapCkpB45iivOVLzFV0beW3qvzCcXF0CPycXsFfWbZsK
         T+yI3B6G/L0U9O1xPKDZ79hNK2kUND+kxWezXvJK1wIizcHanleJT7Dfxi63LhM/IdV5
         TY7Q==
X-Gm-Message-State: AOAM531mFIz6LDicyrnvI4mEy2CsydAsXLWixFuItBqfEFdKyk7bgfEJ
        jjexNC4EQ1CEvWHyb8ltzHV7Lg==
X-Google-Smtp-Source: ABdhPJxPvd7Frxmqt/j0fMQ16YcnB2/0SAD1ipcbbWo5C64MR7E7k8k0qRXHslgr1Deya7i8L1PjBg==
X-Received: by 2002:aed:3104:: with SMTP id 4mr15149355qtg.341.1614757175369;
        Tue, 02 Mar 2021 23:39:35 -0800 (PST)
Received: from turing-police ([2601:5c0:c380:d61::359])
        by smtp.gmail.com with ESMTPSA id l186sm8591517qke.92.2021.03.02.23.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 23:39:34 -0800 (PST)
Sender: Valdis Kletnieks <valdis@vt.edu>
From:   "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Heiner Kallweit <hkallweit1@gmail.com>
cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: next-20210302 - build issue with linux-firmware and rtl_nic/ firmware.
In-reply-to: <02b966f5-a056-b799-dd6d-c5dc762d42f3@gmail.com>
References: <199898.1614751762@turing-police>
 <02b966f5-a056-b799-dd6d-c5dc762d42f3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Wed, 03 Mar 2021 02:39:34 -0500
Message-ID: <205633.1614757174@turing-police>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 03 Mar 2021 07:51:06 +0100, Heiner Kallweit said:
> > # Firmware loader
> > CONFIG_EXTRA_FIRMWARE="rtl_nic/rtl8106e-1.fw"
> > CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
> > 
> This is wrong, simply remove it.

> > But then I take a closer look at  drivers/net/ethernet/realtek/r8169_main.c
> > #define FIRMWARE_8168D_1	"rtl_nic/rtl8168d-1.fw"
> > #define FIRMWARE_8168D_2	"rtl_nic/rtl8168d-2.fw"
> > #define FIRMWARE_8168E_1	"rtl_nic/rtl8168e-1.fw"

Yes, but then how are *these* filenames supposed to work? Is a userspace helper
supposed to be smart enough to append the .xz, and the EXTRA_FIRMWARE variant
for embedding out-of-tree firmware has to point at an uncompressed version? 

