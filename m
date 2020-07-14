Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8687421F618
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgGNPZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgGNPZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 11:25:57 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A48BC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:25:57 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id br7so8624230ejb.5
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=g+FPtPFPqFgjIcEtJQWVoFgexqrzUd9NDDi+xGm5c+Y=;
        b=M/b2D6RUyn9DloeI3FLbKC1O3BfrGcJlG3TaBAJuWQwvI1UUgEpJzByXcFf4EowmgC
         w2a31nuju8EgOOsVXEuePteBuROh454XOqgZqGmzpQUVOuRwMjYxbUzmtLet8iU3siNy
         pqHPp+/csqXZeOGRqTsvZHzNpteh2APkkQPFby8u+kGY8CpCyuypT3ay8WFnkFgh6cB8
         Xoh+LUC/r7fZBRBFy09TsGJOMr++1qT/foE6YoVitBEgqNDlAUrRXBAd0yt0+UBuB72a
         DWPX5ZyvW+Q7GAs94tM94dV3gbNiO4C9r0aG7Z3cHFN8ZrDbrJbVZN0F8/pGT9snXS/d
         KrQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=g+FPtPFPqFgjIcEtJQWVoFgexqrzUd9NDDi+xGm5c+Y=;
        b=lAn5MXUADyCvTsmbg5O5hlwPnZUeWSJ5MA1Gw87+axp6rPGg7U6mwbyy1Ynp6opKi4
         AaQw62DYjbJuXOFChD/EBTtRiClVGCwFvCxMrLnWEGt/8nnZnGC5LyWFVBzkXx5K9Mux
         wv0LtazjY9H7zpYQn4Xptg+rLNXUWSuimHw67M2Y/gPjIlv3x3GE5oYcrUHruYh/79MB
         a3SNgTd20wtY4mh7m6Y6KNbdF0azKZXKdlglrqyhXcwSKTNted7Al+sPIsfUPLs5+EZM
         ydb3iil2MdJOWi84u0VEmqsgj0KOrN4posuxz0vSdiBFP5EMbS0wEzFcfN8QLWYbOX/E
         8x2A==
X-Gm-Message-State: AOAM530s7DCv/7dIbF/bSlf69nqFRv6WC8T1/nxNbCQF+J/slZJDilvA
        VJnUgrgl496i5pzOHr+K13DxzTm4po4=
X-Google-Smtp-Source: ABdhPJx5zzcKnySq/LwMMYg9757uwblIv91ke7L4h09FPRCLkJZ7tB2Q8PGrt4RvXAs3Ae8VdLf3/w==
X-Received: by 2002:a17:906:5e0b:: with SMTP id n11mr5052526eju.15.1594740355637;
        Tue, 14 Jul 2020 08:25:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b47b:7b5:8aff:5077? (p200300ea8f235700b47b07b58aff5077.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b47b:7b5:8aff:5077])
        by smtp.googlemail.com with ESMTPSA id o15sm14824974edv.55.2020.07.14.08.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 08:25:55 -0700 (PDT)
To:     Linux Firmware <linux-firmware@kernel.org>,
        Chun-Hao Lin <hau@realtek.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] rtl_nic: update firmware for RTL8125B
Message-ID: <ec13a841-ad71-dbad-6d1c-60470610cdd5@gmail.com>
Date:   Tue, 14 Jul 2020 17:25:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek provided updated versions of RTL8125B rev.a and rev.b firmware.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 WHENCE                |   4 ++--
 rtl_nic/rtl8125b-1.fw | Bin 9952 -> 10128 bytes
 rtl_nic/rtl8125b-2.fw | Bin 3264 -> 3328 bytes
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/WHENCE b/WHENCE
index 75d3d5e..1a3324d 100644
--- a/WHENCE
+++ b/WHENCE
@@ -3066,10 +3066,10 @@ File: rtl_nic/rtl8125a-3.fw
 Version: 0.0.1
 
 File: rtl_nic/rtl8125b-1.fw
-Version: 0.0.1
+Version: 0.0.2
 
 File: rtl_nic/rtl8125b-2.fw
-Version: 0.0.1
+Version: 0.0.2
 
 Licence:
  * Copyright © 2011-2013, Realtek Semiconductor Corporation
diff --git a/rtl_nic/rtl8125b-1.fw b/rtl_nic/rtl8125b-1.fw
index 577e1bb61eb95dcea7ab91d3c20b4b6c2adbe3c1..90191ab9c9f6eb4144c68d8be711b7c601b4d637 100644
GIT binary patch
delta 256
zcmaFhJHcO<0SJmpax4suOp|mC;|=r-^o$e?%=HaT^o<Nal0Z-Z#78+97-T2vns6AJ
zTA7+y85vB>%&z~zE#JT}LAb$z2S_srGBB_(2mt8=Aol;?3<@Cj4WJqU0bw8(X}AJX
z&maz!69=jjXJFs}=@CEh1uQ4b@c%nVpD<8Pn1O*EBqw~J2`nc7;(*YB1~8vNvVf6+
s;Q>g@fq_B6fq`j33IoFg1_oAxjaOLI6kxjE{|A{UaKM2JWIF-?0Hvfct^fc4

delta 79
zcmbQ>|G-z50SJmpax4suOp|mC;|=r-^b8dY%=8US^^FWbl0Z-Z#IrdW7}O`~ns68y
aTbY_!nOIEB%-)>C$fCyKz$M=RQUw5^#t)eQ

diff --git a/rtl_nic/rtl8125b-2.fw b/rtl_nic/rtl8125b-2.fw
index 45b04434263d6d69a8e70e27ccf4843bd5f939a4..dc753b587c38b04478213e83b5d723809248ab11 100644
GIT binary patch
delta 157
zcmX>g*&wCM00c!PITnUSrb)U+@dkPZdPWKc=K6-l`bGvINgyZyVg+Uf2AzqzCLD$q
zRt82^hK3t6nVAflxaAud7zBV2j1Dw_`3wb&3=9uILJmNU4h&2SQWzK}FfgzhY|deF
W;8KC<djFq60jTPL0~g2?Q~&^+bQ#$I

delta 92
zcmZpWIv}ab00c!PITnUSrb)U+@dkPZdWH%HX8MMv`bGvINgyZyVgY6bhV+TLCLBh_
cR;FfFrj{EsnVB}vVRGOSap00~04YNT04914$p8QV

-- 
2.27.0

