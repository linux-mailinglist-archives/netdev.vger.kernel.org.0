Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C895D586B1C
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 14:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbiHAMp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 08:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbiHAMo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 08:44:58 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E481D46D87
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 05:31:16 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-10dc1b16c12so13463510fac.6
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 05:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=kCSqCOP5NnmgqzMKAvoC+xj8lkHVueu0SPSEqGKA1Ew=;
        b=folgGPHn4OFgcYL3UdFoTpOPBPSeJ8R3UWXvarACazFhm4pCk0vIdc22ruAdaLClMr
         RnWk2O0C77ZR2MtKCPUbXiRiCi3T751VtzSCcjQYTj3XHZc8O0ik3lwRWP66IGrQianx
         39P5UkGh0o8gjty1twNtYWScQ1sTmrycVDthnUrmUbhRyuTgqrSXDa3hC0mslF5mgFTn
         rPT6jB308uPgcqirk4Ufj5SUKIapWrVUeS9ZP+dza6eNwMLpqSqmAjp5p5yXeosLeJXM
         l/SJ+KN9jlfgYPEjyHzusf/TosZNv87QYAT1wKdlV0vQAEAvTvEL3L/tYMmAJdyq62ir
         j23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=kCSqCOP5NnmgqzMKAvoC+xj8lkHVueu0SPSEqGKA1Ew=;
        b=8H3O0zBfTDIfLO/ktDrETI9egvB0KCzuzGluXH+dD7diHan5EVGMwlx32ox0xBPOBX
         uwQ1pOMprI4uxlYVwYRelTx7QMlTjszArNSnurHWuFngonM6hRz9RTJtMyLe70czM7qe
         ahojbuzEe9xGyFQeiWzN/Mdu5SvljroPHhRn3rUh6CQ775R38C6MePSoMuMB/07Yu7te
         s3AfrTpjjsC/rmPKBzJXj8s+sEaSBIa/ggF++3w24jq9tAk3YdPx/AreKGFSlBoDqH55
         l8NfaWi95O+dKOtgpAD3aOwEF2lPaJLG9Lqp1lV6MomiguA6a510Acy08V6/JEHrPNC4
         UTow==
X-Gm-Message-State: AJIora8s8OtILniB42xTinZLZPBvl/ucVswqtcjozkPV6KBw5FiczYKQ
        zyQuHFXVX8EJyLv5rcVR/WX/veiO76GE8f0PJx8=
X-Google-Smtp-Source: AGRyM1ubrIShX2y55Oau25xPPQ42xyNuKMXf/jFBA7uci7JLdrp1B3Q+7pvvohxPZA5E+3KwTdYftscnWvvyDcPCGJs=
X-Received: by 2002:a05:6870:51cf:b0:100:eb6f:42a3 with SMTP id
 b15-20020a05687051cf00b00100eb6f42a3mr6766070oaj.208.1659357076229; Mon, 01
 Aug 2022 05:31:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6850:e61c:b0:314:dc02:5b77 with HTTP; Mon, 1 Aug 2022
 05:31:15 -0700 (PDT)
Reply-To: lisarobinsongift02@gmail.com
From:   Lisa Robinson <masesedinah132@gmail.com>
Date:   Mon, 1 Aug 2022 15:31:15 +0300
Message-ID: <CAPaG1UQ4eaVW-gtMEwQn5NgBd8muPf=+bpoejNm9OdS5hVz99w@mail.gmail.com>
Subject: Donation
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:30 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lisarobinsongift02[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [masesedinah132[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [masesedinah132[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
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
You were chosen by God to receive my Grant Donation of 1.200.000,00 =E2=82=
=AC
Please contact: Mrs Lisa Robinson via email:
lisarobinsongift02@gmail.com
Surname:
Country:
WhatsApp phone number:
