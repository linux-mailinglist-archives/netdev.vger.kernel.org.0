Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9B256AFFC
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbiGHBfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiGHBfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:35:52 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2528572EEE
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 18:35:52 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id r18so25183881edb.9
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 18:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=DsUpTMVy3AnG06ab2HPPYE6VPm25Tedt2mleq6KKBcw=;
        b=LAbsdT5m//amZ/D0i4x353B0pTyvwxUdh2u//aO5NYhAjQFsl0Sdj0JGZRKsrRFgcE
         seS7E/QBz3MjRovLqUbLRj5uvWL3TfX8260wliuROccV5T8YEeMnwvr087MHc4nUnREQ
         gRjaJ1CxhibTVDyAbz4voeFtwdfQEQG3wYahIRinKqUZxul+/lFgyiQenVqsQCzwVhgW
         i7iFSRYzep+cVp+Unz+f1CrnAZ9kpe8bC9ewRNc8ORcTVeT/jh2KH5HPE6Rtt0uTr9QW
         0cWHT1X0Ae8Ef76zzal/GVy4ZlZYkVfFJsNvO23tjoY+FRxF/4dR/XIlMXI3AIRodE9H
         m7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=DsUpTMVy3AnG06ab2HPPYE6VPm25Tedt2mleq6KKBcw=;
        b=p1KyFobs5ZzCb4MBQJIlAqU56NaU8grfzejEpuq17OvtxzFUtYSV4MhBGP/ygVoOCi
         OV+iryWk584ZQwDckI/I78MBB+g3tJ1Dng+rfk5dEh07JUVmLmcZevLXzH5p/7fYcSTe
         Og1Vg8cjStlBhTkuy5zgZMqaVtaETNQqtuLS9sHB7VH9Or7cj0dl5Np07lvMz6mvqV0t
         9Zy+06kdwfBrW1eF13lvRMgX2I05yN23taf44LS4i60/MoMEQZjtyQteGIRmQiCPjeV5
         GrLi4me/tnwICIwPeOqHW5fcPaWCDVkfniugSi0tsnZ9EpPNzwpgBRtdKAUGIimLx723
         ypWA==
X-Gm-Message-State: AJIora/KV0mYNZSurnm5O5ZnEcbbi9r9hJQJfykph1BmZhE/OEPW6NFV
        Ngv6Q2XXWqe327wn4leExMQklccl0p/BNasVDoA=
X-Google-Smtp-Source: AGRyM1v/wW8Khzil+/zE+83r59XXvtMhVlgHFW/RzzpLL6j7i1a33pMYuGML09uyi2SO3P+s52ybcZir7ziqC4Ljb5Q=
X-Received: by 2002:a05:6402:4393:b0:43a:a25d:a482 with SMTP id
 o19-20020a056402439300b0043aa25da482mr1306035edc.283.1657244150767; Thu, 07
 Jul 2022 18:35:50 -0700 (PDT)
MIME-Version: 1.0
Sender: mrsaijheidi7@gmail.com
Received: by 2002:ab4:a6ad:0:0:0:0:0 with HTTP; Thu, 7 Jul 2022 18:35:50 -0700 (PDT)
From:   Mrs Lila Haber <mrslilahabe2016@gmail.com>
Date:   Fri, 8 Jul 2022 01:35:50 +0000
X-Google-Sender-Auth: xNAfAqgsNq9YgUa1-EtMbYm15CQ
Message-ID: <CADXrVCr-qAVDNxVo87iptjkWMAUTz1jrfS4tjKskXsfCPUQhmw@mail.gmail.com>
Subject: Dear Child of God
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.7 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,
        MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,RISK_FREE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:541 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrsaijheidi7[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrslilahabe2016[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.7 HK_SCAM No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 RISK_FREE No risk!
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Child of God,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS
CHRIST the giver of every good thing. Good day and compliments of the
seasons, i know this letter will definitely come to you as a huge
surprise, but I implore you to take the time to go through it
carefully as the decision you make will go off a long way to determine
my future and continued existence. I am Mrs Lila Haber aging widow of
57 years old suffering from long time illness.I have some funds I
inherited from my late husband, the sum of (7.2Million Dollars) and I
needed a very honest and God fearing who can withdraw this money then
use the funds for Charity works. I WISH TO GIVE THIS FUNDS TO YOU FOR
CHARITY WORKS. I found your email address from the internet after
honest prayers to the LORD to bring me a helper and i decided to
contact you if you may be willing and interested to handle these trust
funds in good faith before anything happens to me.

I accept this decision because I do not have any child who will
inherit this money after I die. I want your urgent reply to me so that
I will give you the deposit receipt which the SECURITY COMPANY issued
to me as next of kin for immediate transfer of the money to your
account in your country, to start the good work of God, I want you to
use the 25/percent of the total amount to help yourself in doing the
project. I am desperately in keen need of assistance and I have
summoned up courage to contact you for this task, you must not fail me
and the millions of the poor people in our todays WORLD. This is no
stolen money and there are no dangers involved,100% RISK FREE with
full legal proof. Please if you would be able to use the funds for the
Charity works kindly let me know immediately.I will appreciate your
utmost confidentiality and trust in this matter to accomplish my heart
desire, as I don't want anything that will jeopardize my last wish.

Please kindly respond quickly for further details.

Warmest Regards,
Mrs Lila Haber
