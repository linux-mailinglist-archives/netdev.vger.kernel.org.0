Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695DE6B58D1
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 07:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCKGCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 01:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjCKGCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 01:02:45 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC35312B672
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 22:02:43 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id da10so29135233edb.3
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 22:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678514562;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JEkw1KmmzfmMdZjy2G/k2kJ9Rp06l3CUoffIihDDUro=;
        b=crx3dMbHerSWPpQIsWenrlpvgyE7zbUbY7tCd25PnewjLeSwPPPszH5GMG8Hdo2Sd9
         qh2LnLNoTUtgc7amf9M59HhbyFe07DKFMjplOScsL/MvEGQwFvRR2F0sKWIfBcQqv02T
         EglBUPPZXjkhY1FkM5jCe4eVja5oLVCj0LbSWjaOiT9/FaP3LpqB9uYpGsIs1yYQxjC9
         +fhlITMw0+UzQORzqPTukv4Zl7KJ4KR+RtpNMmhVhS9GpJluyDf1mL9Wv4Yr+ZJzOtak
         rhC8tJ9hyHluOpUg0E1Ive4BRL1RH3dXgqBSHm4up9vW7xF2enCspEk8q3n6LXdlT+iv
         x+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678514562;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JEkw1KmmzfmMdZjy2G/k2kJ9Rp06l3CUoffIihDDUro=;
        b=28k2xlbT0Cpgg9eR3eMz4AmiplWwZjLNc+WYjbJb1Dw4MWTCkPhlLUuTHABzqSLzmm
         6AXGnm+/SdXwMJeXYgE9RyLBxGHnoi6Rvzf59zXeYliVggOFiSgzWnW/aBUoLabMHPOe
         9d9//mGm7GbpF7DWHFMB5vNGX5X+hNvaRF3xOc7m6vmaM8cayp/aIWUYjuX6LARgYfwm
         I1l/VnIHlwECCQkfKbZ1TeP+esXTFgeL3zObf4J6lqOeDS1dmBbwZMlnL+SiKgHISZLM
         r7WACXhtReikX81O2CrLclfYGFcToCLH4gZcMWNLfbCRJG1wBv7pH/QXmhoDSSqcgvg5
         35oA==
X-Gm-Message-State: AO0yUKXPkg17ANrJTxknpLOAqs545soLDZIVV6/Xsm9zSlc5/qhyYXJw
        lxcCQiM49dFUHj+XkyTYeSLEgpjwUkSXCs7gcWg=
X-Google-Smtp-Source: AK7set/oBqRkEYi6v7bttLnWry4U8X0wXTUOE4vMlO5hD9Hng3VdSgldMhdkMimA97PFxGWArF3j598wFsYVM5UJzqk=
X-Received: by 2002:a50:8e50:0:b0:4aa:a4f1:3edc with SMTP id
 16-20020a508e50000000b004aaa4f13edcmr2430197edx.7.1678514562058; Fri, 10 Mar
 2023 22:02:42 -0800 (PST)
MIME-Version: 1.0
Sender: mohamedazzouzi77@gmail.com
Received: by 2002:a05:7412:a70c:b0:c1:2c5a:1406 with HTTP; Fri, 10 Mar 2023
 22:02:41 -0800 (PST)
From:   AVA SMITH <avasmith1181@gmail.com>
Date:   Sat, 11 Mar 2023 06:02:41 +0000
X-Google-Sender-Auth: 8_OGYmapQmSTHP1HDhHd_NoHEKE
Message-ID: <CAC-Hp7s4mD5LR7tCB3M9DGN1vCjXa-iFOJYFW=mfTze6NyuXEg@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
My name is Dr Ava Smith,a medical doctor from United States.I have
Dual citizenship which is English and French.I will share more details
about me as soon as i get a response from you.

Thanks
Ava
