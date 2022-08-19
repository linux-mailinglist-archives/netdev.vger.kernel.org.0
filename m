Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B12E59A3BB
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354709AbiHSRgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354715AbiHSRga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:36:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231251636C0
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 09:55:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g18so5206014pju.0
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 09:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=8srtPqHGa40CVslrURYXsHSOfQqBi5LmheASbuMqgVc=;
        b=d3s8Eo2S0d9xH0n37J4Q+C3AQFq3MhSGrjVEIbRr0XJYVpuSSAv9IqivCcgsJ12KT4
         I98BsoqMZSSpMzdbykTJeBQImr8KtPDqZ4mJt0U5H51xkXbu6mzwC9+K4nN68fs3wh3+
         Q+6qnFC8CohlU2CHBGGVwSyHlaSGVt0zZeLliKZbUF0RoeMSVG2DDEnZiSQcg1Nxvhyj
         T/AIPPivH4cCaWWssgcrt7zrOV6q3foMEd/GGvlnMqJI/3VsHe5vNNE5y34GZ+is8whQ
         Komw5Jx0MNhqdA86haXWvUFWvSJCvl1RANNtUljeH54VaBERM5iNVvea50i76qgvr3PY
         y/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=8srtPqHGa40CVslrURYXsHSOfQqBi5LmheASbuMqgVc=;
        b=ZPyr0yhcxAbLPsNNYB+lg75KxnzfL/lGEKK6FPmdsj8/liu3LYsZ/wWfORnQ1vDH3q
         cKGvKwE2diVOaJThQElT/4fHByes6ut9KMooOV+LiEoPoEbOqm8z2IgJVnQ3cOezkV0G
         p6fnqJ4u3JCqc5WnhvHy84GjP5a7A+B0tMTvTgeNixjBWbTy5FPgH8QrLFUoWMq9wO5U
         5OGhJj9D8CyEAqPNcuxFTd6jxsAzeK5RI+ekyFV6rqEcm1pePWl61nAQn84i8dUIYdFT
         0f5DJ89PT07Mam4UiqI2of3l+Daz8tEyK3EvMDWrEmgpo9rGbgZzbMx9GPQ6YU4i8LrV
         9ivw==
X-Gm-Message-State: ACgBeo2QgVthuB5T39ljpZ/SvD2U2ErVZL5t7kehIWFifkMu1BVrAQdu
        wOW6KVMJxhiT7MLPM+Q4umoqDdqqhe3f5ij2dxE=
X-Google-Smtp-Source: AA6agR4HXnioqLbYFRxrV1wv6awT62si4R42MomZEAfq8V73SM3jNQ7elBCimV6B0ceAyHFpNf6sYCKZjaonfIGlgnY=
X-Received: by 2002:a17:902:7883:b0:170:d646:7f00 with SMTP id
 q3-20020a170902788300b00170d6467f00mr5830000pll.164.1660928058384; Fri, 19
 Aug 2022 09:54:18 -0700 (PDT)
MIME-Version: 1.0
Sender: rh924272@gmail.com
Received: by 2002:a17:903:2283:b0:16e:c9bf:94c7 with HTTP; Fri, 19 Aug 2022
 09:54:17 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Fri, 19 Aug 2022 18:54:17 +0200
X-Google-Sender-Auth: cJkAtRVILgaASJRlZ1EgJ3VkmIk
Message-ID: <CAEJ7tdpFcBMq5sG8pPCZspdtQPsZtPtR_e=1LfhamNtXvZfMpw@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,HK_RANDOM_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dearly Beloved In Christ,

Please forgive me for stressing you with my predicaments as I directly
believe that you will be honest to fulfill my final wish before i die.

I am Mrs.Sophia Erick, and i was Diagnosed with Cancer about 2 years
ago, before i go for a surgery i have to do this by helping the
Orphanages home, Motherless babies home, less privileged and disable
citizens and widows around the world,

So If you are interested to fulfill my final wish by using the sum of
$ 11,000,000.00, Eleven Million Dollars, to help them as I mentioned,
kindly get back to me for more information on how the fund will be
transferred to your account.

Warm Regards,
Sincerely Mrs. Sophia Erick.
