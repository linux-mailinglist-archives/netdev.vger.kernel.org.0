Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1EE550D5B
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 23:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiFSV6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 17:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiFSV6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 17:58:12 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B048CEAF
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 14:58:01 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id h1so8148095plf.11
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 14:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=6BUqBhQ0Hi1/ig7PGzf6FbFjSTx12z1sbwmg7yholYI=;
        b=Mv8x3jgm6GWGKuFSkBgMwWxoGyxITy/QI+z7a3x9qY8eKp7UTh6tyUe0engl75u+ti
         WEW/VmYok/pPWfTUF2CQpG0earJ0bOywB4Jh8cCaoXujx3aMATgj1TDGIsEQs1O0qY8o
         D7huIPeKmSN2dXDbdKNcW8/eNjBJl58QeUNhOU7TKCwkK3BTZrfJMbFO7dt1CW6r6/do
         eOiuFhaOwIDiMw04/j6Sb80A1xZlaDp5mptZVT8d0fie0gCcog0lAZ3iBAK6bVFz5qz1
         MZOZm4XtVBQgz22T5jpN2r71R1zM/piUrOT3hajM7M+EszkK8XXeu24jp+LHFxePp3G/
         k/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=6BUqBhQ0Hi1/ig7PGzf6FbFjSTx12z1sbwmg7yholYI=;
        b=qBA+hPgVjbmohN9CCDSnD/mxG2Tfh8dntG4xEXnVtl8gz6KBz1//5rNrWVpXQZjm+L
         fjDw3h08Nod9I3gt+5xK+DBzioZ3uPrm9/uJMrhgP3m+uD0NNpczOpegrWgnEkZd/YyV
         90jg9ThzdC4tK4IKnc2rAeIGGi1nj1AgXmK6s+Q73UdNYuh9ms/YwlyRF307MBE/B/az
         reudEJ8QV97eC6V0E4zX92sAeH/idVUAI411/N+CmcyTqgtscox+obJK65AoSLs0bM/B
         8p2c4k8vb8eb2Xgq7AZEFCZLk243SuKXeUSndgmtvEnJNzRVm8LqoDTDhgHuDHcfXfjC
         logA==
X-Gm-Message-State: AJIora/U6+W5L5KwkGrqO4oDYMqsEGdNeQRcuy8nBlhW1dGFP/9Dhn19
        vKJrUpoBh80LEqP7mcYue65LGMnIGCfRTQS04nw=
X-Google-Smtp-Source: AGRyM1t0m/GJe/fkqYXUitwIuVpB9OLszjipUq6Ju5NfHhOF2e4R5+p5yrrG0ucNhBPADFonCyi87V2qtz05dtjFjxw=
X-Received: by 2002:a17:902:edd1:b0:158:8318:b51e with SMTP id
 q17-20020a170902edd100b001588318b51emr21019123plk.89.1655675881190; Sun, 19
 Jun 2022 14:58:01 -0700 (PDT)
MIME-Version: 1.0
Sender: usmankabore89@gmail.com
Received: by 2002:a05:7300:d26:b0:67:a4a1:bc1e with HTTP; Sun, 19 Jun 2022
 14:58:00 -0700 (PDT)
From:   MUSA AHMED <ma7304719@gmail.com>
Date:   Sun, 19 Jun 2022 23:58:00 +0200
X-Google-Sender-Auth: aBBoHMxHc2JmAJBlSNr1QUipE74
Message-ID: <CAKx9w=WKWQegOrQ0txc9jR_x4Xw3T_ha6AHCdDj4=O1z_qmu_A@mail.gmail.com>
Subject: ATTENTION PLEASE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,SUBJ_ATTENTION,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I am Mr. Musa Ahmed, a banker by profession from Burkina Faso. I have
a very confidential business proposition involving transfer of $
18,500,000.00 United State Dollars that will be of great benefit to
both of us. Contact me via my private email below for more details.

Email: ma7304719@gmail.com

Best Regards
Musa Ahmed.
