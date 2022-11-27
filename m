Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87B66399BC
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 09:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiK0ImD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 03:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiK0ImC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 03:42:02 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7CF10579
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 00:41:57 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id v3-20020a17090ac90300b00218441ac0f6so10407604pjt.0
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 00:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+7MBpQKLL8OmJu5cggvE3gGtXKaySkUPtB/3mMasiDQ=;
        b=aXSaaUWp8lXUvO0FFlfQfU25w2fpRBRKXlVPyFwf+kBUgE4KOEZLDZh/ZeXQ6BI+Xd
         alFttZGSWabaS7fOeidz5llZjOZBnquQzzKJW7uvFyNn046BrUQ1X+gz29bmY17NG+Oc
         k+gwDY1Ac5XInkwm9QsEX4jwinjpBRls8W02dX0pv8GEG1Tlk11oXRI+ZDlEG/w9Y6li
         FVUlm8ahubdHS3qM6m+Xp9wg/4MTfFE2zIETS9FyLr+bcqhVKSpBsFJtTrXeJIBWBFv5
         GonRRzPyY8yLmFRvE2vH2sWaN5DZC4ZINggi+Du+4wG6TzrHcaT/HX20+eookZqRpD/A
         m8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+7MBpQKLL8OmJu5cggvE3gGtXKaySkUPtB/3mMasiDQ=;
        b=ToVzigl4+TU8lSUI0SPb55G7BfrAut/gdF3WCr3KDlnbyHHsK89oKIN15vtUvp8TZQ
         vUDZEH4B2nMD4U2vqjQ/LSqqwvI2AJrOq80rUjelQRA0H555nzyNdiyLL3oyNw2/EamU
         +VTd3kZx073mgbr+HksIyaagMOD8TX+wVGVAZ39JHf55grHnpJFmirww3Z34VhNG5Nkm
         7Lz/+v+eR6EIhQgPdf41g1zdB6AmcAldoQhZYupAncAuIl/lyL676urKB9OzaYOB7l51
         JVlBUz0I1fA3cM5I1o7bci5s9RsUQ5YsuuwzkOK4lHjQGx/GgttMjYflGcy5dbVv3R5i
         7+Ww==
X-Gm-Message-State: ANoB5plCuDcIXSxf63aJ643O+jztWge6uNugNvTYNPlbxDcoGLaPNQof
        mbJf5xsj8En8qWfkCL1NdNXgT0UL0shsArIAwyA=
X-Google-Smtp-Source: AA0mqf59SU80ovi+6BhoYWNT5F0JovNNhPwoRrcoUzofFaJajtfPMqaeuEWlJoY+H2UTgf3EcVoCPjQKpwmFDbozFfk=
X-Received: by 2002:a17:902:f707:b0:176:b0ce:3472 with SMTP id
 h7-20020a170902f70700b00176b0ce3472mr38901504plo.169.1669538516970; Sun, 27
 Nov 2022 00:41:56 -0800 (PST)
MIME-Version: 1.0
Sender: hassantamboura55@gmail.com
Received: by 2002:a05:6a20:29a9:b0:a4:a110:4f4e with HTTP; Sun, 27 Nov 2022
 00:41:56 -0800 (PST)
From:   "helen.carlsen" <idrissuleiman01010@gmail.com>
Date:   Sun, 27 Nov 2022 09:41:56 +0100
X-Google-Sender-Auth: 55OiThJIWmWSiiJdU3tHktFXPY4
Message-ID: <CACRr12BqP-yMy+Tn4oBT=MVoA=1fSwaTaMYVOQTNdCCz_3vzDg@mail.gmail.com>
Subject: Dearest One,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.1 required=5.0 tests=ADVANCE_FEE_5_NEW_FRM_MNY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FILL_THIS_FORM,FILL_THIS_FORM_LONG,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FORM,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1043 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5765]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [idrissuleiman01010[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [hassantamboura55[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  2.0 FILL_THIS_FORM_LONG Fill in a form with personal information
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  0.0 ADVANCE_FEE_5_NEW_FRM_MNY Advance Fee fraud form and lots of
        *      money
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dearest One,

With due respect to your personality and much sincerity of this
purpose, I make this contact with you believing that you can be of
great assistance to me. My name is Mr. Idris Ibrahim, from Burkina
Faso, I'm the Director of Foreign Remittance Department of African
Development Bank (ADB) Burkina Faso, Please see this as a confidential
message and do not reveal it to another person because it=E2=80=99s a top
secret.

It is with trust that I wish to contact you on this matter concerning
the transfer of US$17.4 Million Dollars. This money came out from
Contract that was awarded to a foreign company for Maintenance of OIL
REFINERY PLANT in Burkina Faso years back. Contract
No;SONABHY/EPR/104/PED/2004, The contract was over-invoiced by me to
the tune of US$17.4 million Only, and this fund is in our bank here in
Burkina Faso and that is why I contacted you to seek for your
assistance in helping me to claim the fund from our bank as the
beneficiary of the contract sum as the intermediary company so that
they'll transfer the funds to your bank account, i will give you 40%
for you and 60% for me ok.

(1) my  full name: Mr.Idris Ibrahim
(2) my  age: 52 years
(3) my occupation: Banker
(4) my marital status: Married with 4children
(5) my  full residential address and country: Pascal Zagr=C3=A9 Avenue 01,
BP 1603 OUAGA 2000 Ouagadougou, Burkina Faso.
(6) my direct phone whatsapp +226 77 88 3617.


Meanwhile I shall also expect to receive your personal information as
well as I requested below.


(1) Your complete names/company names
(2) Your age
(3)Your occupation
(4)Your marital status
(5)Your full residential address
(6)Your direct phone numbers

note that this transaction needs utmost Confidentiality pending when
the money is credited into your account. I'm looking forward to your
favorable response in this matter


Thank you for understanding,
I am waiting for your positive response,
Mr.Idris
