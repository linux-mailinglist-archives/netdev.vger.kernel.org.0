Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D33504E53
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 11:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbiDRJZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 05:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiDRJZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 05:25:03 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98BA15FD8
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 02:22:24 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2edbd522c21so133657417b3.13
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 02:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+E8qxsKDuTHCAufsLPGCpSUBOhpckL3T8xW76CGb8ng=;
        b=GcIRxtCuK/YF/K0XFFXPuQGVkDsymyETmxsKl3OID2grrsRrBcpN2L0kVmUICZOADS
         1azUbQn3fiLEmINartfGQFo1jvOdAPZzeDfHtFwHZkU2cXL5M80DzJiBesAph1TkUSkI
         /6/e9cZIjBmS+agpQLh9aVwtTY8XB/hztkCfathXvpmRL2bmTOC+OLqfbSMksU6lDvWJ
         UoFxYeCnS6e5SzSWr08tLmE5ux/13rG3FUSeiD8Vjty5KO3A+0OcTNPKIXnkG6/Ikt4e
         RlhnJF/gafI66YAdBwy1wA3bkVGXaXFWUtL0tfUEtVGWq1JPYNqVBOjsgKrlTaUQ9evw
         2/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+E8qxsKDuTHCAufsLPGCpSUBOhpckL3T8xW76CGb8ng=;
        b=pBXHHHGIIv1Yfq02bV+LIHKwmDyCwzxFcxvdZEF3UmFdRCPU7U07C86gdT7Oa2l+Y+
         l6mO5v/nLQaWpRcuY6a+h7MVRjeHqkzV2wI/8PZcEPKyMAISHqF+AoE7RrpY5dW4o6zB
         tSU2Ti8fl9deLiAZU+Pcd0/a2q/bya9kWXOhHau6RVb6Lavf3lPiBwiGJm8L8EbB6iHh
         9MqqApF04zpXOOBayQwfQU3RCuyIQnZ7Yu2MTSwcz8GNTz5wMAtiEp9MiXDGxGMUpoo9
         nOTjMJalaAscxhPmTBOTxfjV8XjKmT/U5UUWBDwiia5S+FjfDKbuRE5yTa5guctXBIq3
         G5FQ==
X-Gm-Message-State: AOAM533o1LmF/E0rZVYC3xnuHbyMDWMq7mFGJGYB/T0O7ELqxG9DyfYX
        SsY3ZM2/pV5ZlfMHjdw80PPGKLmGVqRQB7/Ro8g2kOw9pCsCH0OI
X-Google-Smtp-Source: ABdhPJxll3TMwPpScThJdSsadhVDShAElNc5/cbB4qU6OG50pslyCyh+3mVEUcsfiLMY5yKwqQ6uwZeYZIlKKNT0YcA=
X-Received: by 2002:a81:1353:0:b0:2eb:f72c:318b with SMTP id
 80-20020a811353000000b002ebf72c318bmr9387877ywt.240.1650273743476; Mon, 18
 Apr 2022 02:22:23 -0700 (PDT)
MIME-Version: 1.0
From:   Mauro Rossi <issor.oruam@gmail.com>
Date:   Mon, 18 Apr 2022 11:22:12 +0200
Message-ID: <CAEQFVGYURjcCA741koGF5aeRoymwh-h+_evP5cqAxE4U8UVnbA@mail.gmail.com>
Subject: FYI: net/phy/marvell10g: android kernel builing error due to modpost error
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, kabel@kernel.org,
        Chih-Wei Huang <cwhuang@android-x86.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
FYI I am writing based on current ./MANTAINERS file in linux

I am testing the linux build during 5.18 rc cycle,while supporting
android-x86 project for hobby

At the final stage of building  Linux 5.18-rc3 with the necessary AOSP
changes, I am getting the following building error:

  MODPOST modules-only.symvers
ERROR: modpost: "__compiletime_assert_344"
[drivers/net/phy/marvell10g.ko] undefined!
make[2]: *** [/home/utente/r-x86_kernel/kernel/scripts/Makefile.modpost:134:
modules-only.symvers] Error 1
make[2]: *** Deleting file 'modules-only.symvers'
make[1]: *** [/home/utente/r-x86_kernel/kernel/Makefile:1749: modules] Error 2
make[1]: *** Waiting for unfinished jobs....

It never happened before throughout all my previous android-x86 kernel
rc cycle build tests, which spanned from linux version 5.10 to linux
version 5.18rc

I am using AOSP prebuilt llvm toochain, which is mandatory in AOSP
builds because gcc was removed from the AOSP toolchain

/home/utente/r-x86_kernel/prebuilts/clang/host/linux-x86/clang-r383902b1/bin/clang
--version
Android (6877366 based on r383902b1) clang version 11.0.2
(https://android.googlesource.com/toolchain/llvm-project
b397f81060ce6d701042b782172ed13bee898b79)
Target: x86_64-unknown-linux-gnu
Thread model: posix
InstalledDir: /home/utente/r-x86_kernel/prebuilts/clang/host/linux-x86/clang-r383902b1/bin

At the moment I can easily avoid the build breakage by disabling
drivers/net/phy/marvell10g.ko in kconfig (# CONFIG_MARVELL_10G_PHY is
not set)

but I wanted to inform you, becasue I'm not sure if it can be a
problem outside of AOSP/ android-x86 scope and if that's the case, you
are now informed/aware

Your feedback is appreciated
Thank you

Mauro Rossi
android-x86 team
