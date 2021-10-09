Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C83427D7B
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 23:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhJIVFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 17:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhJIVFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 17:05:49 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5FCC061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 14:03:51 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e3so7795475wrc.11
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 14:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LAOJ1AHRRDLL6eWsA55YUP3f8oGWJZG8+6FBDsGizCM=;
        b=YNPLzvje/y5/DaKdnlX+fiIqU3kJ3mDVTkb9UADsDzWNAxy+8ChrjXLEO2hDBIhZsK
         tLAKNIDV1wHJejJAXBivcRsyB2HoUGUcrKRuNk6ir6rhTU0e++UQ4wXM/ZJ6TojZG1uo
         Uh1Jb2/iZG/EffoLPtldtdZjBHCbePnfqyi3Fhib5K6B6aTR9Vl4xbAch1b9lTwXf7XL
         hNLoX8BBWVv9iWpjxvirvSD/Lc1o9a0a6Coyif/FGcvei+kUy4w9WK+UrBqBUYMCBkg4
         We9HeeXDXQdZg80A8YRbGaxlMXtEAQsWOLxcc7mOG2ltIptOmxgm3V/9Ct0SPJx+FO7A
         q0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LAOJ1AHRRDLL6eWsA55YUP3f8oGWJZG8+6FBDsGizCM=;
        b=OO9SHfVE56Vf2S6wYeyC82cqiQebOwGaDKUKADWJXL321se6pTmbe/vnj7pRx8LOSv
         4IfrXgw4SH0AI+okY3kcai6CNuRsB9pVEGAFcnclqsvx2TH3WJl6U9bTzOn20EI05dXN
         MqomRusSfxmBpIgxLgXWoWZvw1V6dgBR6n2AFXdjFefr/rIgO8kW6YOwePubOq6fHiez
         ym8L6xxD/QFq1DrYItd37bovy0fBpe2G2svmkaWzKqJ1RYciaHsOBSqj13mJNRw3opx2
         noAY6GCAIDPxrp8eoW9v3RCQF2NHxsNGfqagp2PxVVky3GbOlGejG6tFiEnlmegpf5WJ
         mfKA==
X-Gm-Message-State: AOAM532sMcQoC6t6mWrv00Rb83lzRD3Sdp4va/Hp8RpfplZJoeaqaX53
        OExp1M8XBtvhC0kxojPp5263rA==
X-Google-Smtp-Source: ABdhPJziGg4/yjS+Gb+WWI3Mrd9lsuMMYjhiNuDBNhgOFxZsyCTH2bXS4/3WesCSAGD0d38grEzaZg==
X-Received: by 2002:a7b:cb8c:: with SMTP id m12mr11456342wmi.77.1633813430437;
        Sat, 09 Oct 2021 14:03:50 -0700 (PDT)
Received: from localhost.localdomain ([149.86.83.130])
        by smtp.gmail.com with ESMTPSA id k128sm3102516wme.41.2021.10.09.14.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 14:03:50 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/3] fixes for bpftool's Makefile
Date:   Sat,  9 Oct 2021 22:03:38 +0100
Message-Id: <20211009210341.6291-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set contains one fix for bpftool's Makefile, to make sure that the
headers internal to libbpf are installed properly even if we add more
headers to the relevant Makefile variable in the future (although we'd like
to avoid that if possible).

The other patches aim at cleaning up the output from the Makefile, in
particular when running the command "make" another time after bpftool is
built.

Quentin Monnet (3):
  bpftool: fix install for libbpf's internal header(s)
  bpftool: do not FORCE-build libbpf
  bpftool: turn check on zlib from a phony target into a conditional
    error

 tools/bpf/bpftool/Makefile | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

-- 
2.30.2

