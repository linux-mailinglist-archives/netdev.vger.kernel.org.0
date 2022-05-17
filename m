Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2C0529B57
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241122AbiEQHqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239758AbiEQHqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:46:40 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA94DB848
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:46:38 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j24so8252996wrb.1
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=s/Vs2ZOYlY/JdkHXcuvqGHiQEb2zIrOSrE98Tywd5ew=;
        b=mcUHXf3tKvTTHSet3lfw7hLN+sc92boiISSfAD5WYi/SXR5FAgCFyAJuJF24lZd8DV
         ksMbX1PwanT0U674XOQ/ebK2PGFwc07+aXa4NH4aEwKqUrHtZNed/p1n54qe2zXXUm5W
         TXR525tEFmioIhMSxLIkxxzv+5bgmR1ajqhKDlkF6388bFzKXEvD7yD78uW9jW+Y7YK2
         kGfWZQEtFOALf3lMBuEwUqv3mtsNfg44yZBqwiCSiqAfQj0xk6eEm4p/YJNNE3UamnBQ
         L+9nWosYSjArH7ZO0/kIiqTZmWn3ee6FtQP+ho57v1RFfeMYlXtb8buLdsQh1N1tQVZ3
         RtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=s/Vs2ZOYlY/JdkHXcuvqGHiQEb2zIrOSrE98Tywd5ew=;
        b=oiTywr9AopDSQ4AeCI9lZNNdaN9py4pEDjZLyimkUPzbplsZQO+TXnPF84yRiALGVp
         5V1kSNAYN1BGo2KqfqYGk0XyL17XGf1QkIxnmqg2LlQ/OoQuBjiWu9tau+ILeajKLvcU
         psqHSpVPIGqZxIfhB42um/7z+W3CBb9Lppfm02nRVyFCb4F81rHqaG4/YGD41fcc/p5W
         vifwc7WG7rvGQqUrL/+qVCjw9ussvKk1rHEgCHPls2F0xXXIXuYsAj8WxY2p/dbyFMls
         8urxPLTXYgUvdhHaGcXF9MGXo5WQvtMT+/WqgRVHF0lTLg7VgOhQYsheRfJaeA+WJtzZ
         W7jg==
X-Gm-Message-State: AOAM5313icEXviBEWed+3IhFLJRcAPg6CGcEOBIz1D1OQZIoXRnfhdEs
        thF/gkPnvKAnGIiwDsvWZTCJTOkoxgo7dtt8MA==
X-Google-Smtp-Source: ABdhPJwMGf9FKTEFSaiTTp+196a474H6NA9dhcbz0RrghlkjtAv0eGzbil3T0aSRBZ2Ja32SghZgVCn6Chil0+cKz2E=
X-Received: by 2002:adf:e444:0:b0:20d:1329:76ca with SMTP id
 t4-20020adfe444000000b0020d132976camr3073691wrm.553.1652773597525; Tue, 17
 May 2022 00:46:37 -0700 (PDT)
MIME-Version: 1.0
Sender: ds8873959@gmail.com
Received: by 2002:a05:600c:190b:0:0:0:0 with HTTP; Tue, 17 May 2022 00:46:36
 -0700 (PDT)
From:   "Mr. Jimmy Moore" <jimmymoore265@gmail.com>
Date:   Tue, 17 May 2022 08:46:36 +0100
X-Google-Sender-Auth: LGcQ5HqukgU2SyFATR3hVepue8E
Message-ID: <CAJB8rUgWqUqMzy+u1pVydZNSs=KRX3Z-7azXGGrqPZrR_snypQ@mail.gmail.com>
Subject: Dear Award Recipient Covid-19 Compensation Funds.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,HK_NAME_FM_MR_MRS,LOTS_OF_MONEY,
        LOTTO_DEPT,MILLION_USD,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:42d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jimmymoore265[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ds8873959[at]gmail.com]
        *  0.1 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  2.0 LOTTO_DEPT Claims Department
        *  1.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UNITED NATIONS COVID-19 OVERDUE COMPENSATION UNIT.
REFERENCE PAYMENT CODE: 8525595
BAILOUT AMOUNT:$10.5 MILLION USD
ADDRESS: NEW YORK, NY 10017, UNITED STATES

Dear award recipient, Covid-19 Compensation Funds.

You are receiving this correspondence because we have finally reached
a consensus with the UN, IRS, and IMF that your total fund worth $10.5
Million Dollars of Covid-19 Compensation payment shall be delivered to
your nominated mode of receipt, and you are expected to pay the sum of
$12,000 for levies owed to authorities after receiving your funds.

You have a grace period of 2 weeks to pay the $12,000 levy after you
have received your Covid-19 Compensation total sum of $10.5 Million.
We shall proceed with the payment of your bailout grant only if you
agree to the terms and conditions stated.

Contact Dr. Mustafa Ali, for more information by email at:(
mustafaliali180@gmail.com ) Your consent in this regard would be
highly appreciated.

Best Regards,
Mr. Jimmy Moore.
Undersecretary-General United Nations
Office of Internal Oversight-UNIOS
