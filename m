Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8D56CD043
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjC2ClR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjC2ClP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:41:15 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136263C04
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 19:40:54 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d22so8437183pgw.2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 19:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680057653;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QrW0Sz8GBPnu6OCGpvxmOnmlGOMzTNgDleQT9EalNAI=;
        b=OkNDySwxAesxaFth36/Mzl7ekLPFo+oNwgDe+0T5UcDNl4APWs3hQEAjiRkgsnQu0O
         Yml4M2s5IDKMLveM8Fmnqas1bqJmOpnvHr99BFECnjfS9BY4Q/ci9mG3D9WeV1ZOHsCD
         NKRcrLV5PdgLeaLzpS8ggduVSObE20ZSboebsUhDG8lm3pPCkEK9lVr1voVDf/uazZHM
         n/JLYEKjhLXaKZeZht27a+hjxcgRwK+KAF37G79+V9kXgBLFO8SLS/d6DVbNk+1Aygle
         iRYOBSRft0hvkw9b5VW89WBktQPE96dqVHjjvFcxpWn3GbHONqphIWRLTBvu21w993Ei
         elng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680057653;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QrW0Sz8GBPnu6OCGpvxmOnmlGOMzTNgDleQT9EalNAI=;
        b=TPub/XQIMAMFUMTkPkhuncFC4e+EFJwUZURzJoobnxZNjrAz1Clh/8mUHLc6yBxeij
         bXGe/E1qXzMx9cd41krlvJk6z3pEvUIPYnrsW5wxI4+pnaV9cgYA1WZ3d2KC3otFwNNc
         Zuts+sDnydowe3vFHpzUmXepne21vymW5dEZf1pkCs3bYbaXd+B9u4QxsiDbBYKLBlbC
         aGMrvEPnGVAxfiY3xdSAOGJDsfDOJSQ31IMFa0MUKjUH0YCb7Mq1CMYxn7bGbUx4oiLs
         Ngghwig7fitNQeYgsY+DD2hUZWAFLoJ8mgMIOtjdpRPsKICrQEtb0CDv5VN9tsdwskci
         yx7w==
X-Gm-Message-State: AAQBX9fcEDYSj32Ik7EatfEtZIK8vFeufnQTQW57+qIrIe/fqJN12ICG
        66uLqtz9Mk86B9pNT7tmar9RF8XwXogsJqlabeo=
X-Google-Smtp-Source: AKy350aAkY1aYMlLD5U7bhBS7K/8pLOtD4lziTaeYRACC24mb9WtgDOLIRpZtUKwdbqqDF95M7VTrd+Sh8/6B1Py9TM=
X-Received: by 2002:a63:d201:0:b0:503:7be2:19a7 with SMTP id
 a1-20020a63d201000000b005037be219a7mr4756120pgg.1.1680057653056; Tue, 28 Mar
 2023 19:40:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:bb07:b0:474:db39:4ff8 with HTTP; Tue, 28 Mar 2023
 19:40:52 -0700 (PDT)
Reply-To: davidllawrence14@gmail.com
From:   "Mrs. Nelson Philip" <johnkigundu17@gmail.com>
Date:   Tue, 28 Mar 2023 19:40:52 -0700
Message-ID: <CA+bdMsgZvv5aUYRsKOb_Bf_CEiANsFT15sn7NE3Xr-pHNCCjLg@mail.gmail.com>
Subject: Contact my secretary for your Bank Draft!!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM,UNDISC_MONEY,XFER_LOTSA_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:531 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [johnkigundu17[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [johnkigundu17[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [davidllawrence14[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.1 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.5 XFER_LOTSA_MONEY Transfer a lot of money
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How are you

I want to inform you that I have succeeded in transferring
the huge amount of funds under the cooperation of the new
partner from London and I have written a Bank Draft of $1.9M for
you.

Have you received it? In-case you have not, Contact Mr.
David Lawrence And Ask him for the Bank draft which I kept
for Compensation okay. His email address
(davidllawrence@consultant.com)Phone+:+1(945)212-0126

Mrs. Ester Nelson Philipsxxxxx
