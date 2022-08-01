Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4614B5867DC
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiHAKzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 06:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiHAKzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 06:55:00 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE942B626
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 03:54:59 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 129-20020a1c0287000000b003a2fa488efdso2537880wmc.4
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 03:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=feAaaYwuc9r3+EK54TC0dCsi1l96zBekeQafC+BJcMM=;
        b=R4Zi19G0wtDRsv89NiDNwxb4GcIUbHhL1OQbO/WEc7+1LRpPmfTFsFI6HXSQhvVcVJ
         Hpm1iX2Q5KImIHXj2ZiXeg5Kc7Ffh90D8ISYUXrrxm0UzNkE1mzCzJ1HasU718lJ/pHh
         mBg8k2Vw99jx+FnClQNRuqtcYIoun2gKFXNPq+PmxjIhxsCOfC9RFycMBDMub6VrQ1dM
         Ofx7E4c/MaQV+KqsnL/CWpJyWVltTQ2Kb7hZgYiWWoxgT3qz/oEoJi92EfFnkofpGwsv
         wLtxrkRsITblzRFM4XSElWbr+WXYvykiZvUneoqwea9qMkZ1L3/4htD0NEKog8LWZ2cz
         iFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=feAaaYwuc9r3+EK54TC0dCsi1l96zBekeQafC+BJcMM=;
        b=z2wsbb46QCaMG+WUAX3DIdLf86aqaswJVyQcN/7WtF6sEQgrVe/H6NDSj4vdccjMDl
         cMPhpe0khXWaHCdpvfttFfC0NgD9P9VsWREm+IFGGB97jBaypIs0ZHqULeQdfNF5sSM9
         uneXGLo1JkwFCGM18DeqACppYQ/hN29QTVh2bFJFA0ZYmGPo3sXOy6DzAW9sDewcZBLK
         ksqKdzts7HQCpnjGf2vwFDpoPkYLdPKyzkKmpvdKmuuY7J7ItztC9/XriT3RV9jRkoz5
         g9uhgOKJUqY5bxywoTm3bqirZOW5rUnyL/1tWiYAKtg/lgyKvyazPVCNyZhk5Gzp+1xH
         d8gQ==
X-Gm-Message-State: AJIora+KbndQcPlgO9yVIcBOwpQ2y8l7ZfWJ6CWBFecABm1h9L23bWJV
        kHKLK7BaG7UwcRfoXvunD5T0doBony1nZedbXAM=
X-Google-Smtp-Source: AGRyM1t0w1vA+ispAZyc5+FYf9Qpf9v4FkIxFjgZ9FbodE00+vTRKpptsmRbRvchlN58I2XaxFdX2Rt/dWuCBlO2tIU=
X-Received: by 2002:a05:600c:3549:b0:3a3:16af:d280 with SMTP id
 i9-20020a05600c354900b003a316afd280mr10375601wmq.142.1659351298362; Mon, 01
 Aug 2022 03:54:58 -0700 (PDT)
MIME-Version: 1.0
Sender: gb676779@gmail.com
Received: by 2002:a05:600c:1d94:0:0:0:0 with HTTP; Mon, 1 Aug 2022 03:54:57
 -0700 (PDT)
From:   "Mrs. Rabi Affason Marcus" <affasonrabi@gmail.com>
Date:   Mon, 1 Aug 2022 03:54:57 -0700
X-Google-Sender-Auth: vVT65OUKM5zP7rVduLpHc0l7774
Message-ID: <CAO9H84NZbuOcwphjchcqGT-njwOhmcs7WtVCu-7TTAnOBzs_rA@mail.gmail.com>
Subject: PLEASE CONFIRM MY PREVIOUS MAIL FOR MORE DETAILS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good morning from here this morning my dear, how are you doing today?
My name is Mrs. Rabi Affason Marcus; Please I want to confirm if you
get my previous mail concerning the Humanitarian Gesture project that
i need your assistance to execute.
