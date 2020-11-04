Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BF82A68E1
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgKDP5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730846AbgKDP5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 10:57:49 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A49CC0613D3;
        Wed,  4 Nov 2020 07:57:49 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id s25so16530761ejy.6;
        Wed, 04 Nov 2020 07:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Wi9k/g0AR8a9GK2X4xMgM0/oE19V2GWu4101n025mnA=;
        b=ZXPdWlphrkbB+tztx2nj7t3dVzhTdefbo6Vb8y3yJYCkAC1qMLpe15aEutZWOlLKVx
         04XdigkEkAwrn3MIpUL/xsWkj75kEVN3tmQMHf3Zdf61Uzri6P96jl7K2LLCX8cR0+Dm
         uLyz+UhYu3ibBY0rFVqf8Pm8EkMd2PfkrdETEE+TBZ10o+eRd6plvtrDULKWVlFdRM4n
         VBbGYCmgMiwpANBIkq6MovK0VC11x3a/g66MaJqsvQ0G2h0YxfbNgnJAWsLRyDDJ4ZoR
         wOvjqg6UkItRaGy0J2RdWXyElZUfl3n4QUIlWJKtYrIG6zjiOSAXI9Df8zyl+sVEpZmg
         zz3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Wi9k/g0AR8a9GK2X4xMgM0/oE19V2GWu4101n025mnA=;
        b=Z98zEg9Qe9iCmsfjA9zAjarIG3PSozSzIKnibG9NTJ1BrAPaTW3nClgCrkdveuZ5LQ
         1ApJDjsOPuzIZnSxYZ24FOOQsaNaAE6KkLpAr4qj5w/xIofbh2cqyMnDEQf+VmjX5NHY
         NdPqI0jvKy6jcRJd5fWDHjvdsM+rV7eoHQGNBVBAaskWGbYzVdnPWEKDOTG2iF6KTUvL
         w313wETfEUeD5Erc9lDVA8hD+52bvQAs3LR3TnZhr4vUIjU9LKoWGqgTHsaLqvDz0qjT
         2SsObBdIh6KqdRofXIwGy22h/AmhnWZnQpnL40kokBFPFgwkwzzQvVAtmSlkN1gLJ8wD
         2QSA==
X-Gm-Message-State: AOAM532zQNu+oq7IEYq2ZzJn+vxgMrCFzOenBCOyut7Lcja2xKpuEiw0
        7yAtgO/sef2XybVJmGvBEeFOYQuJWwE=
X-Google-Smtp-Source: ABdhPJwRl3ElHdz7hw+uX27Jbmoqsgb9L7hmooFPJGKyICzeJ1xAgR0lLDKhMzf2kfqbObvdpov7Kw==
X-Received: by 2002:a17:906:13d4:: with SMTP id g20mr13753186ejc.206.1604505467925;
        Wed, 04 Nov 2020 07:57:47 -0800 (PST)
Received: from development1.visionsystems.de (mail.visionsystems.de. [213.209.99.202])
        by smtp.gmail.com with ESMTPSA id f25sm1243128edr.53.2020.11.04.07.57.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 07:57:47 -0800 (PST)
From:   yegorslists@googlemail.com
To:     linux-can@vger.kernel.org
Cc:     mkl@pengutronix.de, netdev@vger.kernel.org,
        dev.kurt@vandijck-laurijssen.be,
        Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH] can: j1939: add tables for the CAN identifier and its fields
Date:   Wed,  4 Nov 2020 16:57:30 +0100
Message-Id: <20201104155730.25196-1-yegorslists@googlemail.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

Use table markup to show the structure of the CAN identifier, PGN, PDU1,
and PDU2 formats. Also add introductory sentence.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 Documentation/networking/j1939.rst | 46 +++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index 0a4b73b03b99..19d9878d7194 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -69,18 +69,56 @@ J1939 concepts
 PGN
 ---
 
+The J1939 protocol uses the 29-bit CAN identifier with the following structure:
+
+  ============  ==============  ====================
+  29 bit CAN-ID                                     
+  --------------------------------------------------
+  Bit positions within the CAN-ID                   
+  --------------------------------------------------
+  28 ... 26     25 ... 8        7 ... 0             
+  ============  ==============  ====================
+  Priority      PGN             SA (Source Address) 
+  ============  ==============  ====================
+
 The PGN (Parameter Group Number) is a number to identify a packet. The PGN
 is composed as follows:
-1 bit  : Reserved Bit
-1 bit  : Data Page
-8 bits : PF (PDU Format)
-8 bits : PS (PDU Specific)
+
+  ============  ==============  =================  =================
+  PGN
+  ------------------------------------------------------------------
+  Bit positions within the CAN-ID
+  ------------------------------------------------------------------
+  25            24              23 ... 16          15 ... 8
+  ============  ==============  =================  =================
+  R (Reserved)  DP (Data Page)  PF (PDU Format)    PS (PDU Specific)
+  ============  ==============  =================  =================
 
 In J1939-21 distinction is made between PDU1 format (where PF < 240) and PDU2
 format (where PF >= 240). Furthermore, when using the PDU2 format, the PS-field
 contains a so-called Group Extension, which is part of the PGN. When using PDU2
 format, the Group Extension is set in the PS-field.
 
+  ==============  ========================
+  PDU1 Format (specific) (peer to peer)
+  ----------------------------------------
+  Bit positions within the CAN-ID
+  ----------------------------------------
+  23 ... 16       15 ... 8
+  ==============  ========================
+  00h ... EFh     DA (Destination address)
+  ==============  ========================
+
+  ==============  ========================
+  PDU2 Format (global) (broadcast)
+  ----------------------------------------
+  Bit positions within the CAN-ID
+  ----------------------------------------
+  23 ... 16       15 ... 8
+  ==============  ========================
+  F0h ... FFh     GE (Group Extenstion)
+  ==============  ========================
+
 On the other hand, when using PDU1 format, the PS-field contains a so-called
 Destination Address, which is _not_ part of the PGN. When communicating a PGN
 from user space to kernel (or vice versa) and PDU2 format is used, the PS-field
-- 
2.17.0

