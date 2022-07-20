Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A8757B4FA
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbiGTLDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiGTLDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:03:23 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB906B757
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:03:22 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id bf13so16062785pgb.11
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=2AXQjT96vWerAli8R7arVuBKiKf32pWYLXDy2CyrUow=;
        b=HOfIIMLkSFNsKfrzoTGyzq/CB+e8eh+hgu7QvR8xRXlidazbrbLR/7LIUqEC3zxoXs
         vc+40bq3/64+7reE292KvO5UPrbDb0rtfLGWe5Ll707PbHfy9E0BbhG30qdzU1P4aRyf
         s4VFk46UZL1KRAqMViEIEET/b8QEt5/cpwy/lzuI2ZAaJNdEr6k46KdKQveTZ69zCEaP
         546bOgY4Y7xzxVvcRG6K9RjyvgrUnOaFWm72bNpgJyzvlpk535XKqPz1/dRQ0trf0K9M
         owF3Rb581w0Te3A2ry13mWgFGrIkwy2wdjs2FavhTWudJOToMrCH5jeEN2z6zdlF1yx7
         94uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=2AXQjT96vWerAli8R7arVuBKiKf32pWYLXDy2CyrUow=;
        b=Btx4KEAeLzowI3tkNByaUUBNFbX1jyUo9VULceKbxWlGWOJa3Qm51Y1T1Kz9yVRlpe
         WUVI9VhdkMN4AwF4ShG7VYk2oZ6mbmIiyecGoDwxMUNmGttB06LHjLa4JU4N0CisodN0
         XDbx3QS5rAJJl0lJ/plO2DKbxYemFOBvGTGlFyOVOmi4FsWz/kuYhSevYFZYe3dgd0yy
         8vjdYNPGbSMRDgE6VTT6TZrOFkvgG98sZVx+U01xh2QPj6B1v6TiKNiOVqXlyUEjXEDr
         dh1IwAFTV5DLGQqzsnhAIW3WVfQxkb+yLoBWl4UyIWEOajtN5s4LDxssj8p/ff11GjT8
         bCTA==
X-Gm-Message-State: AJIora/WIr+byO3oUFxy0MVYEjlBfBLv2vd7ci959VWNDWmFEPlIp6To
        NJBrwQ0/AHr+chMxnVm2z79FXOxgDPtePKRRgFg=
X-Google-Smtp-Source: AGRyM1tO7zIon3k7K9WQOnkvw1+obPVUEHAHKS7PLxun2Wky+Sgnt2R/msN0ffDjM9+55hhvsyyvEJd1sxGMS2nsTwk=
X-Received: by 2002:a63:fb52:0:b0:419:cb1e:6e2 with SMTP id
 w18-20020a63fb52000000b00419cb1e06e2mr26379216pgj.356.1658315002058; Wed, 20
 Jul 2022 04:03:22 -0700 (PDT)
MIME-Version: 1.0
Sender: mrssophiarobin375@gmail.com
Received: by 2002:a05:6a11:fb23:b0:2b8:c089:7e07 with HTTP; Wed, 20 Jul 2022
 04:03:21 -0700 (PDT)
From:   Ibrahim idewu <ibrahimidewu4@gmail.com>
Date:   Wed, 20 Jul 2022 12:03:21 +0100
X-Google-Sender-Auth: DX9QVgLagbSEYU0bwIsCUm9ARNE
Message-ID: <CADADpKQVuy9Q95ywOA_o+n9TfTTnJwZsoXwWdKt-yKqMKA5Vaw@mail.gmail.com>
Subject: I NEED YOUR RESPOND PLEASE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.9 required=5.0 tests=ADVANCE_FEE_5_NEW_FRM_MNY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FILL_THIS_FORM,FILL_THIS_FORM_LONG,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MONEY_FORM,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_MONEY_PERCENT,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:530 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5008]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrssophiarobin375[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ibrahimidewu4[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.0 HK_SCAM No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  2.0 FILL_THIS_FORM_LONG Fill in a form with personal information
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  0.0 ADVANCE_FEE_5_NEW_FRM_MNY Advance Fee fraud form and lots of
        *      money
        *  2.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Mr.Ibrahim Idewu, A senior staff in the
accounts management section with one of the prime banks in Burkina
Faso. A dormant account has been discovered with huge funds of
(US$19.3 Million) belonging to a late Ali Moisi El-Saad from Saudi arabia,
on 9 January 2018, Who unfortunately lost his life and entire family
in a Motor Accident.
 Why I contacted you is
that I want to present you to my bank as the beneficiary of the
deceased account as the next of kin after the fund is transferred to
you in your country
We are to share it at the rate of 50 to 50 percentage which i will
come in person to
meet you in your country.

Please kindly contact me with your information if you are interested
in this transaction for more details(ibrahimidewu4@gmail.com)

1. Your Full Name.....................
2. Your Address......................
3. Your Country of Origin.............
4. Your Age..........................
5. Your ID card copy and telephone number for easy communication...............

Best regards,
Mr.Ibrahim Idewu.
