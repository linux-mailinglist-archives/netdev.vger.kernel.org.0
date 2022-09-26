Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F285E9CF1
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 11:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbiIZJGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 05:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbiIZJGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 05:06:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73DFA474
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 02:06:01 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id c11so9093795wrp.11
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 02:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=EThfXOsChd8Ds/teM8XF9/4bZFxtFbmMMLDhrhk/LVg=;
        b=DnaQCNuqI7YSl9diMkV0Phe5gck2YthiQbLNBwxi9b70X/O5ZgIVgTSXcx25kPu56M
         C9bQxEhpsreQ9xjpuSh+UJ691XM2eJlWwuQDp0hgfALj5rwZLmIJN/bAceIkW3aN/jSI
         pY+d0QX8W8lvPEykf4R3CRz2Rw0ew5xbrULwDz0PhbAzYncEa83t/fGRI6J4d/IhYWz2
         uePY4dIf9rvm0RicRYxv1QEoZ5OHjgeapeVgs9fche0DKOzMRPakEw3+YzsDbpKZyvfX
         jPxMXzjVm6Dmwbn76y7VOWERYWa+FiyLECE4t/oDX1W/v3A34Tx7QSn/a0jDgNwARDQB
         AThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=EThfXOsChd8Ds/teM8XF9/4bZFxtFbmMMLDhrhk/LVg=;
        b=zmUYZkW3hbfQCxIcgZimnvIUxM+ZIzL7lc/3Azjb3ltsGo9+fMfec2xiYblK0jYD7x
         xDN6hrSaPrdltF/UX7lQaxUrfVyP59E4ky7vDukq/6eISwcS3+iBWD1y59gQTxF50QZ2
         DbyQYWqxsBrYuhurClHrPJ55PkPZDNfQjZUFLrkGrjYXgSRE6l9qinj3C0t1N9Ewf9SL
         8DRqbShJ3W3qf1ewkU2eeizaoogiXrczM2NGzmOpSOMOQCeOC1OPtZVtRS2a6bu/se6S
         H+Zurs5CBR858i6jcFqc3Ho+PHEfkRdJ94AuxnNU+xf8RBJDCvCm441HdZYjZn/XQIIe
         p2Ow==
X-Gm-Message-State: ACrzQf2O4Ho/4f7roCcCniMl2hSCLScGSiOGddnECr2B8K/jlgqEAAun
        sIRLbwGdL+nccvis79ZjHu7zSWIKr+22EaHtX1o=
X-Google-Smtp-Source: AMsMyM7WNrufw5UysKbciMzkbhJYp7OflmS+RyQglB/aMR4l44dKDl8UbgVqM02LOf3DrRzPgxqRue+lV5hgWUbu4tg=
X-Received: by 2002:adf:ff85:0:b0:228:c365:de29 with SMTP id
 j5-20020adfff85000000b00228c365de29mr12260442wrr.415.1664183160296; Mon, 26
 Sep 2022 02:06:00 -0700 (PDT)
MIME-Version: 1.0
Sender: amzzywisdom@gmail.com
Received: by 2002:a05:6020:a2d3:b0:213:d018:20e0 with HTTP; Mon, 26 Sep 2022
 02:05:59 -0700 (PDT)
From:   Ibrahim idewu <ibrahimidewu4@gmail.com>
Date:   Mon, 26 Sep 2022 10:05:59 +0100
X-Google-Sender-Auth: lQ7XvFNTxS9Dvt_5J2XTG7XywBw
Message-ID: <CAHmYgf6QuHxdGpSQYd8yRZd2rYiG8_51HppUi_-sPObD2YxgVA@mail.gmail.com>
Subject: I Need Your Respond
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.3 required=5.0 tests=ADVANCE_FEE_5_NEW_FRM_MNY,
        BAYES_99,BAYES_999,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FILL_THIS_FORM,FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MONEY_FORM,
        MONEY_FRAUD_3,NA_DOLLARS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_LOAN,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:441 listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 0.9998]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 0.9998]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [amzzywisdom[at]gmail.com]
        *  0.3 NA_DOLLARS BODY: Talks about a million North American dollars
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.2 HK_SCAM No description available.
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  0.0 T_FILL_THIS_FORM_LOAN Answer loan question(s)
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  0.0 ADVANCE_FEE_5_NEW_FRM_MNY Advance Fee fraud form and lots of
        *      money
        *  2.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My name is Mr.Ibrahim Idewu, i work in the bank here in burkina faso.
I got your contact
from internet search i hope that you will not expose or betray this
trust and confident that am about to entrust in you for the benefit of
our both families.

I decovered an abandoned fund here in our bank belonging to a dead
businessman who lost hs life and entire family in a motor accident,
I am in need of your help as a foreigner to present you as the next of
kin and to transfer the
sum of $19.3 million U.S dollars (nineteen.three million U.S dollars) into your
account risk is completely %100 free.

send me the below details

Your Full Name.

Your Country.

Your Age.

Your Occupation.

Phone Number.

contact address

best regards
mr Ibrahim Idewu
