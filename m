Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8A85168EA
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 01:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356108AbiEAXvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 19:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiEAXvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 19:51:40 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FB52BB24
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 16:48:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b19so17615472wrh.11
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 16:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=rrdjG6c/2FeXm3rYw+FcEDfupq6ewXDDBRc/WzcU8PU=;
        b=mZ/t7KD3LYNHaw9pbmciwq43b83OmSkNKn/ijHyHJAkutVuLK6BlqidoGdyicpWGxk
         l+qKGHjFnSKEZTTLifIm8+qxRGtQGfSR+fgspKX3DgmZ5dlPhkm3pIL5YVunCr8+ltms
         4eaEV8V9IE3jFC7+TQ4/HSXmY0j+PKeAH2iGXXNjeNa75UmSuL0zL6wRDjp1SrR6lXjR
         8KmVzX6gHUZJi4FLMsgBTlNF2yoHZukhmJ4zpq0wxqq6PpjvV7Z4iJlC11NOdwvMt5A3
         3z+NhBZvWRlsCN8UuG3h56Nw5bD99hfmNSeoENLhSAcwtIb6cfTBLdHzd1UETMl2dOUu
         KPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=rrdjG6c/2FeXm3rYw+FcEDfupq6ewXDDBRc/WzcU8PU=;
        b=lMvyljfyKJD5BWQrJfrtRuQEBVBm2Owsws+/GMnG8e/b1G6tUdwWcU0AJugt36askH
         VhU+MAMXabAd7IOgTI1AmN7PalJ6y5/vt/bwlUvFnepVSzqt8I2/q9MiNsj+592jXFQJ
         wyapI/dbqT8Vx0n0vuiY5/mKZlMtSUgPtpiWFF7S9BCaqVy8i36begtGCPO91Be6mypD
         y8EGxBsoadbFkkE2m/KFepkjOzgNLr90T0ynvK1XD0LC4oi5Pefh0bg4+y+XbG0qES5o
         U2mQjIExl9AmsSAO0Jtwu6IaujZS9ED5RL6snM1Us7vE3oRJaGBGfqU5BxX4zr8aeyMC
         KInA==
X-Gm-Message-State: AOAM530AeI11INWKod6MsO7EyaeWjlOtfX1EiNyodrP+PxRWUxgDWW5Q
        RNANz9kH8ZphWBq8UJWC3jpLLkdBYzQY5AGWq3o=
X-Google-Smtp-Source: ABdhPJy33HNvgtzhzFx2F44plBVBahUHmQqf7nrGM7hTFZHKxwpWGxE6zhG7QldcAJM2qOmIXjcmwb3D0kAgvwDqSZU=
X-Received: by 2002:a5d:6d0d:0:b0:20c:530c:1683 with SMTP id
 e13-20020a5d6d0d000000b0020c530c1683mr7032447wrq.109.1651448891754; Sun, 01
 May 2022 16:48:11 -0700 (PDT)
MIME-Version: 1.0
Sender: azziz.salim00@gmail.com
Received: by 2002:adf:f646:0:0:0:0:0 with HTTP; Sun, 1 May 2022 16:48:11 -0700 (PDT)
From:   "Mr. Jimmy Moore" <jimmymoore265@gmail.com>
Date:   Mon, 2 May 2022 00:48:11 +0100
X-Google-Sender-Auth: sNPF-4sm8BBDvLzQ-3NggCbNkic
Message-ID: <CAOhmN-FZbgYEg-0dSmSOQVs7f8gW=8zoEktGkpcAJxOaKKaTvg@mail.gmail.com>
Subject: YOUR COVID-19 COMPENSATION
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,LOTTO_DEPT,MILLION_USD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:443 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [azziz.salim00[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [azziz.salim00[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  2.0 LOTTO_DEPT Claims Department
        *  1.8 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UNITED NATIONS COVID-19 OVERDUE COMPENSATION UNIT.
REFERENCE PAYMENT CODE: 8525595
BAILOUT AMOUNT:$10.5 MILLION USD
ADDRESS: NEW YORK, NY 10017, UNITED STATES

Dear award recipient, Covid-19 Compensation funds.

You are receiving this correspondence because we have finally reached
a consensus with UN, IRS and IMF that your total fund worth $10.5
Million Dollars of Covid-19 Compensation payment shall be delivered to
your nominated mode of receipt, and you are expected to pay the sum of
$12,000 for levies owed to authorities after receiving your funds.

You have a grace period of 2 weeks to pay the $12,000 levy after you
have receive your Covid-19 Compensation total sum of $10.5 Million. We
shall proceed with the payment of your bailout grant only if you agree
to the terms and conditions stated.

Contact Dr. Mustafa Ali for more information by email at:(
mustafaliali180@gmail.com ) Your consent in this regard would be
highly appreciated.

Best Regards,
Mr. Jimmy Moore.
Undersecretary General United Nations
Office of Internal Oversight-UNIOS
UN making the world a better place
http://www.un.org/sg/
