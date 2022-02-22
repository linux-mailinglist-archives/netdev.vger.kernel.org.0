Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2934C4BF70C
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiBVLQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiBVLQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:16:21 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2882D0493
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:15:55 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id 4so9433106uaf.0
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=xDo30qH2kcx1DuoIpmyriC2k6+L7XJnWdKleRcHl+ZM=;
        b=dpZltHxQqRM1PF18pRcIwFsJDQHUSiToHRnwb904jttdKZXdm8+cN8Xsu7ekyf7wzP
         6wsu7wjRIep2j0dgB9z0+ogB2XxpOpTmUSFwuvP3PHvFiw+eu3vCdfdteVw19dfR6P9M
         9CmTYCs2ghn8bf/Q0j1jOWGXVKjQjGtjLQq3qRBeXGo7t+VdxUVSavhUU2PJOGS8ywaz
         HRhE7enLiKanHOGLY/gV/Gy4hHgEWua9ESaUBbnNHmnALXqURc2hN3jyx3VjP5dYYEwS
         Zag1ZXzX3sEvSE1QH8VNrLG4/GxcDsqEX4Fh+Si+5V5E9IydMg/pA3IjfF9RemzOA6TG
         +0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=xDo30qH2kcx1DuoIpmyriC2k6+L7XJnWdKleRcHl+ZM=;
        b=CLnoHrRkHl6BUpVH+acpcWvi9paRpcoZUdJRxklHy3fcOGaOLzgU7433PWKHrwkElf
         kgMPo+jRau0guMuZuylRuJ4QHqCcg2G6cigeTGrmCnlmxGBrd50yuUbYu8At3KIRttVs
         b8TP69Tahe66NHTPHx53Nb14u7A/e7UxXhktZEq8cBX2slLLnm4YOzzBILpWLWNt9sRl
         8X/Lf4E8JrG+4gG2HCD2mGMeqMQ7wy7tIOpkgGnp2lXk1pIT+uxT33mZ4BiaoB1mfO64
         VP5Tlo4rucAqYr+8Fr6VmUSilUqlMc+ncbeBAZMB08mYsya0SiXmZ1yr1QjjfqZWQSwF
         6eSg==
X-Gm-Message-State: AOAM533ApYFbS92ND40gxqsvpFm8/C7SDrFrjvXsrU4VPohq+KcbOzo6
        DlHA9tI11/owgTGLP2kpH1z97xNPWcq77fkX8lk=
X-Google-Smtp-Source: ABdhPJyxUiDkCLpedtLHidDSKGKoOxxdbCao7tb40+tEuGCsYNtxtXgorjFGcv35KQrm0xLMGewjH/cBnsbICBbETvY=
X-Received: by 2002:ab0:e19:0:b0:341:45b3:cfc with SMTP id g25-20020ab00e19000000b0034145b30cfcmr9376046uak.49.1645528554816;
 Tue, 22 Feb 2022 03:15:54 -0800 (PST)
MIME-Version: 1.0
Sender: mrs.doris.david22@gmail.com
Received: by 2002:ab0:5b07:0:0:0:0:0 with HTTP; Tue, 22 Feb 2022 03:15:54
 -0800 (PST)
From:   Ann <annwilliam372@gmail.com>
Date:   Tue, 22 Feb 2022 03:15:54 -0800
X-Google-Sender-Auth: aWnQe4lBoghcm-vJnFttpIz1LnI
Message-ID: <CALSkaMD63a20q_jqJNZM=WM2SQ51O7jKBRG1zrUALrethnxm6g@mail.gmail.com>
Subject: Re: Greetings My Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:92b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5017]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrs.doris.david22[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrs.doris.david22[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I sent this mail praying it will find you in a good condition, since I
myself am in a very critical health condition in which I sleep every
night  without knowing if I may be alive to see the next day. I am
Mrs.william ann, a widow suffering from a long time illness. I have
some funds I  inherited from my late husband, the sum of
($11,000,000.00, Eleven Million Dollars) my Doctor told me recently
that I have serious sickness which is a cancer problem. What disturbs
me most is my stroke sickness. Having known my condition, I decided to
donate this fund to a good person that will utilize it the way I am
going to instruct herein. I need a very honest God.

fearing a person who can claim this money and use it for Charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained. I do not want a situation where this money will be used in
an ungodly manner. That's why I' making this decision. I'm not afraid
of death so I know where I'm going. I accept this decision because I
do not have any child who will inherit this money after I die. Please
I want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how the
fund will be transferred to your bank account. I am waiting for your
reply.

May God Bless you,
Mrs.william ann,
