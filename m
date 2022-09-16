Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021785BB063
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 17:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiIPPlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 11:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIPPlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 11:41:16 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6832AB188
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 08:41:14 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id c9so33104694ybf.5
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 08:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=WS4wMSByWryX8P5xXNg6/F9cuXaZcQ/JDEQQ6/oYhcI=;
        b=LS3lpM1Izz1jLYKINOK0iZqjPGFVaHiY5DIdweACd7fqi60AYg++R7aMjEVFwtFZQx
         IqLrogNzvVqhmBL5Wm4/izbiMkWNK/g2H1ddO10KbVmwr+d8IVZSvKTvRdxjpf84g1hK
         otfaEqtCqn22fdwsGPDudnyglFpywLpNs9v3QmUlK9X7loj3rNKl3wpDYJC41IS/d5mm
         iuzH99s3vYHqMlCKMrjr88TBQpY8D8wqlk4pBGCdfigd2PLEd1gdcg+FrdR6j6Y5mCgU
         31/dxcDHZG56H3tUsidURXVdmZqvDh/HlRdqPVRfcpn2uIBJfWG9KdCpGcSTN2mH8er4
         O97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=WS4wMSByWryX8P5xXNg6/F9cuXaZcQ/JDEQQ6/oYhcI=;
        b=M6b09ZB8KVmPJfy0AACj5aaF8ZpyrxKxJXN+Wf9lbd9Hhkml82FC8UoBEPvTu8L7R/
         na8vN7GBprXTiYsk5JONJyJyRvkEHD8etFjeTXXNY0wrcIQnRq5IWZsNd2wEV73sTh/n
         eGJZg3Bvf+c1C8GZyjvBgXTnXHNJyIda1W8gZOtY2mdfnymdSwkWau2xDnzKRoRpEoS/
         5Nel44xynjv/W1AeI3ljXJjfoxR81OVS/ODMZZ0joUuXqNUWLNQuTxQjg2dNqEUWoVSY
         VWDQiVjblp7fGJ6BNX99+B430OiT8pFWbELURAjhlcqxA6b/UWnwEeQa96vkQch49Xys
         dFMA==
X-Gm-Message-State: ACrzQf3UbwprUSi2ubdnpx5tbdsLArH0iXenY38C3Yo3Mqt474G4QoVV
        DiXCe3Os2+nP+mxfhDu5kN21L3e/4VosXrLKTQ==
X-Google-Smtp-Source: AMsMyM7J3bLUA+EjaA0YkKAdIJjIwoT7Zr0QyVTu59r3vLAdsx8VVufDsAJN4XzjyjYSfUagWHFZFX1hbypOrpXK4mk=
X-Received: by 2002:a25:bc7:0:b0:6af:d9a3:d721 with SMTP id
 190-20020a250bc7000000b006afd9a3d721mr4749369ybl.47.1663342873563; Fri, 16
 Sep 2022 08:41:13 -0700 (PDT)
MIME-Version: 1.0
Sender: chantalstark91@gmail.com
Received: by 2002:a05:7110:4b14:b0:191:623f:b301 with HTTP; Fri, 16 Sep 2022
 08:41:13 -0700 (PDT)
From:   Aisha Gaddafi <aishagaddafi6604@gmail.com>
Date:   Fri, 16 Sep 2022 15:41:13 +0000
X-Google-Sender-Auth: io8dJXu7KMosoapyuElj2j2HB-w
Message-ID: <CAOzO0HQuPRJv1At7u5g1sysOWqrCyrR+P8X4_SPp5gZjh0J+Fg@mail.gmail.com>
Subject: Investment proposal,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.3 required=5.0 tests=BAYES_99,BAYES_999,
        DEAR_FRIEND,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_HUNDRED,
        MILLION_USD,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b32 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [chantalstark91[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aishagaddafi6604[at]gmail.com]
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend.,

With sincerity of purpose I wish to communicate with you seeking your
acceptance towards investing in your country under your Management as
my foreign investor/business partner I'm Mrs. Aisha Al-Gaddafi, the
only biological Daughter of the late Libyan President (Late Colonel
Muammar. Gaddafi) I'm a single Mother and a widow with three Children,
presently residing herein Oman the Southeastern coast of the Arabian
Peninsula in Western Asia. I have an investment funds worth Twenty
Seven Million Five Hundred Thousand United State Dollars (
$27.500.000.00) which I want to entrust on you for investment project
in your country as my investment Manager/Partner.

I am willing to negotiate an investment/business profit sharing ratio
with you based on the future investment earning profits. If you are
willing to handle this project kindly reply urgently to enable me to
provide you more information about the investment funds..

Best Regards
Mrs. Aisha Muammar. Al-Gaddafi..
