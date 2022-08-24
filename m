Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69BC59FE37
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbiHXPZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239519AbiHXPYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:24:54 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D1E18B14
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:24:47 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id a15so12912468qko.4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=ELGMVBs/2lqAFK164PRaOaF0dnyEe9SZFRcUZhXXTNw=;
        b=YRebCUnsGZYXN7jV+0n/2c63iHigmbNfDGJ/r6nMJbCCZ22fFqJzQut4RxP/fYdHL2
         OeLlkwRGizboJbEBFLDWZ7BkovPWFIfw34xMIgEDfC2eJsc1E/1NZ2uZkMrIMC1TwDwk
         fDw9X61jkiEhuqa7LtDUOrKeC6nmt7ITbEPKw+euCTVdxYQjEAGF5v9VGzH9zB0LObah
         +yCOf7HoVvsn/qH/YzyUwcifZwHKkXOnG26/DQsyzDbGzsb3UjJ0OJ6fijchAe8XQyD5
         Q6xP634qYfdFf4c6bL1o9Z8tii90vCeCskMY89/SMadavkvRMOLsrZra1nDeewSioWlZ
         yzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=ELGMVBs/2lqAFK164PRaOaF0dnyEe9SZFRcUZhXXTNw=;
        b=lh5bmJuchs4snHrKatv2imk2CT1d92ZLHg7iXt0JL8YXZd3Rtutl1Uzqr98G/hE1UL
         My+s6CPmax3c27w34/M79/xguiHnihawf2Vjlq2adJ5jMBwX0DIstr9IaXVdrAMwrrQG
         yPGFg4KDFb8Hag+Xg07Rp5/CKaJgSQnSEQerbJOBMVmRPUz1oMppKn+ENv1trEONAzuJ
         Zh4yVRhWco95ZuNiYTW06XkLjVPW2VzeYKuB0NYcgZMV/206Wj0V0t1JIegjFG8+NPFv
         RE0E6j61BImf1Tv6ZtSZ78ot9olO59a/NrB1km5cM79yzL1c+MUjFO4EREfBgkBTjMTm
         kZqQ==
X-Gm-Message-State: ACgBeo1Cu15MDnS1m7VWsdIRgJp/g6Q6Bh0MiOmR7G+f6FN9zm06lalt
        LPipZyHOinwl8X83jEixVXsng8cUrH0JPjX+O1c=
X-Google-Smtp-Source: AA6agR4/cBqLKSrNjvVnkJ7hQxikxCwCeX2gKWcTOOdj/nw0OHI1ZEXKUwxvobI53KPPvg13N0HTPIyzE+vLYb8s7/4=
X-Received: by 2002:a37:b741:0:b0:6b9:3b67:d0a7 with SMTP id
 h62-20020a37b741000000b006b93b67d0a7mr19665404qkf.770.1661354686219; Wed, 24
 Aug 2022 08:24:46 -0700 (PDT)
MIME-Version: 1.0
Sender: mrsbiyufungchi100@gmail.com
Received: by 2002:a05:622a:15cb:0:0:0:0 with HTTP; Wed, 24 Aug 2022 08:24:45
 -0700 (PDT)
From:   "Mrs. Rita Hassan" <ritahassan02@gmail.com>
Date:   Wed, 24 Aug 2022 15:24:45 +0000
X-Google-Sender-Auth: q-cDhgNFhVCcic5tx_ovP-rRd-Q
Message-ID: <CAEoD64zprKvDPkO05pMr0j7ZuGHNWOepSf_C8sXtY6CNsGmyVA@mail.gmail.com>
Subject: Good Day Dear Friend,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please forgive me for stressing you with my predicaments as I know
that this letter may come to you as big surprise. Actually, I came
across your E-mail from my personal search afterward I decided to
email you directly believing that you will be honest to fulfill my
final wish before i die.

Meanwhile, I am Mrs. Rita,  62 years old,I am suffering from a long
time cancer and from all indication my condition is really
deteriorating As a matter of fact, registered nurse by profession
while my husband was dealing on Gold Dust and Gold Dory Bars till his
sudden death the year 2019 then I took over his business till date. In
fact,at this moment I have a deposit sum of $5.5million dollars with
one of the leading bank.

Therefore, I want you to receive the money and take 30% to take care
of yourself and family while 70% should be use basically on
humanitarian purposes mostly to orphanages home, Motherless babies
home, less privileged and disable citizens and widows around the
world. please contact me for more details on this email. (
ritahassan02@gmail.com )

Yours Faithfully

Mrs. Rita Hassan.
