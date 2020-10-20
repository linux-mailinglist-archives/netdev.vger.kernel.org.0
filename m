Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D626929367E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 10:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733247AbgJTILy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 04:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729867AbgJTILx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 04:11:53 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404F1C061755;
        Tue, 20 Oct 2020 01:11:53 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e22so1367052ejr.4;
        Tue, 20 Oct 2020 01:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rMzDxBPvgwml3BBmCi7fGXtulhFDUu33MRcRylFojPs=;
        b=LulprIUvapX/F8b2fxPvfVBqOFT8r2tgG9lrUiguQIw2/ZFS8cjXV/wFblPP25YnMi
         OX8o5WPiIQwnwAVr+Vu65AalN0vJ36a/O1+nxpL2ejHmc3dg1BU8Uw1ScUGNDS8RdYbb
         bBYPprQ8rio4+SZAeLyyuJxdNcfRhIUQc3E4owLUI/+mPe66yZZuIPUYYHQbd69VRsvc
         DcxUc8kjH4/FJ+OqvBVPjUAsDMlaKEJN4zZH/lZyHUcwYqEKm60zzRsfK57JeLMxyHsP
         TjsysUS06thpisYF1k0A1mLssMwxCYDmjBsBqoJIeOkDrUs8qqMZiIArR3VfTvQ/o7p0
         gtMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rMzDxBPvgwml3BBmCi7fGXtulhFDUu33MRcRylFojPs=;
        b=MCfxKBWMzX3PMIg8oBubs1fPDIlazmSB9Wx/kLlVfHwUfWLH83AU3Z4QhFGyqpsg06
         FoCSipOdvaJuGeGbrz5FsSDe29tLITRXnYujesZYnrYykpFtbbR7qzNrVEjkJVLbmBOJ
         8PI2B30kqkkimkLgdn8heCKIQHnI3rUAhqLhlZu0krvEZCz26W+2cSj7ubztuYW5P7yW
         XbjLemo/v4Yf1xUGiHa1FbRzbduE2piNmk9oLvFDb+mMATw43paeDJZEc6McBs9i/LZ2
         gfCrpfkx91QcP4z9YErkJJZHkAJAv8IAtyyhLQtbA8blGWHkqbfpoZOv76wMVQ82w1x7
         8v8Q==
X-Gm-Message-State: AOAM533zTZKMBooRch9XKjnN/Yr39dVnPwpJrWe1F8TjdnGaFmiOfEU8
        XgYSezz9VW6jo/LB3CyvfCVESkZ9J88=
X-Google-Smtp-Source: ABdhPJwimtzvoGK/tTsORz4bahx38t1/H/5VYlTG/37zqpXXfX+DfOyVaH3ptc80IX7cxXCIJIpAZg==
X-Received: by 2002:a17:906:3bc7:: with SMTP id v7mr1819649ejf.245.1603181511766;
        Tue, 20 Oct 2020 01:11:51 -0700 (PDT)
Received: from development1.visionsystems.de (mail.visionsystems.de. [213.209.99.202])
        by smtp.gmail.com with ESMTPSA id g23sm1483338edp.33.2020.10.20.01.11.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Oct 2020 01:11:50 -0700 (PDT)
From:   yegorslists@googlemail.com
To:     linux-can@vger.kernel.org
Cc:     mkl@pengutronix.de, netdev@vger.kernel.org,
        Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH] can: j1939: rename jacd tool
Date:   Tue, 20 Oct 2020 10:11:34 +0200
Message-Id: <20201020081134.3597-1-yegorslists@googlemail.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

Due to naming conflicts, jacd was renamed to j1939acd.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 Documentation/networking/j1939.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index f5be243d250a..65b12abcc90a 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -376,8 +376,8 @@ only j1939.addr changed to the new SA, and must then send a valid address claim
 packet. This restarts the state machine in the kernel (and any other
 participant on the bus) for this NAME.
 
-can-utils also include the jacd tool, so it can be used as code example or as
-default Address Claiming daemon.
+can-utils also include the j1939acd tool, so it can be used as code example or
+as default Address Claiming daemon.
 
 Send Examples
 -------------
-- 
2.17.0

