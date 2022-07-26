Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8E7581577
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiGZOgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239209AbiGZOgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:36:11 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37DD2E9CE
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:35:50 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id oy13so26542476ejb.1
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=lLG88JCPgF7Yhflf4FNi4GQedsSNMbwmPtgneUr9Mu0=;
        b=C5pQR2Z79tN7WTlxuygjEln/Qfd/M0b0YfaIaRWlL1rfEeunjJ7blMU6pFK+vxtq1C
         UNoVnwdELlHPg7G774el2LnbIYtbbYiv8BKXDTcil/F9PlaxuFetLawT0F6SmxxQ9Rg0
         eOI//qxTdZdo2JBG8a4GCryTa40CAE60ylxZulOxobLIKCMoWN7QfTLyEbsa5td22whY
         LAHmrD+b7p/v6ByQuVYR+DvwW3dGVCbPRBj8ta4Ax2Tphbw0qnfao89/NQk3z4yK+cZE
         +N+bKqLfVdVGQuk5myko/dbbRsoaTBcH8uxwLnTfuVHfBvNQwCbxGQueuVS3GBzpTE43
         kxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=lLG88JCPgF7Yhflf4FNi4GQedsSNMbwmPtgneUr9Mu0=;
        b=BmuhAjdxWbzxaKb8cfKJfzNjg+D3F4rUD8EddmF6rZiNqsUUmGX0JHXbTnDQoBB0+R
         V/dAK/Pih7HOdt9Z9aiyo5Vu3ChhxibyxprC6pBFJIKW2voz5RHd0Tbb5wq7P+W6rl2r
         FBHa4OPFSTfNXodRzrCkm6AEdis58YJJMRak/Ch7aUVo4j7gOZvENkVCqz9p5dTpAn7j
         vf0Okhr07dAU5BX3pidmMe3xeku5KqumimfUCq7jONj+jro3cQyMz41k6ywAZxXubrdr
         yJqnEmQjseO8DlMhLJH4vPdR2DevKKEq1F3qCYudwt9pHAW4WAdy7zVBp4ywmaZTYHvc
         oAVA==
X-Gm-Message-State: AJIora82c8urpMmL55ERq++rSPRIwf/dNGOn2IeouVPbwuLv0zUw7Jq7
        JIvctO2fm+n3tngxdXZqh/jIUpKddFutMhPGlCw=
X-Google-Smtp-Source: AGRyM1vacauXNjri9TjXYTZYnRadcQGnH7Upb1JiiiKntbrhAeXsqpMUf8vZ+ovojpm8BiQcCFoRhY3Km9nHB0clbns=
X-Received: by 2002:a17:907:7628:b0:72b:4d6f:ce8a with SMTP id
 jy8-20020a170907762800b0072b4d6fce8amr14310896ejc.59.1658846149188; Tue, 26
 Jul 2022 07:35:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:241b:0:0:0:0 with HTTP; Tue, 26 Jul 2022 07:35:48
 -0700 (PDT)
Reply-To: clmloans9@gmail.com
From:   MR ANTHONY EDWARD <zayyanusaidu009@gmail.com>
Date:   Tue, 26 Jul 2022 15:35:48 +0100
Message-ID: <CADM+8wQ5yg2rVJRjbgh=zh8mhN7bRU7ZwAMKbqYdkzyfeMfCWg@mail.gmail.com>
Subject: SICHERES KREDITANGEBOT BEI 2%
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:634 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [clmloans9[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [zayyanusaidu009[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [zayyanusaidu009[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Ben=C3=B6tigen Sie ein Gesch=C3=A4ftsdarlehen oder ein Darlehen jeglicher A=
rt?
Wenn ja, kontaktieren Sie uns

*Vollst=C3=A4ndiger Name:
* Ben=C3=B6tigte Menge:
*Leihdauer:
*Mobiltelefon:
*Land:
