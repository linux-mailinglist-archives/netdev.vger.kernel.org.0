Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDFE614FC31
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 08:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgBBHm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 02:42:28 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35379 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgBBHmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 02:42:04 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so6032250pgk.2
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 23:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=nOAb51GusVV7f0n1CnNZocn9+Kq0lKT1naArWyqmC5U=;
        b=TNlL+cdvlFRraqL2Xig1l0AnFrdhy9snSq7btVJz2fRHc0HFmuKIKcKNqXwcvbiIaI
         6tpmpZzmJugQ1F5uquQoezPzHvW+Iev8o++r8q1ja1n+f9trYU19VxntXC9O0nuWW1XS
         UWeu0/qT3oWsE6TJ6kiM2d/IinIb6hsv6+2cg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nOAb51GusVV7f0n1CnNZocn9+Kq0lKT1naArWyqmC5U=;
        b=mCkwCVfelrqTJ5BDxgUATRVj4h38AKD9o1GqKRgXf85SdLSTL+U5KvCvdCTXbX+GwT
         PN7F7iM1I0TWd1VcSEqs4inwhMLRpqsx/RuQHUUHRWUFbxpaUAUOpcC51VJh31MAQRVJ
         lyaX2YnqyXoqPEcVEBhOj6jROSReLBB3kvW2wdKOO28ygLE1Lj21KmClgyQ/NTLbiXA7
         odBX53qysrNwXWDqlG3Nk++BmpykjCqDb/0X6tJCzxztso6vk7QdxZgZcwIng0IXi/vh
         8GVuHDSPqtBaE/qdv+c9WmELgVJuTIZcLr0TsdLOJRVj7nTu+WDl+lgwkX8RHIL1PEPk
         qzVg==
X-Gm-Message-State: APjAAAWJx/DSx5hxTjjg8W8oM7AXfjR3s4F7OrpWr11G/M+pRiG4jOVX
        vFOqKrABbWIpJmCOT+hFjZnihQ==
X-Google-Smtp-Source: APXvYqz7bmZ2jnXy8CFjMocLzCcz/ck0zHa3PVY7PY2dButhUhcBgfZuU2htXznPnZZHUeHFk3jBmw==
X-Received: by 2002:a63:f62:: with SMTP id 34mr19762441pgp.184.1580629320296;
        Sat, 01 Feb 2020 23:42:00 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y21sm16223162pfm.136.2020.02.01.23.41.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Feb 2020 23:41:59 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/4] bnxt_en: Bug fixes.
Date:   Sun,  2 Feb 2020 02:41:34 -0500
Message-Id: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

3 patches that fix some issues in the firmware reset logic, starting
with a small patch to refactor the code that re-enables SRIOV.  The
last patch fixes a TC queue mapping issue.

Michael Chan (3):
  bnxt_en: Refactor logic to re-enable SRIOV after firmware reset
    detected.
  bnxt_en: Fix RDMA driver failure with SRIOV after firmware reset.
  bnxt_en: Fix TC queue mapping.

Vasundhara Volam (1):
  bnxt_en: Fix logic that disables Bus Master during firmware reset.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 37 ++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 13 deletions(-)

-- 
2.5.1

