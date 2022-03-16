Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2814DAE6F
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 11:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355198AbiCPKqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 06:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355203AbiCPKqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 06:46:33 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D93657B1
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 03:45:13 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id m12so2137084edc.12
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 03:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=CNNPGySxSq7bZ1La6vvay1kp1T7RaMnfdFjrr49KhAk=;
        b=e+7Pujayr+BADQoJSL+IxBeAdPJFJmwFlgmBDsEbnAniNupooycgoFV+/Jx7/OtThM
         25J2jAhXxmzbxPDdSdL7FucpmDM7rKVqWLyBWIWlF4Y3lQBl2KhGDAhB4y3cch++pETY
         bISSFlqK+KnnKtTSl8EyLdnxJyQPg64+HIqS3mErfWxnV73VwxwCwOj1EQ1g6KK/bcqn
         eQ6rDP6Di1nA3JWN4y6K/EBn8KztV/wuD5qNrWjoTkbzNuptb6ey7++ymmXoFdtj1UoJ
         I6b//SgcUng3p+AgmxbLJ9TysJmcwMBfCmgFmQLKgM1GMjtzEqram5VlVowD1ZYX+I2U
         WEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=CNNPGySxSq7bZ1La6vvay1kp1T7RaMnfdFjrr49KhAk=;
        b=w+G/5jc1dFl6eSwiHFSfV/NrAOA4HfYJt7GSXWBPkZoJrb6NozmqthUVdgGml62uUV
         SVOEc+rkkZRKBLoWwBTiCeD6aV+crryfO4qTFBhArhVpHM9gXhbTcYkG9L7yumLbInUQ
         uDi5KYWgInvQS5LFh4Lrby0nAfR5yvINrX2MDrUitkzJrCrMJccU+dMQpaChX4D9UFy1
         quEbEmuoagclnXw98PhsMbnvVSAxbXbPi/cYrG5nLnwdX5MvSGyfXmLh0kC5Tg/9fGvA
         ldyaXWkI1smpG4I+7JYUb9cCP+bhuQKiMShDJilph1A/VxgyD17VBmKgOydJHTkIDA3c
         A3CA==
X-Gm-Message-State: AOAM532yoQ2AFLljUsoZ5a1ygZkgu1mS6EFXnSVTZ0nCS18mtJEKeFVB
        Fn+uD91twb/GPP+12CxJqNyHDMp6Y2dgkl+4+CU=
X-Google-Smtp-Source: ABdhPJxNr/2j/aqA4KleMsQXKszsTOViznD+AKIRGbPBJaskScohycYc8w3HNK+QrDb3YZ1hp6zxyV/PGdUtyhB6YNY=
X-Received: by 2002:aa7:cad3:0:b0:410:b188:a49a with SMTP id
 l19-20020aa7cad3000000b00410b188a49amr29352207edt.416.1647427512225; Wed, 16
 Mar 2022 03:45:12 -0700 (PDT)
MIME-Version: 1.0
Sender: mrslila67hber@gmail.com
Received: by 2002:a17:906:1751:0:0:0:0 with HTTP; Wed, 16 Mar 2022 03:45:11
 -0700 (PDT)
From:   "Dr. Nance Terry Lee" <nance173terry@gmail.com>
Date:   Wed, 16 Mar 2022 10:45:11 +0000
X-Google-Sender-Auth: g63vNiXMwN9z8Ovvy2Ygpr12QNM
Message-ID: <CAGq_i_1go_TEDHodEQ-PAi=_NAvTJJrnsc9nQvAhuBAsRu_K4Q@mail.gmail.com>
Subject: Hello My Dear Friend
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_SCAM,
        LOTS_OF_MONEY,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:541 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrslila67hber[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 HK_SCAM No description available.
        *  2.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  3.1 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello My Dear Friend,

I am Dr. Nance Terry Lee, the United Nations Representative Washington
-DC - USA.
I hereby inform you that your UN pending compensation funds the sum of
$4.2million has been approved to be released to you through Diplomatic
Courier Service.

In the light of the above, you are advised to send your full receiving
information as below:

1. Your full name
2. Full receiving address
3. Your mobile number
4. Nearest airport

Upon the receipt of the above information, I will proceed with the
delivery process of your compensation funds to your door step through
our special agent, if you have any questions, don't hesitate to ask
me.

Kindly revert back to this office immediately.

Thanks.
Dr. Nance Terry Lee.
United Nations Representative
Washington-DC USA.
Tel: +1-703-9877 5463
Fax: +1-703-9268 5422
