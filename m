Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F8A51B604
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 04:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbiEECkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 22:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239426AbiEECkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 22:40:46 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B8C4A3F5
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 19:37:07 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n8so3161564plh.1
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 19:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=TxHlq8yop8LH/FlkX6AhN8L6sqaOjtwhTLWOKH2lmRQ=;
        b=gSjt0q63Mw1YAt3iRBENBITkV6IkmvsjnA/nqZPidr7xJep4P/C6te3YGyA0nQ4cZr
         0orCfZKQspuWpEyFqLJfvCNvfAD3rjGcsqHO/evSHYKj0kP3rR7rW9cfTjVkiCqu9gBz
         IeyBjTXWJr7gYwZ0Rb0Tr3ZXCc6rYufkjOhp3cjNZF9YOaEfM45ALftIYi2zlccqPw6D
         6q0W3mKt8hJave49nm7ZcUsqcDwTQq0nSPRsM0ToFR3nf+nHH0BtFwqV76okKkMJ2nvR
         UbIEraPWKBCylVwXmOCnkyaWJmZsgkV9lRZNne/HWI5G/HlJBQJnXBM13F/HBrk7FCz3
         8kvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=TxHlq8yop8LH/FlkX6AhN8L6sqaOjtwhTLWOKH2lmRQ=;
        b=CbMO1t5B/7hP6fhSGjkBsFIjqw2IVUT53PsfqI+8Fa3kJ+IdzKRXXImYs+DMzMDh8F
         yXKN9p/rHI+VjTChm/YTuxr7NQIJ+XpcTKBaKac5QFOB+3l08k7I3JEXe6r6Mx2JTp4m
         ILm/vyQXS3gyma9xko7o0OB0vosvdOwZfuLrGJoqxhvq5f+orUk87NJE4IOh5B3xPFst
         6/WT9PvcAhfbrH3npvPSK6VcXi6LW+bnmUf7LUlLoQun9uNfVE5PFWuyGiHAvWjO7HtD
         zMKReFUuxtxJAaiaKVyUg2w6gCtNMOeNrhhAINAiZg0MRV8dROBieuRc+htxqT9asn94
         /WdQ==
X-Gm-Message-State: AOAM531EKkOah8/95kuF83mBpKQRxyBUBuVevCcgs4dCZDzI4dzQ24NH
        NfmXcNx6Ocahn+JDn3TK0YIZt0UKWKpCwv7HvtI=
X-Google-Smtp-Source: ABdhPJzAZb4Z0/y1TEX0mh6R8HqjRL0ZKUSfK80vA1Kez30KGjQ2pPvAekWiqqq/XLyV4ZJ/4EKFHvEHbFKupYlqkRI=
X-Received: by 2002:a17:903:22c1:b0:15e:bccf:1e8e with SMTP id
 y1-20020a17090322c100b0015ebccf1e8emr10003836plg.161.1651718226527; Wed, 04
 May 2022 19:37:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90b:304:0:0:0:0 with HTTP; Wed, 4 May 2022 19:37:05
 -0700 (PDT)
Reply-To: revmikelivecom842@gmail.com
From:   "DR.ADAMS ROSE." <gm422383george@gmail.com>
Date:   Wed, 4 May 2022 19:37:05 -0700
Message-ID: <CADkNWXeu-7BEkrgQY2qLM=hM0GTU+jvDV98x7K_FfAf-nAmEiQ@mail.gmail.com>
Subject: Attention Beneficiary.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.6 required=5.0 tests=ADVANCE_FEE_2_NEW_FRM_MNY,
        BAYES_50,DEAR_BENEFICIARY,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF,FILL_THIS_FORM,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FORM,MONEY_FRAUD_3,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5013]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [revmikelivecom842[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gm422383george[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 DEAR_BENEFICIARY BODY: Dear Beneficiary:
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  0.2 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 ADVANCE_FEE_2_NEW_FRM_MNY Advance Fee fraud form and lots of
        *      money
        *  0.0 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attention Beneficiary.


Your Bank Draft worth of ($4.5million)has been credited in ATM VISA

CARD by the issuing Bank, be inform that you can not withdraw more

than

$20,000 per day this is what the Bank said you will see the rest

details when you receive it ,I have also registered your ATM VISA CARD

Sum ($4.5million) with (DHL) Express Company reconfirm your contact

information as follows.


Your full name

Delivery Address

Telephone Number

Your state and

Your Country.

Contact person REV.MIKE EDWARD

Email; ( revmikelivecom842@gmail.com)

Phone number +234-9015065394


So I have pay for delivering and insurance charges, I paid it, so the

only money you will pay them is security keeping fee which the state said

that I will not pay for, but the keeping fee is $125 dollars,and

I deposited it yesterday been 4/05/2022, And I did not contact you

yesterday due to low connection, so that is why i did not pay for

keeping fee, So I want you to contact urgent to avoid increase of

their keeping fee.


Your faith fully

DR.ADAMS ROSE.
