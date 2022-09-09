Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22FA5B2F27
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 08:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiIIGk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiIIGk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:40:56 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4A1100413
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 23:40:55 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id k2so765412vsk.8
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 23:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=ZwPxd8LtjEuPX3lP8M/ewsRzKiwOr4k1fCds3gC7Jk4=;
        b=q76KvYsBB6xA6OjzsEFVHrFMMMjUOZWO5u/ThnWK8JAYlsIZ1a7lxNDBL7ELCzWLfm
         JAQSkTztIhqHRaLHas5kMlw0rEJr0qoLnDSemNELZofqkBKpoVHVXnoHZzl2DlkZ8SfY
         WVcGY+EV8co9s7rhwfeK+RiEO5ZF64tSOFIZxEtG4E3+q3lb3yrRTyo/fdvtNkDXjEaa
         +SxzJpgKQwdh2a691JIlGQlzGGiNZbLpA5NuN+i7wrfve+2zSVDMsrX4qJKjpyGBtbNz
         m6oQfw6Kzi4LxZpWSdCj3SBzqLcaH53Hwmc58FKak1IwYNTw0weCCk9DFM6nJy4bqhmb
         2nlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ZwPxd8LtjEuPX3lP8M/ewsRzKiwOr4k1fCds3gC7Jk4=;
        b=pPV2DB+UQ2sS/qSoT0Qss8mBHE7jC9k+Bisqj69s3e2y2qXd+0UXVNAXGUrFmaoq/e
         3d9GUAuRvqbVODKJ3aXML/Esi33OwsEv++wky4H2VV4QmzmAO8FVD5tiHW0vuQoH2qQX
         oxOqEu2EztbjD1ks/IakIbnLnhu2B92hBMMIGpQfMu+xDS8CN0ULbP8KQQ8KtZ4EZHg3
         CagHusOanDvtXGte08+bhKHC495K8dXdfcgcz+FHnJNDTUMB4mSMvGIdk5BMq7QSNQUU
         xEvqhi4MtmQHGw1ynS2TRMj1jIohSzKSQgcBXlixh6cyXfqIapiwARZHd4W6Hw31/waZ
         i6rQ==
X-Gm-Message-State: ACgBeo1j8jGRdT20M0OG3lOO9urW6kagHjEBupOt2xnuDYSxWTHJ+JN0
        8DlqlXZ+MX1FrUGPb5Shfs82UOuW7VSGDfNV3Us=
X-Google-Smtp-Source: AA6agR6LXtv3/TMR+vHI119gncF8zIa1KC6bV0OAB5fAmcSCSs7HigQVjfWqq5AiaSzaTTr5wUI/D9BXtMTRCt60J1w=
X-Received: by 2002:a05:6102:32cc:b0:398:2426:94a4 with SMTP id
 o12-20020a05610232cc00b00398242694a4mr3779553vss.24.1662705653746; Thu, 08
 Sep 2022 23:40:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6130:3a0:0:0:0:0 with HTTP; Thu, 8 Sep 2022 23:40:53
 -0700 (PDT)
Reply-To: stefanopessina14@gmail.com
From:   Stefano Pessina <egwusunday20@gmail.com>
Date:   Thu, 8 Sep 2022 23:40:53 -0700
Message-ID: <CA+E4gSP75ciOW=wLAYcNuz9DRmyG+H5=1H1qiCrYyVcptm3T7Q@mail.gmail.com>
Subject: Donation
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [stefanopessina14[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [egwusunday20[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [egwusunday20[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
I am Stefano Pessina, an  Italian business tycoon, investor, and
philanthropist. the vice chairman, chief executive officer (CEO), and
the single largest shareholder of Walgreens Boots Alliance. I gave
away 25 percent of my personal wealth to charity. And I also pledged
to give away the rest of 25% this year 2022 to Individuals.. I have
decided to donate $2,200,000.00 to you. If you are interested in my
donation, do contact me for more info
