Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B9C5B4ED9
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 14:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiIKMoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 08:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiIKMoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 08:44:23 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A50D33424
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 05:44:21 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 9so6634651ljr.2
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 05:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=VXlBS00/GuegNihbP9LSEb4G+N9nTOzbXeMOhsINvjI=;
        b=XpoArl7ff1h6D0gSVSU/rP94OJvGVV117RL7aC0lFzwT/82bFY0Rp3sLV2aPWEyoWV
         +kBMt//uXEFJKIsQAVug9jbFK6wbHUZfYBVG2XmxkrJvUAuNLilLQfDM9ObO0vJDn3HP
         uFh3DiEwN55E9ybN4w+SDX9CLwOe7e40EMpDWA7aVffh5XjRhFAfOuV+7HbyoKw6znVt
         rKLJDoSsdTROphrV4PM+7ZHIXHSFvCgdnBJOVRXSllAsh8JM+x3h7D0Ou2AOcDjGPi/D
         vHpTd80+Zwc++L7Q+0oUv7qBJGuysMWf2K/hXvPfawx2n/gcdvo58omvf5AOyhbjZv+A
         dVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=VXlBS00/GuegNihbP9LSEb4G+N9nTOzbXeMOhsINvjI=;
        b=tRdhc2vGbfh9vOlsoEchYfgKdTGe4rJHMYcjaomx0EBZwOTcLHc9VZMaobAW6PS85P
         sQRzrwnmZsvqNS5u3Nxmgl3yGn6bhaOj9ysMgXf+DeOAM0EMprBN7nCS4mZKIbM7Tc9B
         x5URxwVCGXUTx8fpS0RwJwhRFWs0xAVIcu/VEGV7oIze6p+7y63uOKm5alnX+4d7tpCH
         nz0+gS0ArcwL1M3IQmZdPkZglqxjba9LCf/KxFUOkoGa6Dpl0CBJDFA+TpKgkCUygaoU
         DSbob5HMnzifnCYHV9frBKyrJ88Trqvs68x2H2xsSXziIEOYGbYox6cB2r75t1Hptuf4
         IuNg==
X-Gm-Message-State: ACgBeo2cYNeBlxjt5ZL+XmW7zxKbGciEzyfL+bLhhk4swwMwEP5clbpb
        /0vGnpM2cc6MI14ulyXrcXiin7bjF5WGFE8/Ig==
X-Google-Smtp-Source: AA6agR77d5mBO13s3Dzm+PerpQco5W1DQHqkbuy03uqkYDXSOzpkZ7ShT0NoyIN3jSCSmY4n3fHtzf4FUq4tY7Jany4=
X-Received: by 2002:a2e:b8cd:0:b0:261:e189:710 with SMTP id
 s13-20020a2eb8cd000000b00261e1890710mr6244703ljp.331.1662900258858; Sun, 11
 Sep 2022 05:44:18 -0700 (PDT)
MIME-Version: 1.0
Sender: lyrilhill@gmail.com
Received: by 2002:a05:651c:1508:0:0:0:0 with HTTP; Sun, 11 Sep 2022 05:44:17
 -0700 (PDT)
From:   Mrs Aisha Gaddafi <aishagaddafiaisha20@gmail.com>
Date:   Sun, 11 Sep 2022 05:44:17 -0700
X-Google-Sender-Auth: 58evqtI_f4UPoeLUgBMxyxSIhKY
Message-ID: <CAGU6a+3FDPC_L6Umfy2j_MT1z=8G+pfyJwU_5MhfbdawcKrMSQ@mail.gmail.com>
Subject: GOOD DAY MY DEAR.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORM_FRAUD_5,
        FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,MILLION_USD,
        MONEY_FORM_SHORT,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_FILL_THIS_FORM_SHORT,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:236 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aishagaddafiaisha20[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  2.0 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
        *  0.8 FORM_FRAUD_5 Fill a form and many fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm writing this letter with tears  from my heart. Please let me use
this medium to create a mutual conversation with you seeking for your
acceptance towards investing in your country under your management as
my  business partner, My name is Aisha  Gaddafi and presently living
in Oman, i am a Widow and single Mother with three Children, the only
biological Daughter of late Libyan President (Late Colonel Muammar
Gaddafi) and presently i am under political asylum protection by the
Omani Government.

I have funds worth " Seven Million Five Hundred Thousand United State
Dollars" [$7.500.000.00 US Dollars] which I want to entrust to you for
investment projects in your country. If you are willing to handle this
project on my behalf, kindly reply urgent to enable me provide you
more details to start the transfer process, I will appreciate your
urgent response through my private email address below:

aishagaddafiaisha20@gmail.com

You can know more through the BBC news links below:

http://www.bbc.com/news/world-africa-19966059


Thanks
Yours Truly Aisha
aishagaddafiaisha20@gmail.com
