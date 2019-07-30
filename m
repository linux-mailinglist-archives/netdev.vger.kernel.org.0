Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE8A7A597
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732391AbfG3KGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:06:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51921 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728590AbfG3KGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:06:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so56566092wma.1;
        Tue, 30 Jul 2019 03:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wS23UgUWtMqTEm4ppjXxe346NE9v8nvUKbESMI16TNk=;
        b=nSQ0xvaP0FGfQnjKGz88xBBJXa3H5RzuCLzxPN7AUzaB5lYzmRIxell19V2NdTSXhl
         HMvazpwfufPYpatU3SUY/K7nE8THXWda4qYb29lsQjJevxtc+iQkK8gHaMnXoCKXMeHf
         KZzzAGCApsCPLJAinrNJUaS3X2+6WtpVPcrtJHOIyqGPWenNUyIXrOiusjV6bn5hs+nM
         eCUQ7Hj7kwPbw7Zd9TaLb5v0UfuJxRsgpCI0y2tpAw+gZaKQJYqr8y++SDckntYsLVWI
         /wC3lwU/foO2qSgA/Pn6JJa44v9VwcA5/Pjd09KmZpSmaOQW7pdc/HmkUSyKNpCzvcln
         1bOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wS23UgUWtMqTEm4ppjXxe346NE9v8nvUKbESMI16TNk=;
        b=p9bcdsMcnU7gIZc0dHpXkFzPWn4QQ4c0rsYNZv2D+mAuxzx1ygFGSJJIHTVqlRBdh8
         u9sjVD1fphf/NIcuHFSYPI6OXl6rzDbURpuhUU/jpOxB7pTARQ+MHTllPHojzkzQHnIU
         kLvftUtyU/p2t01RjLwHlEKuMjTBJQ9BHhpRHsXlUvty1uB1egOqCHST+YtH+q3DnlIX
         +G6i0Yx5ar0x4i6FOPzDIIZJVjMiBH0Dq546lzgY3NJE85Y0tF7VHqrSi1PBWrg62FYp
         twA8AuHxkE09vrCHS/zy6MHwrTy9xrtS6J7qP8ga5QF4lwc6xrDaf6hIWFIUdb4lbNAn
         34FQ==
X-Gm-Message-State: APjAAAX9S1pTZ3jtzMwQpMVnfURicnsfd65TBIbBPyGSP6vN3VAtyNxM
        KavS7r2QkOp/DYSSNvZGWw2/PgxivkE=
X-Google-Smtp-Source: APXvYqxbOTJYXHoAh0h6T17RYGUC3JRYokkh1Lp8qo3vAfFEPnEq9NOncTdCoECxeFcuztQ8MWbupw==
X-Received: by 2002:a1c:2d58:: with SMTP id t85mr96828939wmt.61.1564481160088;
        Tue, 30 Jul 2019 03:06:00 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id n9sm108236322wrp.54.2019.07.30.03.05.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 03:05:59 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH 2/4] dt-bindings: net: dsa: marvell: add 6220 model to the 6250 family
Date:   Tue, 30 Jul 2019 12:04:27 +0200
Message-Id: <20190730100429.32479-3-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190730100429.32479-1-h.feurstein@gmail.com>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MV88E6220 is part of the MV88E6250 family.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/marvell.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Documentation/devicetree/bindings/net/dsa/marvell.txt
index 6f9538974bb9..30c11fea491b 100644
--- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
+++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
@@ -22,7 +22,7 @@ which is at a different MDIO base address in different switch families.
 - "marvell,mv88e6190"	: Switch has base address 0x00. Use with models:
 			  6190, 6190X, 6191, 6290, 6390, 6390X
 - "marvell,mv88e6250"	: Switch has base address 0x08 or 0x18. Use with model:
-			  6250
+			  6220, 6250
 
 Required properties:
 - compatible		: Should be one of "marvell,mv88e6085",
-- 
2.22.0

