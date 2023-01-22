Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEDA676BF6
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 11:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjAVJ7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 04:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjAVJ7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 04:59:50 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9663F1CAC7
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 01:59:49 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-4ff1fa82bbbso87107667b3.10
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 01:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Kp5gRtpfmQsaYKOOAkmN/mk8FMd5WzjZmFMIyB4Uxc=;
        b=lJV9xVH2SNEVrNE1+1XUqAhiiA/kimxVgt0iminEJQSs1EcrKLlB8/P4V0b/rw5YVm
         ENA6SClXFwmP0ZrF7oYdsxyxyfdoIZ8ygidFHUrzSiF+c4kddkmjx4807IT4FcdFVTHC
         Wz5GlAEjvxHIrKgaDXG/3mM+G8IyfC8ZACJ52K186sTlPcMoUcRWb+3Urd8o4/YuDQc8
         nNBEl70OxLmLavwBVyhg0bT14OBX6GbYyV3XWpcfgOet0vRtL1bqt0MKj1FxfrSiEbyk
         GTYHuvu/l10iYuxL0cIHRL2e5BVCet+ZhKQrVhrqgFYOYgMeQ8EsqtvOTG5Oau9tUJxO
         GPLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Kp5gRtpfmQsaYKOOAkmN/mk8FMd5WzjZmFMIyB4Uxc=;
        b=QWPIf4iX1VIu6g3Dpd3YsBsm42U6vT3BrXhVm15V2eCn6G2BzaXMgFcdpjIMZknTMy
         r0mANAmnkIF3rOwGOojbcMc/7MMAne1N+V5oN8OK3YJma9EVMhx4IwxQS7GxcqHha+S5
         aX6U02SgygSuyCRTh6aVv6olfuzUwu12DZMnIouSkcgkknyhGZ2bej4dA45lGK+itKzO
         w22OMrA962Y8h09YFurptHi5upbkZJTd4liSrXlV7+D2T2wJb5j0y/Cs9t/4QAVUt6Zs
         kaqOG+7uhsrp4wjUWS5MBKn3BDFprai30QvsTajmGEeM1LNUzFgkPm/s0+ASfoBD58R4
         SE2w==
X-Gm-Message-State: AFqh2kqNeQj8OejAokWJ+eIUY3NOsqqB1k9akhtOjXT0t0twBprcF75m
        CWZrzhu+L4DjB+HCX8Kp9xAXo8yifaVHTXkMgSU=
X-Google-Smtp-Source: AMrXdXtE6YqCT1UD/IEDNXBPnthPfEUBkQRYv7/F/aZuh9IHyXQ5hrgeN1I4VcA+dLoTyDDS4lLGWa6SdalWUnlr/jA=
X-Received: by 2002:a81:689:0:b0:500:1982:86a5 with SMTP id
 131-20020a810689000000b00500198286a5mr529828ywg.148.1674381588637; Sun, 22
 Jan 2023 01:59:48 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7000:3d87:b0:41b:3715:241d with HTTP; Sun, 22 Jan 2023
 01:59:48 -0800 (PST)
Reply-To: cristinacampel@outlook.com
From:   "Mrs. Cristina Campbell" <barrmercyjohnson2000@gmail.com>
Date:   Sun, 22 Jan 2023 09:59:48 +0000
Message-ID: <CAFvLHNxa3MNP9tgjB1=eTYW4VKP1TQJquefGhby=k-=EET=usw@mail.gmail.com>
Subject: Kunt u mij helpen?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [barrmercyjohnson2000[at]gmail.com]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112f listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [barrmercyjohnson2000[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Beste geliefde,

Ik ben mevrouw Cristina Campbell uit Londen, Verenigd Koninkrijk. Er
is iets ernstigs waar we over moeten praten. Als u het niet te druk
heeft, kunt u mijn persoonlijke e-mail beantwoorden
(cristinacampel@outlook.com), zodat ik u er meer over kan vertellen.
dit humanitaire liefdadigheidsproject in uw land ter waarde van zes
miljoen Amerikaanse dollar $ 6.000.000,00 usd.

Met vriendelijke groet.
Mevrouw Cristina Campbell
E-mailen; cristinacampel@outlook.com
