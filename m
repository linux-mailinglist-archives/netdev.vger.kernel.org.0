Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80D3539359
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbiEaOvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 10:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiEaOvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 10:51:23 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA101F43
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 07:51:22 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s24so11709030wrb.10
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 07:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=9qJkg5Z+wIWpmyUb7QfLD447DoWpF3sHM+p4Olw2jtM=;
        b=AAUkhlXOe0Lb6sTEi0waHe2k904oXQQEdvyzISlotgX3WvqG6cC6LYvUk9TjNVE1kQ
         pRmoNqjv1hcwOtOvQmgTnQME23Gqf+odmemh26QLjEF/SVnD6N4RS2YXQIrPHmg+6pdB
         FKFU2meZHzBcwhnaJjizhbLWLab+Adpr3CmPQOeBzmw+mBsPv4g2/TTzMyIBbGwYOSto
         KlOD0+g4V1hsT4AMz9f9XxgDLK3IDOqUYGAiBO+xm7c4fHwzdoG34i16XlNVuQjtPBQR
         lykrlHbm7ExQJpswYI7dwmeIW0GC8ZP8Cuf9ynjwM2c7gjPLyn7T9UfK/vxUj53txPut
         aVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=9qJkg5Z+wIWpmyUb7QfLD447DoWpF3sHM+p4Olw2jtM=;
        b=n3hQcdiohN6S//AoIGZCwVUmvjPhwh8YCxA8g1vCsYwD/bplkEneSBNwR5FlNUoWFM
         UJwc58qwNgWcQ1+Te64OdWenRunWwo+enNVHky8z1RKVaTjOHtDflBOQ8MkK2d6a6DHr
         VtDbNeknjOrR7d9hqO9FBavcemyM6BCd0Bxv411pn5grdRNNTsM5SwBQyt1i8ACcZIVH
         tPvCF/O3Hime0mXmrQwJ6pFGmqWMbfnwDOkFNoFLv9zd32+azKM3UP6ipPbF6oLOVc+k
         sn2qlNBRnVKvdtObANfRyUMm2ccDlTz2qeQrj+BWzq4cLTqtwR6l6/pySIDESHcHX3eO
         OIxQ==
X-Gm-Message-State: AOAM533+gRcrvrTOxSq9QV5TiPNuVWO+xFMUt14nhKoJ4EQ962TILars
        RFDjFg8Q9xzcEZaMMlDSdLW5/VNiM4v5UM0O
X-Google-Smtp-Source: ABdhPJyFcvQS7aje/U81V3AsB/++yKi/5N7XWUnXlSCqVN4fiCiz065wpcdJ9SoqKFk8dWtjGzDFgQ==
X-Received: by 2002:a05:6000:1815:b0:210:dd9:a9c2 with SMTP id m21-20020a056000181500b002100dd9a9c2mr21266383wrh.385.1654008681581;
        Tue, 31 May 2022 07:51:21 -0700 (PDT)
Received: from DESKTOP-SGSHA6E.lan ([102.134.114.193])
        by smtp.gmail.com with ESMTPSA id m19-20020a05600c4f5300b003942a244f2esm2662301wmq.7.2022.05.31.07.51.11
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 31 May 2022 07:51:20 -0700 (PDT)
Message-ID: <62962b68.1c69fb81.d53d7.bd48@mx.google.com>
From:   Jerry McCumber <nm8086908@gmail.com>
X-Google-Original-From: "Jerry McCumber" <jerry@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Greetings Sir/Madam.
To:     Recipients <jerry@gmail.com>
Date:   Tue, 31 May 2022 14:49:16 -0700
Reply-To: info0817155@gmail.com
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:441 listed in]
        [list.dnswl.org]
        *  1.5 RCVD_IN_SORBS_WEB RBL: SORBS: sender is an abusable web server
        *      [102.134.114.193 listed in dnsbl.sorbs.net]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [nm8086908[at]gmail.com]
        *  1.9 DATE_IN_FUTURE_06_12 Date: is 6 to 12 hours after Received:
        *      date
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [info0817155[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [nm8086908[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings Sir/Madam.

Kindly write back   As I am going to explain in detail why I contacted  you=
. i am a lawyer and i have a very vital information that could help both of=
 us.





Jerry McCumber
Jerry D. McCumber, P.C.: Law Firm=20
