Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040666A7262
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 18:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCARyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 12:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjCARyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 12:54:11 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F3E420E
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 09:53:53 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id l1so11073610wry.12
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 09:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677693231;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SMt7axMQbQeEE0CBN+7cLsm38pqjF8+UDAWISk+ju1w=;
        b=Y48/7TJMkuAooHPX/5fCy8Pu2KlC0b1QWLaHlJRC1A/cTfejiS/pqkaP/5RkbpSiMt
         j6nBcxPY5VMGju2hjsyHsgOxGoHQQM+5V1LpGh+8XemefhdyP8DDypNpKFrLLvEyx8TM
         rtx8G0kLIqvH+r+VFHUsG+culSCKYx5HqVJe/IAdofHC4bsDnv3y7RZWSWITY4B8QI5X
         d3Tn2At1n15kW3pl6xT4UV22b5k7qwCyKigV/cO2k5d71TtWm/1Cv1GcmhK94oHCssbj
         3rhoc1SuMHo9W99kc8fOomy6mt9WQvN9ck7mgz7Evd6pL/nUnsJnL16Kdtn5MrSU76W8
         JLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677693231;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SMt7axMQbQeEE0CBN+7cLsm38pqjF8+UDAWISk+ju1w=;
        b=UW2HwwreJcBrT5xqgEZFVArUpTxrC40yTcqC9poOgJ5H5HIDEguHsn1G/XcluJJ3/e
         s54QwwaW9nL4JJXiFtP4Ec7M/K6DacCf+QXTR6tufs3z7OAoDgg7JxUxo4HOI7hop9rm
         /E6wOLauo+6UsAGOTkHNYgcQPnbtLYxaF11FhcXbojpSp6FZFOvARq+KApee6dmyhtXK
         ANO0Hay0MjvL596+Ey9D5lPpP0xH52h4aiF3uraB486TCZLEBHdp1ZrO/jBuID7aBsEb
         k0cH7E2wnoLyUY9OE2+dX8zWFxyPxCZnIJ5iUtwGui6n6hsEyQeKf0SDXTrLv/YXfl52
         3yvw==
X-Gm-Message-State: AO0yUKVPoo6wqIEGMvlrGToQFmMTPrgg6CsDRj7oxx/uphh46ppIZumE
        R4pUzeH1SXcGdDWcJMNi+nLqbnDz5TDg98fTUxY=
X-Google-Smtp-Source: AK7set9z6uX2WMIASh8NP4bcA8VPH95sb0tr3ntszKOnHfUxWEWFiB7TkTqLTN9IRYFytqWgysFq+lB93lhX65Q89wc=
X-Received: by 2002:a5d:4e44:0:b0:2c5:fd95:c495 with SMTP id
 r4-20020a5d4e44000000b002c5fd95c495mr1543334wrt.4.1677693231489; Wed, 01 Mar
 2023 09:53:51 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:adf:a35b:0:0:0:0:0 with HTTP; Wed, 1 Mar 2023 09:53:50 -0800 (PST)
Reply-To: sackrobert@yandex.com
From:   Robert Sack <felixfernando.6500@gmail.com>
Date:   Wed, 1 Mar 2023 18:53:50 +0100
Message-ID: <CAA6riO2TGGFJijq8=k9NOcCTrcS-8FgUP4rYknrHdBEhLfYb3Q@mail.gmail.com>
Subject: INVESTMENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:42c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [felixfernando.6500[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [felixfernando.6500[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Partner,

My Name is Mr.Robert Sack from  the United Kingdom.
It is my resolve to contact you for an investment proposal.
I have a client who owns a pool of funds worth Eight Million,Five
Hundred Thousand British Pounds(=C2=A38.5m)
and wants to invest in any viable and profitable business that has
good returns on investment(ROI)
such as Manufacturing, Agriculture, Real Estate,
Hoteling,Education,trading and others, in an effort to expand his
business empire globally.

If you choose to partner with my client,please indicate.

Thank you in anticipation as I look forward to reading your reply.

Mr. Robert Sack
International Financial Consultant
