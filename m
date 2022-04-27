Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED29511022
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 06:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357661AbiD0Ead (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 00:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357658AbiD0Ea3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 00:30:29 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F05E49C91
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 21:27:18 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id w1so1045023lfa.4
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 21:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ex5vy32lCGEkQz6Zl7PaX1MVaB8jMvj7shEeLp2S2Aw=;
        b=OKJ3PrVvYejWGoCzjdm12/4aIqpiWH6atetUmHOQCMypUuxLQ1HS/5JB2Iu2P+S1/4
         nvAmXy6tJYs31loc9GuNPIt9nyi2CbP+mflqhw+dh9lgT8q0FSM9+WFw1JxrrZQdR5rt
         kmauiT8WIDVoUD1Uw0fOb2s+JF+BG2U9uxCK0a6PztkDAIiKU38lcgGLFip2HLCIj2WD
         hRZx+cbO3PUbqzSpFf3VYr5q64tFo8loLtMmSy+6ab7iFzEnResXybid5bCg7HEcN91h
         j4s5TZ5NXcu3nMhfbWQ0ux5U++99vsQ1uqruIQzEGB9qDb+x9/v1pDWFDUH00hRxvR1C
         KbOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ex5vy32lCGEkQz6Zl7PaX1MVaB8jMvj7shEeLp2S2Aw=;
        b=v0MJ+CunEUbpGrW0QrjaR/UZW0q8U0eJRTR/b68PLPxWWb3YAOhp94xi2UCJ/1uHhl
         5iv/NWDCDzLms0UU/GUOUQWtqACGX48qM/32epdXU+AzZwmR/bCkoZPyI98XMnnxW6ep
         eOUvcZXgU6N3knujoYeCFpYqO8qPoZAvjZnyzvcP1vkEz7z5l/K+Bqc7+H3JIIDCRyeK
         LOHfSEOVQxNH+kdeP5E2j43w7CiVmQ3IZh+wycDR38r3aeUdHy0ynAlBMulP9HXJ7hGO
         wpdrFNw6kniT4aSg3WojclZWQCZakeHV+Vil1cuGVd2hyHpKc8nucgkKrucXhG/g0js9
         5u6Q==
X-Gm-Message-State: AOAM532wIKfJQLis5wjjxdRCNJmspMKyiKcuHZstZSnMM/6AkLiMVAff
        ViD3QMIXyTEAalFFDtPOzL1qfLEjN76lDPc0DhE=
X-Google-Smtp-Source: ABdhPJydnihqH4qLoZEAecoAl7wrKz/LdZ/7fBHq+qr5zpGtXlPWsmlimeI2Svj/DPRjOWPdUhHivTZ0QhXs2EBXvpg=
X-Received: by 2002:a05:6512:3f95:b0:472:c4d:30ac with SMTP id
 x21-20020a0565123f9500b004720c4d30acmr8402272lfa.51.1651033636611; Tue, 26
 Apr 2022 21:27:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:bc05:0:0:0:0:0 with HTTP; Tue, 26 Apr 2022 21:27:16
 -0700 (PDT)
Reply-To: khalid.loan1@outlook.com
From:   Khalid Al <tycoonenergysd@gmail.com>
Date:   Tue, 26 Apr 2022 21:27:16 -0700
Message-ID: <CAE12Z9rHe4Kit5fwiFXnYDXBqYfOPS9QwN68kLRwkDRBnLukqQ@mail.gmail.com>
Subject: INVESTMENT PARTNER NEEDED
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:143 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [tycoonenergysd[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [khalid.loan1[at]outlook.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
My Dear,.

I represent a group of company based in Gulf Region and we are
currently seeking means of expanding and relocating our business
interest abroad in the following sectors: energy, real estate,
construction, stock,mining, or any other viable sector. We are ready
to fund any business that is capable of generating 5% (AROI) on Joint
Venture partnership bases.

We look forward to discussing this opportunity in detail with you.

Urgent khalid.loan1@outlook.com

Regards,
Khalid Al Rumaihi
Business Development Manager.
Mana ma, Bahrain.
