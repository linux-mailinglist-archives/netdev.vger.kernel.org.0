Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DB04B440A
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbiBNIYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:24:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiBNIYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:24:47 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BC325C4A
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 00:24:40 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id x3so9955873pll.3
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 00:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=bb9cuG/AP5rW+pyL9k8cBpF94lgj6ZEmsktlJROrdUM=;
        b=igSFM7ZuyeNm1PsPLtXo7kb8zSF8psSCuHDZ1qfqwS3XZqkwec045xOQyIbN1MXs3E
         U+Kr/rEYHw6nzlCV6kIkEbN5pUBdPknUfma6MWiXaJgikhGQVD5dnzxWkZeDc1KCO1i+
         iQH3Y1nKq1Esa3qh8hwZeAKUV3xxu1I2SK8AM1+nWqEtVWgHhJrOtLSILbT1ZPGgITBE
         OMgB415M5bfeWP3yslRWzm8/Ve/dR6xQ/JwmjGVdHRrKc0SFsKeMLW6QcCBLI5TolZo8
         cJoS2zc4YbEAZ3f/sHDYgEu7sW/wvvIrS2flyrEvigxpBGT304w/Efv4A2IM5Yn2yNiq
         Q6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=bb9cuG/AP5rW+pyL9k8cBpF94lgj6ZEmsktlJROrdUM=;
        b=3XzJuBhBfHspe7tXT8uxjVgFjss+ppFOxR/9l0WyPt/sCLJ7+6vkEKltjy5KGeeFYA
         g2Icw61XUWOnJ8JtaXHircLeW9iRuhp1cNMd3ibMGhmL1woeZc4OGe9bAVUCR4DG8MkJ
         prTdqZzsVwuykHi6Gc7Rt4R4gPeZLTM1wa6L9xIQR6JS3BgxaFeLXpYXEz7QXZCmtj53
         Q4a1gK4qNP1PSqe8DXzuW0EEHWV96E5xcTC8Otb6OccO8A+zhqwP+f93/rJyfhzRcMmR
         oZ4Z28lumzcCOi/sqKOLn5D9c2MzUS/T81E5mggXfHQQrEI/S7SqiH5r2uCPTaNwHsZK
         YQYg==
X-Gm-Message-State: AOAM53002JWkjJVI9F+vi4U/wNr1gTUyFA9UiEdzQRiTILk0QlzgET48
        J1TItZw5g5wVd/mS2gqyZLQZSk1Q4qD2/XuTAVY=
X-Google-Smtp-Source: ABdhPJwbBSRHLRB9kI59EQA21vaZ6wdC7CTzOAeG9ov/xjU3tv3NX0Ef821NDzHiesPch20r+9ZDgGngfJlq1EtMxb8=
X-Received: by 2002:a17:902:c14a:: with SMTP id 10mr4304335plj.159.1644827079626;
 Mon, 14 Feb 2022 00:24:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90a:9dcb:0:0:0:0 with HTTP; Mon, 14 Feb 2022 00:24:39
 -0800 (PST)
Reply-To: mrsliaahil@gmail.com
From:   "Mrs. Lia Ahil" <sheikmohammedrouhani@gmail.com>
Date:   Mon, 14 Feb 2022 00:24:39 -0800
Message-ID: <CAHAkQ-r9LthCs_z7bOUTtQyt-7a6kJD1z2-n6jx_qzMNoxek_Q@mail.gmail.com>
Subject: =?UTF-8?B?R3LDvMOfZSE=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62b listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sheikmohammedrouhani[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gr=C3=BC=C3=9Fe!

Ich habe etwas, das ich mit dir teilen m=C3=B6chte. Bei Interesse bitte Ant=
wort.

Vielen Dank!!

Frau Lia Ahil
