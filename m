Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9CF4CE5F4
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 17:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiCEQdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 11:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCEQdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 11:33:08 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EAF1FB51B
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 08:32:18 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id i6-20020a4ac506000000b0031c5ac6c078so12860253ooq.6
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 08:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=/yJwP3S4qrZ5ciITEWrd6OJrYVm/Ji8vbDH75vaAWVw=;
        b=V+/nnfpYemzfpXHEcTePkqLewgBSmVmcmoXbrkKy9VjcKpbR7x8SfIzfE0HeKvFM1t
         8CYUyXiAx6sARMJq1aGbmdpmkM6JX6d864wWTnoN2iWk4u8Gsyli+fn3nsts/niOELtL
         jxfORYUxOGNWIDe+rpONSDMCdROf1vFvhHk1XG2oudVsGVoWxQBV+pEFf3tyFDwYURKJ
         HVGADCYgl3t5rcZydahmnFMtgfxeeyTfDxubUBYjrHo9ADlVoq6fgdFVEvIpFDB4dN8J
         S1p/4KoFBZ9PPgd77Uh6rhilVuIhIUZkbADwGyitnNNdCSJq/sr7eRdTKKYUDSKoBDLS
         MZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=/yJwP3S4qrZ5ciITEWrd6OJrYVm/Ji8vbDH75vaAWVw=;
        b=dxGhZrEdq0kUB8n4E1FmCVPPkf5Iw/LYvloFI+z/SEaHgOILJhCYblf4KQuLhEndyz
         g6rJGwoOx5Pl3FYj4h21TLW0zMHeFswqeohqZjBhH4J9BhJ8gPATSPNRveWL6NYoeZ8H
         yP/3OQq9LZPBV17yWPs0zGi5fwSCTpSGSuhlydq5jsywm20rXwCuVX4jhTTrNN365upN
         nIQxyXP+CjkzfEnmraKFGsls3knkh2mB3OKbGTRcX6k5XdRP8I2DQ2dUdpBlcIOlCHXr
         cZ7f2LXRSMvB+79W1nrI+ERussrCAHcV3kF+BDqHUI1MXeZU9MhthjyI5fpFO7amU5dD
         Qarw==
X-Gm-Message-State: AOAM532PvuvkehEGa4o+dRlY1FaBtvdrSKzCz7tu2QJKMoKFL6gX2/q+
        ZeKcLa5VNDeFFupmunEvTE5fFP+l3oOkh8ULWrrOKgLxqpPmdg==
X-Google-Smtp-Source: ABdhPJzter1TPOiRQlS4TVl0hsobsbv7JjqcZ2JK/NCM2bED06s/YTbz/KsbOzK6/vrF00Q7VKEzev1SQwks8KYFKBE=
X-Received: by 2002:a05:6870:a2d2:b0:d7:60ca:5065 with SMTP id
 w18-20020a056870a2d200b000d760ca5065mr10796999oak.72.1646497926896; Sat, 05
 Mar 2022 08:32:06 -0800 (PST)
MIME-Version: 1.0
Sender: rubywilliams266@gmail.com
Received: by 2002:ac9:57d5:0:0:0:0:0 with HTTP; Sat, 5 Mar 2022 08:32:06 -0800 (PST)
From:   Anderson Theresa <anderson.thereza24@gmail.com>
Date:   Sat, 5 Mar 2022 08:32:06 -0800
X-Google-Sender-Auth: fpu8Wm8x6OorgpYmXudHlGtkgtE
Message-ID: <CAKcGFaZz2fsoee9Ffn8nfj-1LUARaft3g6X2ixO8p+TmpjgD+g@mail.gmail.com>
Subject: Re: Greetings My Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.4 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:c36 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [rubywilliams266[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rubywilliams266[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
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
Mrs.Anderson Theresa, a widow suffering from a long time illness. I
have some funds I  inherited from my late husband, the sum of
($11,000,000.00) my Doctor told me recently that I have serious
sickness which is a cancer problem. What disturbs me most is my stroke
sickness. Having known my condition, I decided to donate this fund to
a good person that will utilize it the way I am going to instruct
herein. I need a very honest God.

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
Mrs.Anderson Theresa,
