Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6365272AD
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 17:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiENPhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 11:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbiENPhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 11:37:05 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570F7CDC
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 08:37:03 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id e19so11295139vsu.12
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 08:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ejmbDSRtrvmXLPtD7L18FmBC6JgH3lWpgMvMBM820Rg=;
        b=VrKKzLHrLGFNolRe2xfeh7n1A6YOna2dcUCVS5nT4xkF3WKxwdfoIUA5l9xlonV40b
         H7GgXUV/Nn1x+7SALI/H82ew238piQ/mbZzJHXQV9P3J63kurw7z64lKi15yGtpgdIAI
         I43iMW1jAZDlTN3k5w6Fr54/cAnjHj6GwSwQYo/4+b0l4OZXlr6FBqLkyIMjiJnJzkiN
         3dfOebR2weL2V1OkZwnLbZjao34aMv6O2ocqnkMm7rOM/PQrfP2OGMfSuKI7hNAJzh/W
         BjhtBSW2YKgdny1GjXA7eTl9kVLMT1bJBuPhZQza6Ksf0mci+xWJhRkfkOpfk96dC/sc
         ujcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ejmbDSRtrvmXLPtD7L18FmBC6JgH3lWpgMvMBM820Rg=;
        b=qu62WGitYz0Q7faNMpgy/p2Hu67VnbfJHGBOGFGJou15LCnUND8jXZwrus0Npsihkj
         iCT2PB+1GSpowPTQvXy8g087LXkXcQGxzF6uFgJ1MfOEZx0MHZ7WfKytvxxuyZWc4Zid
         iG7q8l8WmTlW+Gh1qjMWzWbphFdU/QiuSHVcDwV8+6CwhuOzVAoD2+n/YtY45cZgAy6z
         DjH5n+9AA4w5I4uqBcwmckYYDOi0swoPe+Py3Z+TStkfUnxNJsjZvKtfA2nQtWX0LZqZ
         nsm0IiLye2y3Wr1uAwIqo95tR+4KFe6xPug6nRpJnkQqYC0B9eUZxeoLOFbECPpQ2VQ/
         +T/g==
X-Gm-Message-State: AOAM530BmbgsyMfsae5oH6EyLn8ckGzsYWytX8+OtAub5ukCN7rIaGkH
        xR3DYDclNfjjf8ZWQjdRPb/WYsci67LsgPGSr88=
X-Google-Smtp-Source: ABdhPJzJEXHPcYrG7Jw4JncRmeg5ANLh2ByrzS25cVD1/tWLq24UXzs8QGY0TPSGEaFyaHev7yQtGsZK10jLoChfzC0=
X-Received: by 2002:a67:d78b:0:b0:32d:c0f:f6fe with SMTP id
 q11-20020a67d78b000000b0032d0c0ff6femr4063841vsj.51.1652542622335; Sat, 14
 May 2022 08:37:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6102:3e8f:0:0:0:0 with HTTP; Sat, 14 May 2022 08:37:01
 -0700 (PDT)
Reply-To: douglaselix23@gmail.com
From:   "Mr. Douglas Felix" <kekererukayatoux@gmail.com>
Date:   Sat, 14 May 2022 15:37:01 +0000
Message-ID: <CAN5qXwG6KK-22PWAmRZUjJfy4=O56N+wWQkoGrz98VxDrSQHAg@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e2e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5014]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [kekererukayatoux[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [douglaselix23[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
A mail was sent to you sometime last week with the expectation of
having a retune mail from you but to my surprise you never bothered to replied.
Kindly reply for further explanations.

Respectfully yours,
Mr. Douglas Felix
