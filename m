Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1255A4E28
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 15:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiH2Ncv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 09:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiH2Nct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 09:32:49 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765BE6746A
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 06:32:48 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id bx38so8031596ljb.10
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 06:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=5SGZXXm779vUUr1cqzGV/gRigE4jlSEMeyxYIdb55pM=;
        b=X8PtJUK43H5ngwOQiAyXfp8CuniJ87ORWH/CWljHxTZ9t1ErLUfVufou3WBcwM3JE7
         ozcvBpB2p/PYunkZ5SS5BCpA487a3xuCi+V4z9crA9BVvumHUajEveeM5Ay+3Na37m2I
         y9DquKeo6C1QD0gnX4xomsoa/Ge6VKg+dtbMYBl2REH7qLLEfgr9TAwOp0vLYus/6Ppw
         10wvOOsth6PmgzCmXdCQ1jNxvKC3tQPYsVvpDIfrcVSXgWmlUtzvwhbu4e1IKxS0hiLc
         q0SPQV+PddQlXCi9WDlkfHwqJvQoX1dZbtfd9La+e0vOdw+G8S6An3pYNNh9LoV48Vd3
         QmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=5SGZXXm779vUUr1cqzGV/gRigE4jlSEMeyxYIdb55pM=;
        b=qaLEi9e2JjcunJns18oet8nlPbM6IkYX/CVkPTKlZo73uTk1+ibq0alif1FPLYfLku
         J+avpj2GaLt3nZtvx+w8uD7Iid4MfCginuXdFRZEzeEmASWen1RVIz1T5uDtM7DuE2ir
         IZrqRwvNA/CyPJ9pBrIZ9ikbUkfxRVcXJmojeB11eVLCX8orZHROkHLL7dkYHzxAQ9Ur
         oflwiADK2K0c+Yy09Y0oUbpyf488PmX82gUKstHkXmVtbROe3CtQIYo0UcthmWnlytPW
         idY2bWlFGuHvPGFrqvDYDKaLPVr7zotaIFai88WBmtM9HsPvR9HpKP0yqpGIdeQS2c5l
         F6eA==
X-Gm-Message-State: ACgBeo3x9oWvMKIkM8DxB9JKUf/z7G82zzfCQINdS/TelIbOM16Ktkxu
        PoW8e/MW727o4/Ad92T8Z6y4eqtUo/+U5+REsnE=
X-Google-Smtp-Source: AA6agR4VBy7bii+UfWktd78QRagaZw1TMVJpRmc8UX81fwDZqJsTLvXIdgTU2CORgCai9s0Ysqbyv/R8T02/QUXCXGk=
X-Received: by 2002:a2e:a602:0:b0:264:5132:f59 with SMTP id
 v2-20020a2ea602000000b0026451320f59mr2193233ljp.0.1661779966793; Mon, 29 Aug
 2022 06:32:46 -0700 (PDT)
MIME-Version: 1.0
Sender: sorerachid81@gmail.com
Received: by 2002:a05:6520:6104:b0:213:94e:9775 with HTTP; Mon, 29 Aug 2022
 06:32:45 -0700 (PDT)
From:   sofiaoleksander <sofiaoleksander2@gmail.com>
Date:   Mon, 29 Aug 2022 14:32:45 +0100
X-Google-Sender-Auth: 8YuEODoZZ6nxlqOW2SsuOD5RAiY
Message-ID: <CAKL4mReMaSGM9fBu_K-P=UfxLYx150puYYd=icn75uc+rtpHYw@mail.gmail.com>
Subject: Hello my dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_USD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:229 listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [sorerachid81[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sofiaoleksander2[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear,

    My Name is, sofia oleksander, a 20 years old girl from Ukraine and
I'm presently in a refugee camp here in Poland. I lost my parents in
the recent war in Ukraine, right now I'm in a refugee camp in Poland.
Please I'm in great need of your help in transferring my late father
deposited fund, the sum of $3.5 MILLION UNITED STATES DOLLAR, he
deposited  in a bank in United State.

the deposited money was from the sale of the company shares death
benefits payment, and entitlements of my deceased father by his
company.  i have every necessary document for the fund, i seek for an
honest foreigner who will stand as my foreign partner and investor. i
just need this fund to be transferred to your bank account so that I
will come over to your country and complete my education over there in
your country. as you know, my country has been in a deep crisis due to
the recent war and I cannot go back.

Please I need your urgent,
sofia oleksander,
