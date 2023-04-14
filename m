Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF036E1F95
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjDNJol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDNJok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:44:40 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29F21FE6
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:44:39 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id e19so1167861vsa.12
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681465479; x=1684057479;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A9qtR8MfLyUro92cvio9eras0UzllKy7Sr+yZKv+eGI=;
        b=nhby+tqpg7YJ3N4OPK8KreZkbQg6ksdB/JTX68tRFhDyAoY8mLfE8+n4fUhA1he3SH
         syCBC1bzBBLpYlc3A6zC35W3pKoXnhoZAkQFOHA/EBh8KWjR/hpHC7ViDP61qU78nVsA
         X1p10pbqhmbWwu2QEn9P5BQVleAflNQwm7V1IzntisfmnxN/M7cEMZCwJVQ9TMocTEHo
         V9MmnYyG91LKOtQl49ZnItrsYJRFZY45kRDhK9g6hVxsu0PsjFTlEPrINxJbMYMkp/gO
         2r+Cldw2TYaPuiQZ++ihVAXcfiReaeZ1SA6hYyME9IASPr7mnD1wwXGdLfp1kA9c/Llt
         V31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681465479; x=1684057479;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A9qtR8MfLyUro92cvio9eras0UzllKy7Sr+yZKv+eGI=;
        b=H1f4nzaYWZXNIci69nENg1EtwpErJda5oQjWgm4iQm2K6TqqIzigVdaS4s3JXU7Wp7
         vr0LVA8zl3slJkKsVoWOf4NJo13AM9ifW6ACUp71Ipig1IhIreYKNb/Yt5DJEwD8yCMt
         DHWmd3iU5QX37cAEy5UKT05OYrPYbY28oE+hJX+J1mLR8inR0HIii9lhxyPBpRUyAi7f
         QL4xPrgvDq1n/8HUbTDpOcIexhYYJLhnvEJe9uu1gfcqBG+kWrVam/1Rt8t/DKWS2u6H
         RLHj9korLWG18fokiGe8qvT/A+DgLALZF2aanTR69HJB7+E1VpsW1o4Zj7bcjsSvnysM
         WEPA==
X-Gm-Message-State: AAQBX9d/EbXzm2M/Ea95u49/4sLtaaUNlD3niY/O8HNs0sMsJv8Os3cp
        6EOTPrByRGFvLNazapY43XuS+iNk2NdnALcAMb0wqw==
X-Google-Smtp-Source: AKy350bKBwBmi6cLGqm9/lBs1aIURMXTFZrrJBXiy+LtGEE/iALnQZQfMf/HVW2YEzuMSo6l8V/a9yUF8SDrFi8kr64=
X-Received: by 2002:a67:cb8d:0:b0:42e:3b77:b77 with SMTP id
 h13-20020a67cb8d000000b0042e3b770b77mr1289462vsl.1.1681465478942; Fri, 14 Apr
 2023 02:44:38 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Apr 2023 15:14:27 +0530
Message-ID: <CA+G9fYu4o0-ZKSthi7kdCjz_kFazZS-rn17Z2NPz3=1Oayr9cw@mail.gmail.com>
Subject: next: allmodconfig: phy-mtk-hdmi-mt8195.c:298:6: error: variable
 'ret' is uninitialized when used here [-Werror,-Wuninitialized]
To:     open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, llvm@lists.linux.dev,
        linux-phy@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>
Cc:     Guillaume Ranquet <granquet@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, Kishon <kishon@ti.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Netdev <netdev@vger.kernel.org>, chunfeng.yun@mediatek.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following build warnings / errors noticed while building allmodconfig for arm64
with clang-16 on Linux next-20230414.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c:298:6: error: variable
'ret' is uninitialized when used here [-Werror,-Wuninitialized]
        if (ret)
            ^~~
drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c:216:12: note: initialize
the variable 'ret' to silence this warning
        int i, ret;
                  ^
                   = 0
1 error generated.


--
Linaro LKFT
https://lkft.linaro.org
