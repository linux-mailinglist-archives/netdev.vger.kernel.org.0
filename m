Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA544E1D60
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 19:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343502AbiCTSQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 14:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343503AbiCTSQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 14:16:27 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8185E52B00
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 11:15:03 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bt26so21527149lfb.3
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 11:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=W6VyZQglGaRzyaUYQqRO466kEW6svyGhGiiOiHCSS+s=;
        b=ec/VIifhkLLePLUfS0lxZnt7L1Vho/kHdSrSztaYLuYO+S1voxi/watj9VF/koUzFn
         GDIWf+xhj6sXKVmPDhkLzWUjpVWoN7h79cR4A/AfQ1aTcwawHGmQ7lX6geibWNJ/wPrG
         /TPVgSZpZnb+orFftSnwfEkkDcwUXbLiMN3//PjyU3kwW95fYfOxYBxAIFnfXO5ltrQ4
         iQ1kbP/IPrQNwZpWQBeR+BapAjyDiRpxiR5tov2XL4eBeWNWj7R8et+oadMu0RTcUQe7
         rrYzacy9zdAkNrxTtwZDcyzkRlaOLzHcazyZorpvrw7wXYIzE8UTXglzeurG/YcIQcXI
         vXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=W6VyZQglGaRzyaUYQqRO466kEW6svyGhGiiOiHCSS+s=;
        b=yFfGsmfcEKehDqi3Vf+y3YQyjL3g9UZn1qIFgzfaabFtCGZFMT2yFwcFLJcA+Z3R1g
         R4wd9zkU6d/fbpcKTmlrkjt3dpmBr+L1MvYLBrnS55mmBMadlxUAKCJL4hOwRrX3X/91
         mTmernQGYFqCbmvrio3sOggaDwUzMOkVIsNucVXiVDq7EW7kolMO8kJnQjM+IYZ3iMXj
         wosXaZEt5BCUGGLJ9bK9dmmrdpDJ6YBpZHTzArr3wBL9BJGUWaXqT91ao7YAkaOL7BNM
         nvsPhcNJdph/AO66uAfCvdd/TYAuqQKlle6y4mtw3oxf5tz//5RsBbopS/dZOjqeD5w3
         5vxA==
X-Gm-Message-State: AOAM530jH61AVjDOVXi+Z2J/JkN0WMqNFlofE3o2X8QXX4ItmAQ7wIML
        Z6a76R0nMkXLykNWCtS+1DEpQ6vb4AdvyKVi+8w=
X-Google-Smtp-Source: ABdhPJxRHaEpUDknE0brnFZg7I5p4UJHQBH6nDLV/ZHGMwc4KqIFu1Ic82ngLsGVsSu+1I6ARVST+HknHXLBu53OLRA=
X-Received: by 2002:a05:6512:3cc:b0:444:23b0:f34b with SMTP id
 w12-20020a05651203cc00b0044423b0f34bmr11932885lfp.624.1647800101606; Sun, 20
 Mar 2022 11:15:01 -0700 (PDT)
MIME-Version: 1.0
Sender: dialloodama@gmail.com
Received: by 2002:a05:6512:3619:0:0:0:0 with HTTP; Sun, 20 Mar 2022 11:15:00
 -0700 (PDT)
From:   "Mrs.Yunnan Ging" <yunnan1222ging@gmail.com>
Date:   Sun, 20 Mar 2022 19:15:00 +0100
X-Google-Sender-Auth: DlVeSHTOOFIS54ZmrmTRK3baKS8
Message-ID: <CAMkG3NEqqp+xnTgOb6dGD4RajyQS0HdoDGNwrV8shOC-w9vY8A@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_SCAM,
        LOTS_OF_MONEY,MILLION_USD,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:136 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [yunnan1222ging[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 HK_SCAM No description available.
        *  3.8 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  3.2 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

        I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor
said I will not survive it because all vaccines has been given to me
but to no avail, am a Chinese woman but I base here in France because
am married here and I have no child for my late husband and now am a
widow.
        My reason of communicating you is that i have $9.2million USD
which was deposited in BNP Paribas Bank here in France by my late
husband which am the next of kin to and I want you to stand as the
beneficiary for the claim now that am about to end my race according
to my doctor. I will want you to use the fund to build an orphanage
home in my name there in your country, please kindly reply to this
message urgently if willing to handle this project. God bless you and
i wait your swift response asap.

                              Yours fairly friend,

                           Mrs Yu. Ging Yunnan.
