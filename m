Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9AA52BCDB
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbiERNtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238307AbiERNti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:49:38 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA0D1A6ACB
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:37 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2ef5380669cso24845037b3.9
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=/uSQZYQC48Xh2e0RFjJ15gMwehueueWJuEM4ni7IAqM=;
        b=Y2aFu9K0BTRGI2n7MUc9dau75LbpGzCHltRngu7vm4TRJI7KDwyOikctoIx09chBDB
         EH984hCxhjYrvvVXreT5fVZCvK4DcaQWYChptfXZTcjWaWt/EbarmXO9Qnofcy2h+Po0
         PjpGQrEkp66TixNwSfA3n8O25ono7XEPD+via+Tw0azVa2ylNFq4znhj7giywdE8KceU
         aW7+glvKjdRki5uALy6kEeuIQ6zsE1QjDEjw2GtcoknnH1QeRKlMmtPLbM+ufy6mA+iz
         wqnjiae5Km04nHv6MxSDrU9p1hTK1Tbv/kLbp3lFKUDTGRK5EvAD4djqLu0TKAD/NvSy
         VuLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=/uSQZYQC48Xh2e0RFjJ15gMwehueueWJuEM4ni7IAqM=;
        b=R/T0aNzaI2CTZVwDZYrORsAsOQC2VnZ9wYaqoYUuD2/DQvxp+yAr3flEmHyKrfl8wT
         qVHNXLHAh5JFEec07pzSvef8uO2pdLGMV2V3jwomvf1gfMlNbZk3PlTKbLCXLGd/H9e3
         Rzn8u65KjwAccLTGi5ejXe8jvI0uqfpLxmiVKtYy8OTMGKiVoT0K9Iga5HKkzCiby8ug
         wiGf3hZgZsv3oBcdmnYKBiZ4O9Ohct63VR9yh6dDKx2kwI29adesUe//ROdFedqeZLSL
         LancY5kKH2pCc/XaXpNC/gVoVryJojfOJ4rscXDuIF6cKT1Aobfcv0HD4mS+gYYC//Og
         /tMQ==
X-Gm-Message-State: AOAM532OKy78xVZZh+I6Dk1FXdkIVwngTHMnz2vaoMhqlFa0v1gdiSPQ
        q8ynBJXEbcjper6WQZL6TFULlODPVNp/p66VWFHRf522nbGuIQ==
X-Google-Smtp-Source: ABdhPJzw1z+kfHZISgByJwPHuHAXbNlF06gRJA5E1r7mTarvzL0wb6gQ289QrQYAKn8Bdtg4HI5xklVJIACphkx4MJo=
X-Received: by 2002:a05:690c:443:b0:2fe:eefc:1ad5 with SMTP id
 bj3-20020a05690c044300b002feeefc1ad5mr17673105ywb.199.1652881776372; Wed, 18
 May 2022 06:49:36 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 May 2022 19:19:24 +0530
Message-ID: <CA+G9fYuCzU5VZ_nc+6NEdBXJdVCH=J2SB1Na1G_NS_0BNdGYtg@mail.gmail.com>
Subject: net/ethernet/dec/tulip/eeprom.c:120:40: error: 'struct pci_dev' has
 no member named 'pdev'; did you mean 'dev'?
To:     Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, eike-kernel@sf-tec.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Linux next-20220517 and next-20220518 arch parisc builds failed.

Regressions found on parisc:
 - gcc-8-defconfig
 - gcc-9-defconfig
 - gcc-11-defconfig
 - gcc-10-defconfig

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=parisc
CROSS_COMPILE=hppa-linux-gnu- 'CC=sccache hppa-linux-gnu-gcc'
'HOSTCC=sccache gcc'
arch/parisc/kernel/vdso32/Makefile:30: FORCE prerequisite is missing
drivers/net/ethernet/dec/tulip/eeprom.c: In function
'tulip_build_fake_mediatable':
drivers/net/ethernet/dec/tulip/eeprom.c:120:40: error: 'struct
pci_dev' has no member named 'pdev'; did you mean 'dev'?
  120 |   tp->mtable = devm_kmalloc(&tp->pdev->pdev, sizeof(struct mediatable) +
      |                                        ^~~~
      |                                        dev
make[6]: *** [scripts/Makefile.build:295:
drivers/net/ethernet/dec/tulip/eeprom.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log link,
https://builds.tuxbuild.com/29HszOsHU1On0kNlZbdJBfNWstp/

--
Linaro LKFT
https://lkft.linaro.org
