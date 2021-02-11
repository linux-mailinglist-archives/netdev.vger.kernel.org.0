Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BC631888D
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhBKKsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhBKKqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:46:06 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138CBC061756
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:26 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id y9so9264173ejp.10
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F+cbGLM7dfdWvPqKxabwNSPUJ7stDmDMMES5aE2wPOQ=;
        b=Q2yaMwk+aQzCDFzJkAOYdBiIiMPUut8MXDswHc8P1OZi/9Od7nreXz41ANZ2nvZ7a7
         Us2l0uxc2Ou4z+dBwhZfTtc7Q+YALLC88/LfSIPd+R7XLDSKrodwJZOidfjeg2slTneN
         D4mBK7bYKsEwVCM1un9Bg4D50aphytcONDkgt2n5yaehER1MHGU5j3M3F3Fmpwocu/+o
         zlhiVMv619kwkBKd04TWPM+J0IBbGlbTF83aoNXX2Gzg6qp8tpPKNdPaW1M7Mv6qSFH0
         vA8Hx/fhCbZ2tcDroKLFmuDPgVjjKL1UhbBxCF1sdOUCqNuKPa7BYCB3nqbLse7xEkjk
         OAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F+cbGLM7dfdWvPqKxabwNSPUJ7stDmDMMES5aE2wPOQ=;
        b=nMar5ZECfqajpGrxmECiVPEjwZuHv3Vsd3yTSd8Fqi3PSw/iOyO9nMem4h8MYZ6FTx
         F7c4vb8FJ61nhD4Z9H8p/dIho1Hb0xgNgN0nNhedkHUiXygv3U0LDnqr8mEuXgtYFBaw
         wKeG9bH4NMSf7MfjQgmWygF81rouDTNPXrg1IwL7asrQ8aDZntKgqt5lAVBoiCSCL/qW
         Ha84ulBFQzAlrHxW1BpQs9es1nPvHmr5Aq1f8Cg3R3tNOflWWW1N7nIGMRWJI89ndX42
         /GmtE1rZCHAZoARF0/g7JzvXQHroIVgwy8pgeT0DZdMeeQ24unsV4N27WXGGA2bv6tQ5
         u4IA==
X-Gm-Message-State: AOAM5336MmNlmf40yAYUWzKyUyJlr9JkCNRFhjTrd6xW873wY38aLTNb
        kLmBHOXp6jGDc9qTHrLDheI=
X-Google-Smtp-Source: ABdhPJwpgfDsjnGnN6dNcjPtcd6mT1uxsJThP13Ysn4Vu0LG565RHk+hHJEFFGEkzfJyeLIuZqcYTg==
X-Received: by 2002:a17:906:35cf:: with SMTP id p15mr7748022ejb.20.1613040324813;
        Thu, 11 Feb 2021 02:45:24 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l1sm3815458eje.12.2021.02.11.02.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:45:24 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 0/6] Clarifications to bridge man page
Date:   Thu, 11 Feb 2021 12:44:56 +0200
Message-Id: <20210211104502.2081443-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are several explanations missing in the bridge man page which have
led people in the past to make incorrect assumptions. Try to improve the
situation a little bit.

Vladimir Oltean (6):
  man8/bridge.8: document the "permanent" flag for "bridge fdb add"
  man8/bridge.8: document that "local" is default for "bridge fdb add"
  man8/bridge.8: explain what a local FDB entry is
  man8/bridge.8: fix which one of self/master is default for "bridge
    fdb"
  man8/bridge.8: explain self vs master for "bridge fdb add"
  man8/bridge.8: be explicit that "flood" is an egress setting

 man/man8/bridge.8 | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

-- 
2.25.1

