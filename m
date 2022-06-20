Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393E855249A
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 21:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbiFTTcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 15:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiFTTcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 15:32:20 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8701C130
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 12:32:19 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id b81so5621864vkf.1
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 12:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=iXfVGid5flDr/Pjg4urM++0HVmQRZoMWrda5i0vXEaI=;
        b=elY63pDquJdRVPIfbCIwxx9q0AfdG7qhmttrwS23ldZhm7PFk1B0Tu0+H4NMwnC2iF
         m+2Xf1M33RgwTDO9YRRhmCMhcaHKyFMmbfpud0+C13PzdVdWYxAAFZOLHV54frmqjjuR
         fu28JfuM4XD4ULbPAvSSG5bbnz3w/QHFHyJabew1XenXxN4/pWAvvG260BKt2kGGi4xr
         WoQb6+6ULTLhr+gX/C/laVAT4MIUsTWOmJUz9S8xbqU1W+gL+DM06tdYzaseYYLEDyhm
         07K6msYOagoZu3loubc3bzvtHtGfrg9iT8kEeqJdaqIXKoIUQ8Mi4e+O1Q0VOd0PHR7D
         xZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=iXfVGid5flDr/Pjg4urM++0HVmQRZoMWrda5i0vXEaI=;
        b=5Rq7Hc8hqkSrOu7oMFxvkZtyFEQE0mqCsD9pJ/s+KQH0iN+xetug9jmOxSGExE8PPR
         eKSGRkfRo6GOvtQkEsTlb2v6uZInhxgWCm8IULfp1haLcwYF8aocBMbHBHZwk80BpcmT
         4hqNpa75fb8BBoxtMLp6iKChRsI1N339tpHCA8jLA9iRCTymfjM43oRbstOUHl4CuDyQ
         PukUcxGy1CcTRIrP8BgjRpZVis6p2gFWPa9KjdboIHjYTPCnIl76QtJ2orvSb8HlV8n9
         tzJ0gNKRKkkhA6ey55zgCaPOi35ntrGKJyyd/O5n7dygX8scpnoIsuDIb4UUI0DlG+u+
         3sKA==
X-Gm-Message-State: AJIora/iiWn9yadOvguOtvqGM+49RrVLOhfzcCDzvQcwalA6yKxyJzlz
        uOdQtHfpLSeXGPhKzHMf14wTuMfTkhhMI2UoxIo=
X-Google-Smtp-Source: AGRyM1v3q4IDNYgYRvZkc65kq7kyJ1DfQ7iOXuuj8uAX/brywrc9Ncuyv5S5bOW+o6kHCDusb7xfpiosP30wZRLqy5c=
X-Received: by 2002:ac5:ca07:0:b0:35d:8527:8996 with SMTP id
 c7-20020ac5ca07000000b0035d85278996mr9916536vkm.0.1655753537548; Mon, 20 Jun
 2022 12:32:17 -0700 (PDT)
MIME-Version: 1.0
Sender: willalam744@gmail.com
Received: by 2002:a59:6744:0:b0:2ca:c69:730a with HTTP; Mon, 20 Jun 2022
 12:32:16 -0700 (PDT)
From:   Mrs Carlsen monika <carlsen.monika@gmail.com>
Date:   Mon, 20 Jun 2022 20:32:16 +0100
X-Google-Sender-Auth: NwS-QTV02hVD0nsyzAjJU8HZc1g
Message-ID: <CAA_vh5BqHXtB-41DzmirQk-ua6sXufn+xVv8XytTMX5Jx96RHQ@mail.gmail.com>
Subject: My Dearest,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.0 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_80,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a2a listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.9288]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [carlsen.monika[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [willalam744[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My  Dearest,

    CHARITY DONATION Please read carefully, I know it is true that
this letter may come to you as a surprise. I came across your e-mail
contact through a private search while in need of your assistance. am
writing this mail to you with heavy sorrow in my heart, I have chose
to reach out to you through Internet because it still remains the
fastest medium of communication. I sent this mail praying it will
found you in a good condition of health, since I myself are in a very
critical health condition in which I sleep every night without knowing
if I may be alive to see the next day.

am Mrs.Monika John Carlsen, wife of late Mr John Carlsen, a widow
suffering from long time illness. I have some funds I inherited from
my late husband, the sum of ($11.000.000,eleven million dollars) my
Doctor told me recently that I have serious sickness which is cancer
problem. What disturbs me most is my stroke sickness. Having known my
condition, I decided to donate this fund to a good person that will
utilize it the way am going to instruct herein. I need a very honest
and God fearing person who can claim this money and use it for Charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained.

I do not want a situation where this money will be used in an ungodly
manners. That's why am taking this decision. am not afraid of death so
I know where am going. I accept this decision because I do not have
any child who will inherit this money after I die. Please I want your
sincerely and urgent answer to know if you will be able to execute
this project, and I will give you more information on how the fund
will be transferred to your bank account. am waiting for your reply.

Best Regards
Mrs.Monika John Carlsen,
