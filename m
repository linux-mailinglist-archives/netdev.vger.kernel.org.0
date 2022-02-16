Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088084B82D8
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiBPIX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:23:29 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiBPIX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:23:28 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D574F21F5E5
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:23:16 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o2so2428503lfd.1
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=74J8wAf0ALd/kHQXPvDl1yBeM0Zj4VbU36uu5RGweYo=;
        b=a3lsNWiNNW1ZMb/a/o0P2LTpDmj0IkDuqcYkDTv7AXwJsWQnjmIByAV/XEMJHq0LEP
         3qilbCYB8xD6HwXOEu6J/3zdV12UxQI+8Cx0dytnF4jykyQP2C7dDgrwbqTBiDKepCUy
         rejvK2JaJc64boEl3/6wCLV/p0bBC1aTkSrZbfIpwpwEV/R+OzDS9/xgVx/5dkCQAn4U
         X78aoxTmVfm7V/X5g1yPcyOCh77DgmUMrpTUETDvXScPxzkztcf9HfZdA1E58uvJPaEE
         UwohJSE3pBb4FMsJjqzJmGzrsbXCopayqZN3YF3v2czBeY6Emf64LGhyk5mjhHAk+2le
         kKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=74J8wAf0ALd/kHQXPvDl1yBeM0Zj4VbU36uu5RGweYo=;
        b=GZgC/g0kKDM1voJImwRIyoQN2zWy8UqO+XmtcsmTIekjncIsafXDRGcSqTmOdog18/
         XFAiTj6rkm8/ozOM3N6Cp1X0uTt79RKKgRpLflH/mXV1p/bDSgRvuRa67K7co17DwLMP
         IFmxIr7J7ZPcQzeTHgRfKLekazfNj1BhIV/XwzcPIjMwnjPNbZftIVJqPvDwyUFr7AXl
         Bc8vgu2dtrbxOHloGpr/AnIscbjOEkbJKVNt7WUZAtcGlf2yVQyP+vqrP/fMfjXHpcDM
         bqDKSxvHWR3y/iCquzD9Pj1sZszAZRtjcSDUdd1Cb1GKDMcRkg1I6ryShEGbVkVDpWso
         h2ng==
X-Gm-Message-State: AOAM531riU1kwE2evPHrb+99ZIV5Lq18BZcAxu8xyLlKbqmFBdlNI38h
        T62eANrTRtIz822pjY/EIPrdpIr+GLFP+ih6mvo=
X-Google-Smtp-Source: ABdhPJybyg7hL8NDkL2p1MJJXxtZ5HdrMFxYztvnwZ7eLOYSZ2dzqp1/4/4v0yN4Kj0vtWBSj1EPbRFj1lo4k1EmFEM=
X-Received: by 2002:a05:6512:12c5:b0:443:5fe5:2d4a with SMTP id
 p5-20020a05651212c500b004435fe52d4amr1281607lfg.45.1644999795249; Wed, 16 Feb
 2022 00:23:15 -0800 (PST)
MIME-Version: 1.0
Sender: salifous747@gmail.com
Received: by 2002:a2e:a54c:0:0:0:0:0 with HTTP; Wed, 16 Feb 2022 00:23:14
 -0800 (PST)
From:   "Mrs. Lia Ahil Ahil " <mrsliaahila@gmail.com>
Date:   Wed, 16 Feb 2022 08:23:14 +0000
X-Google-Sender-Auth: D7cj8DJ_EiNbeeOoi-DxcegTXZA
Message-ID: <CAO=NqA4z+YTutFng-kQzVkUUZK53vjnOfHJ+OXH+Va032+P8Mg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

4Liq4Lin4Lix4Liq4LiU4Li1IOC4p+C4seC4meC4meC4teC5ieC4hOC4uOC4k+C5gOC4m+C5h+C4
meC4reC4ouC5iOC4suC4h+C5hOC4o+C4muC5ieC4suC4hw0K4LiE4Li44LiT4LmE4LiU4LmJ4Lij
4Lix4Lia4Lit4Li14LmA4Lih4Lil4LiX4Li14LmI4LiJ4Lix4LiZ4Liq4LmI4LiH4LiW4Li24LiH
4LiE4Li44LiT4LmA4Lih4Li34LmI4Lit4Liq4Lit4LiH4Liq4Liy4Lih4Lin4Lix4LiZ4LiB4LmI
4Lit4LiZ4Lir4Lij4Li34Lit4LmE4Lih4LmIDQrguYLguJvguKPguJTguIHguKXguLHguJrguKHg
uLLguKvguLLguInguLHguJnguYDguJ7guLfguYjguK3guILguK3guILguYnguK3guKHguLnguKXg
uYDguJ7guLTguYjguKHguYDguJXguLTguKENCg==
