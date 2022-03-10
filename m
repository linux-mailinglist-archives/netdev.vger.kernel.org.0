Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A026F4D3F1D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 03:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbiCJCCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 21:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiCJCCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 21:02:19 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B33C47062
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 18:01:15 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id u3so8119743ybh.5
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 18:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=4SL1/qbkTptdsuZGoXAM80S4DBJva1Vt53CdfbCl4nw=;
        b=By/kOv/einCuW8ofNc5Wdxu/0tbMnOU0GJsLYJlWXemmewMcO3x9yXMK144Yqt1NcL
         Paj4zPh5ZS5lL0BIw+fsvAqsr7WnGAdUAwz5MsyuhJiHt9SlvCQLE4PUz9TZrb0EFFI5
         iSaEP/qhsTebwqIrIXOrLqLTvgiGird9LYay0dADWNgmpoEYmnebIQVAfyMNfkof7veU
         vQzrtKPvQybusBSEoN9zhvStibj+TiS0ef0k+KLHJ5MgGwOYnZlEJdO9sgzdCEpJ6G0N
         sgaUQX67oFyt285+ZWzW60wl+28c5HKwNyzky5Ntnq82zJErvyjyV3CS81Ukiodfil9t
         NuQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=4SL1/qbkTptdsuZGoXAM80S4DBJva1Vt53CdfbCl4nw=;
        b=PJyUyAb0Fi6vyRRsS6Np942XCTwZt353NFyMm+VErly10qlb5HtTk1xojHkhyU9ReF
         VUeabpqvFJipjUsivhuKpt6L7/wT5IoXDCf0PjCFTGPyFSu2N+bLigjEaYMZ5iV0ZaGW
         8gaHlW9PXVcGaYlNsvBlBqdKrU/D/K3hSuKpYTWa6KJzT/h+jhdfLT6b2XScj1bLS0JM
         Tw9rSLBRQPgP7B93z7RESrwDP9plkbar3W3TZziV+T73zci8KFxVCfZfGZDWD2wj//6X
         qJiMcoBDLB7dOADJtV+CoiL3X/Pns32qqC0UWdtgY2hQBCFkRW5LAh7jZgGRtlG+U9S1
         lRbg==
X-Gm-Message-State: AOAM531SX7moznF1nW/0h2TeVOyyR2C+a0MG4D9/atIPXKnO2ZvBtN8I
        255od8r/EE7SEb8Lvs9ex4wvxGvEElxgl+0eq9G23b+QxW4=
X-Google-Smtp-Source: ABdhPJxS7b44EOArv8SGjTLdwQ/8Fyv5893XK8XOWfOkjLgkRaOyltD/wqr82EA41bkBpgkcCGW88sDCV+1xer5IH2k=
X-Received: by 2002:a25:dacf:0:b0:629:15d8:647d with SMTP id
 n198-20020a25dacf000000b0062915d8647dmr2271669ybf.142.1646877674643; Wed, 09
 Mar 2022 18:01:14 -0800 (PST)
MIME-Version: 1.0
Sender: mytreasunta@gmail.com
Received: by 2002:a05:7110:4b18:b0:170:2342:a548 with HTTP; Wed, 9 Mar 2022
 18:01:14 -0800 (PST)
From:   "Mrs. Latifa Rassim Mohamad" <rassimlatifa400@gmail.com>
Date:   Wed, 9 Mar 2022 18:01:14 -0800
X-Google-Sender-Auth: mFGjLva11lEn-dlhoHuVxF_rRKU
Message-ID: <CALAC0A3H8vwvO3U44X3Rer0FfcT=Z2Z9MfbM7Yj7n6e49cYEfA@mail.gmail.com>
Subject: Hello my beloved.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_NAME_FM_MR_MRS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings dears,

Hello my dear Good evening from here this evening, how are you doing
today? My name is Mrs.  Latifa Rassim Mohamad from Saudi Arabia, I
have something very important and serious i will like to discuss with
you privately, so i hope this is your private email?

Mrs. Latifa Rassim Mohamad.
