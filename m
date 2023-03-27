Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACF56CA190
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbjC0KiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbjC0KiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:38:23 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FE9CD
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:38:02 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id i5so34233762eda.0
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679913480;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6H7+5iXr2gD2DO7nhfsGDWjC3fNiYdCNVD2CPrJp0vI=;
        b=eKs9dA3h1RlNVUMtZ2YxHbEqoNXSXR/EQ4CGw0meGY4Gae6hZi2wt8PWYmqy369431
         PXs/E38hwKE1C16Tthbb1AosFzQRdwoF4es6uNpE8LddPimHs+Jl4W6PCDg6ZSmb53Tc
         Kh/RhQbqtuMc6IN5bVSE9oPM97W0585R7lys5rtq23IcamZuvjQZkagEr9CN4BNYAzZm
         bnZaZyzo9cBll5TcD4L6bVbtGYg5O6Vr9z3KXLGSiGZ1y98IhaEWoIrtuKKalJpMZVNb
         k38doqKTSAS8JwXT2/eViQ2ZJcL7N1St1xvsPws8u1IpiT4QwQvihpn0iOtUGeTxJmSG
         CWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679913480;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6H7+5iXr2gD2DO7nhfsGDWjC3fNiYdCNVD2CPrJp0vI=;
        b=kOk0sTsrokwL/D7A2TFortxlSiqec1FYLNq9N4DlKGtaSOlmpcXjAo6DhmVwF7dVHq
         dJizqa8D+BBvSBrwcHbheH/Qs2iOhJj39L6dgMNh9xtfY0BK9kj0zJR5PajEvJ7+mDNk
         foOq8wxcTgHbO2T+gvJ85IoUt3Y+KcR6uozDgO6abHJsJxW/2Q5sophFu/dV5OH4L2cV
         7gJU/ev7fLUN0k8E/+G8gul319G0ozg5nipa+QeT6zCx9aMgfnt8iAXg+CH3Si1ZXuCA
         Pbina3NhHfV32pon/CxSKhaWC5czSoaYImUyfKDYgBV3VVFPQcUi09qsk4PGzVoFBtIu
         D9aw==
X-Gm-Message-State: AAQBX9dTe2JJN4UC27+C8rQyWC50hN8EelkrxfExljeQY/0gPLKQ/l7N
        PKDxonbp7aNXj0CzxgVzsJrWn1N0qG63ZDm4okdalR5u51JGrA==
X-Google-Smtp-Source: AKy350bL6ebMFlo5hGV4jIwOsbUHWCm6GVsPNExvsDk6t0DVEUtw/kpD4EfoNkC1VrAwg5nMXiSW1ZFTyKtJYIsZkis=
X-Received: by 2002:a2e:9c4b:0:b0:29e:fcb3:b37e with SMTP id
 t11-20020a2e9c4b000000b0029efcb3b37emr3165461ljj.4.1679907013269; Mon, 27 Mar
 2023 01:50:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab2:3311:0:b0:1b1:680c:f32 with HTTP; Mon, 27 Mar 2023
 01:50:12 -0700 (PDT)
From:   "facixbooka@yahoo.com" <thuytienle0307@gmail.com>
Date:   Mon, 27 Mar 2023 15:50:12 +0700
Message-ID: <CAHKhASj6CNyJAn0XR-dscV4FGsj9CRGf3Ewc5HsjoJ077zJJVA@mail.gmail.com>
Subject: 
To:     Facix Booka <facixbooka@yahoo.com>,
        netdev <netdev@vger.kernel.org>, Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        PDS_EMPTYSUBJ_URISHRT,PDS_FROM_2_EMAILS_SHRTNER,PDS_TINYSUBJ_URISHRT,
        POSSIBLE_GMAIL_PHISHER,RCVD_IN_DNSWL_NONE,SHORT_SHORTNER,SPF_HELO_NONE,
        SPF_PASS,TVD_SPACE_RATIO,T_PDS_TO_EQ_FROM_NAME autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52d listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [thuytienle0307[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [thuytienle0307[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 TVD_SPACE_RATIO No description available.
        *  0.0 T_PDS_TO_EQ_FROM_NAME From: name same as To: address
        *  0.7 POSSIBLE_GMAIL_PHISHER Apparent phishing email sent from a
        *      gmail account
        *  1.4 PDS_FROM_2_EMAILS_SHRTNER From 2 emails short email with little
        *       more than a URI shortener
        *  1.1 SHORT_SHORTNER Short body with little more than a link to a
        *      shortener
        *  1.4 PDS_EMPTYSUBJ_URISHRT Empty subject with little more than URI
        *      shortener
        *  1.4 PDS_TINYSUBJ_URISHRT Short subject with URL shortener
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

https://bit.ly/40zCoFg
