Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27049DCF5
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 07:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbfH0FGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 01:06:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33425 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbfH0FG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 01:06:29 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so11953277pgn.0
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 22:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=bk+JaA9Wm7oz2NoF52hCcBz04mg8rRkowz0Je01pv/o=;
        b=ACmTv+sLluHVTa5psjJ02RKShK7i0i9u1wgYGE7mrIr27NYnWxyVpGgxOzII3/NkyE
         dcoF0oVkDA3ndBTXpDNr8h+v5nvKj60M9IB055E6ZLm8qKCtCdTHLKRU7m/4NeGBFukc
         rHO7CjH0RFgBg4lMAavNeYOr7y5MuBhvmKspsGrtop7wf6QqmRhh03Wc39j197QoXCSU
         i3XIUBDvUp73QKxExLUVdEYRU0e6OKJyjQSbc0rRVtpLYQRIjhNxX7u3Ie5e8vh8bkmB
         BGteBb35BoV3Sd1/lVG4AnrWhtD9XuEksL6oFgBBiLn0JRaayRVtCgrnvS5UOQWJ8eI1
         hgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bk+JaA9Wm7oz2NoF52hCcBz04mg8rRkowz0Je01pv/o=;
        b=ckxOcg4FuEU3muK3BvILHWZiwxbXD3AdGTLIXBpqLvWST8leYf/JShvckP8ER8MvnY
         uiNyESCnQtW1v1WQjBRKiMlmZXPux/u/sGFMFc1aHoPnvw11AgslirZF//hvVbjR+wwp
         tw8iixk32k7r97KxWqE18svzWtwn1lqfTxX4vMrabyDrcs1ncYeBB3igoP+AJ3F031/a
         yq0zEOSrWXJiFhjtc6DOo3/hfb3z+66smq4YqeuWso5nKpsmTFG+r95iMSERAnuR3i+C
         1p8E11iJdQ90n2ED4GZlb5ErZUq7Np/C3/858GBQ0z3v2R0pWT/hNLxCRuuAcvBgQSnu
         c2KA==
X-Gm-Message-State: APjAAAXoF+VzpJb1zzk0Ji0o7Yudz3upPe2RKRaShSesvhAmyos8N5fc
        O1729cLO8QuntxbHSdk7oIi0Zw==
X-Google-Smtp-Source: APXvYqx2+mfszF4XOEdf2VyJdPl/56BfxhDiG//VfH7sfIzgWmV7i6pR1y1dd5w9xBmLxpAPPz0suA==
X-Received: by 2002:aa7:9e4f:: with SMTP id z15mr23349159pfq.89.1566882389075;
        Mon, 26 Aug 2019 22:06:29 -0700 (PDT)
Received: from buildserver-90.open-silicon.com ([114.143.65.226])
        by smtp.googlemail.com with ESMTPSA id q8sm896414pjq.20.2019.08.26.22.06.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 26 Aug 2019 22:06:28 -0700 (PDT)
From:   Yash Shah <yash.shah@sifive.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        paul.walmsley@sifive.com, ynezz@true.cz, sachin.ghadi@sifive.com,
        Yash Shah <yash.shah@sifive.com>
Subject: [PATCH v2 0/2] Update ethernet compatible string for SiFive FU540
Date:   Tue, 27 Aug 2019 10:36:02 +0530
Message-Id: <1566882364-23891-1-git-send-email-yash.shah@sifive.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series renames the compatible property to a more appropriate
string. The patchset is based on Linux-5.3-rc6 and tested on SiFive
Unleashed board

Change history:
Since v1:
- Dropped PATCH3 because it's already merged
- Change the reference url in the patch descriptions to point to a
  'lore.kernel.org' link instead of 'lkml.org'

Yash Shah (2):
  macb: bindings doc: update sifive fu540-c000 binding
  macb: Update compatibility string for SiFive FU540-C000

 Documentation/devicetree/bindings/net/macb.txt | 4 ++--
 drivers/net/ethernet/cadence/macb_main.c       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
1.9.1

