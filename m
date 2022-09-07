Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A505D5B06AE
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 16:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiIGOby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 10:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiIGObc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 10:31:32 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6941FAB4DD
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 07:31:16 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gh9so8900324ejc.8
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 07:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=UTPjlhWN0j/3cl0uibj9IdU3K9tIHCNTd74bAPWV+BQ=;
        b=boA3graP4wtJe8cwRxkMJy5rso3t9xyj4fxUFsG0Fez1aWDY0C6gZpYPvm/Hxa5tX5
         Zk+XDE4h4sSr3Kc7gAmKt5OJ7AP3AEEipJ5m7D7tQ5BTHkXWMmIdiC/g3MqGg04yG8Wz
         mFTYUlKwIYoLI0bvi9Q3MSV1athb174l2Ms/7z+L0TzD2CQLBWt0bOa5Jg9CBAeygplA
         zqROn488xUY/B608ffA8/XOsolF390gA0UeCbMrgWX87LxLuf34XOCHn+1VgcYnMY7Sr
         klavsMj/u/K0iLTegE+9syCXTdcAl7jimLLfNxQJoiGWtjh15Idxzz9bfpV/1Jhy4Wly
         oLRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=UTPjlhWN0j/3cl0uibj9IdU3K9tIHCNTd74bAPWV+BQ=;
        b=CgzJWXmypaeNtSOlkFEsLQpKqrPc1yXoZXPz/sn/zYRxG181oPumIfEcHEov8Uo7uK
         cIjlhIvZHsM2N84OrdagRwYswK/jTo6zp348XGY58oVLDqBvh11AEuttgkk3iGTg02cf
         zG961TTqAe1O62GL4x5m9ma4il0zPxJWB2fHMV46M5UhNA1ak+Q48LKyS04oY3YGv1s3
         pOlQf0jqFZAaRKrmjsRtd5hbKtNfHajL1vrqxLeD/AQL3aK6Gu5A9Bm8ChILZFxhru1V
         okZ31y+5nxPxJP9GMEzQ0c11NtL7V5BhdmMduOhFQakDh8Z08lfxTqvsfgFYqFqQTxp9
         xeVQ==
X-Gm-Message-State: ACgBeo33z0ERTJGjBR+ErE4cKzGboF/xvDM0/wF5/EEZW2iOK5RPMLE0
        m2/QDq3JWs01BlvYVaHaIZROqtB9jMuKD9Aky4U=
X-Google-Smtp-Source: AA6agR7OKiKkSx+MbdKnn4tKaQhdmVzFj2krU0Vhk4MjDetoGwDDBbw+8TT3Fj+g2bgbPAiBcK/73KQpnrd5Cpv4s3c=
X-Received: by 2002:a17:907:75ec:b0:741:484b:3ca4 with SMTP id
 jz12-20020a17090775ec00b00741484b3ca4mr2508106ejc.316.1662561074796; Wed, 07
 Sep 2022 07:31:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:3fc4:0:0:0:0:0 with HTTP; Wed, 7 Sep 2022 07:31:14 -0700 (PDT)
Reply-To: lumar.casey@outlook.com
From:   LUMAR CASEY <miriankushrat@gmail.com>
Date:   Wed, 7 Sep 2022 16:31:14 +0200
Message-ID: <CAO4StN0fh9iLpvL71MAvphxmFm4ur7+Op=qm5oJuhdRZZPJ3cA@mail.gmail.com>
Subject: ATTENTION/PROPOSAL
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=ADVANCE_FEE_4_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY,UPPERCASE_75_100 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:643 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5049]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [miriankushrat[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 UPPERCASE_75_100 message body is 75-100% uppercase
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 ADVANCE_FEE_4_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ATTENTION

BUSINESS PARTNER,

I AM LUMAR CASEY WORKING WITH AN INSURANCE FINANCIAL INSTITUTE, WITH
MY POSITION AND PRIVILEGES I WAS ABLE TO SOURCE OUT AN OVER DUE
PAYMENT OF 12.8 MILLION POUNDS THAT IS NOW SECURED WITH A SHIPPING
DIPLOMATIC OUTLET.

I AM SEEKING YOUR PARTNERSHIP TO RECEIVE THIS CONSIGNMENT AS AS MY
PARTNER TO INVEST THIS FUND INTO A PROSPEROUS INVESTMENT VENTURE IN
YOUR COUNTRY.

I AWAIT YOUR REPLY TO ENABLE US PROCEED WITH THIS BUSINESS PARTNERSHIP TOGETHER.

REGARDS,

LUMAR CASEY
