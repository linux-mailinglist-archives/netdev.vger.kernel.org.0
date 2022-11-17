Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9748F62D7A8
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiKQKCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239207AbiKQKCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:02:00 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EBDE91
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:01:59 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f18so3795190ejz.5
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4p4pVS7VC9TcHDfadK6ymrC4GbUzeVc/hoFGnehieJM=;
        b=BkCSEu62Aso17tkj5HY+b3mLqNWjlnVAoS9W/e5Qj+5pf8mSShg4dSre7psZxXJz2c
         Y3LKJOGklyoyZZws4AyYENCWQ3+YjN4BBZnj6Urn1mldtQ9Hovn0yIdXkFgyKcFA+n2f
         ybTswzzvaUdDKskdql3oD+m7O8CQ9xtEOhp6srVry+M9tlOkBX375O8conVgZYkYoGNT
         65qZK3scORYeZrmf15TGD8GHrFAp0cjgcTYE5c8aCorXaDKOK42UZlvVGS37VMnyDBko
         69RxIii8kShJzgP/ZyskJ32IGbg3XF0KrkUcSuTOfu2YOOFZG8oJJn0E9tmU7MYSZh+J
         lhAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4p4pVS7VC9TcHDfadK6ymrC4GbUzeVc/hoFGnehieJM=;
        b=QoLV/Bk3KmdldNuQ0G5VEFulEm/iyZ2CPuVW59j54yUneXujH/0uBcFyiCPGjbcuEG
         dyFS1vcoKCtCLY1jlGKBBalTN1Fo1knntl3N1X+knsn28FLMmsT8jnGk6gL73xj/ms7X
         Xt22uieqqfCkmWme2lq/nNlanb9PHXy+w2WjXiK3jpMRhM0VzXhuZoNX2M+JTrZ+TogN
         fBYd7agyo6d8RFPSoZCZvKwIqcaT9LUtoypbaH9hOMBehQti//V8sy/zEWEoeeAoxmt2
         xwj21btvK9D/A4S/qTdJXKXijwv6YnK/cyMiO/7azdkxXExs9eN2f6pa8ti0wIuxXAjf
         NMHw==
X-Gm-Message-State: ANoB5pm+6R6U93LYw/X365tNjBPs6o0GArXgqxw1isMDjWnC9MFKQahy
        ni9y+g4lXsjJIiwiTAvEBgcTbvlxvorizuv9REE=
X-Google-Smtp-Source: AA0mqf66tPOnSRtuyQByMKFq4sOfsiqVgA/s0Wcymot1a7WfrnDzef92LP28Fygf7xorOyGd2nDR9MASC2QA+Wmr1yw=
X-Received: by 2002:a17:906:b51:b0:7ad:da22:c396 with SMTP id
 v17-20020a1709060b5100b007adda22c396mr1491144ejg.653.1668679318086; Thu, 17
 Nov 2022 02:01:58 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7208:8304:b0:5c:f162:645e with HTTP; Thu, 17 Nov 2022
 02:01:57 -0800 (PST)
Reply-To: alm195517@gmail.com
From:   Mrs Anna Leszczynska Malgorzata <mcburniep1@gmail.com>
Date:   Thu, 17 Nov 2022 11:01:57 +0100
Message-ID: <CAJsjrWQJCjA3nV_VoS9f4dfGsyJ0iS_ShRhfRLcUmAg5+OSXwg@mail.gmail.com>
Subject: =?UTF-8?Q?Hallo_Auserw=C3=A4hlter?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:643 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5088]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [alm195517[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mcburniep1[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mcburniep1[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kontaktieren Sie meine E-Mail alm195517@gmail.com

Gr=C3=BC=C3=9Fe,
Ich habe Ihnen einen Brief geschickt, aber Sie haben nicht geantwortet
oder die vorherige Nachricht, die ich Ihnen gesendet habe, nicht
erhalten? Wenn nicht, antworte bitte, damit ich den Brief erneut
senden kann
Gr=C3=BC=C3=9Fe,
Frau. Anna Leszczynska Malgorzata
