Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68458FE4EF
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 19:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfKOSZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 13:25:56 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43239 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfKOSZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 13:25:56 -0500
Received: by mail-wr1-f66.google.com with SMTP id n1so11973782wra.10
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 10:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BIA4aN4Q3bDz2kLklUWg3zmxYw0SCHtJ8I5xbCX9Zgo=;
        b=YwJAE3AKw9TK2E3tME7OP3R1rJ5/jce82KmHbbY4j3we1cPPYo5KbEVA5i6g6IJLfV
         es6kHJXmYprG5CZITz6//kL8z7Iw1hWiO21YkQqpy96k/fkjsSoEsSuySvbzC17Xjmpq
         Y/VhLsd2Jhy4rhvZq55JvUIfZgYNPOWlRHQEfmn4r7bMbqzI6QBwOil3dQS46brhb+fP
         qU/fcefV91man+LhuQ7UZZ/FlO4crXutMiF5JVeB4fvkcTMluUUT2ZfGf0VayuyLAfMb
         FGhCZTZjBBF+y+gcgiJzr/rEq+fDfLN8c5+RdQE06bQzKYvtD5wK+tGp9maJ2g6lIRYR
         BI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BIA4aN4Q3bDz2kLklUWg3zmxYw0SCHtJ8I5xbCX9Zgo=;
        b=STkVREXzuw866cct8hwy5p0IBH0BVgGKMVyBfYrZ19eZYWaQnvYmPOsFGJEFy99BoE
         5TmdvZe6yrjG5DXYurQscMbeXEZuj9oe5HK+HjYug80lCEd5rkewNL7dq7B6QFobCJ+d
         uVhbWobrlapfesDP7j5/cpFLH/CNO6y68IHCWuH0jFZQbbgUfosrmVPajK7yvbH04T+G
         O2NoJAlbHU9vbje5E8Ff7I7oUU+SVeEkBzq/eBQY8SU8RaZ8pGgvhsEvObIW6sl9LRIm
         9siY4FQMAYR7FtCJ1VgSCznvVuForVKC1ZvJVgmCDBGsU6pgOLasfUDzTmTPRbyD2k9s
         JEOw==
X-Gm-Message-State: APjAAAWr2n6uUx0hYdQDyiO5xJ74yVTUPxb5/HFbLx2NgGfITiH4MUQz
        dh0e1Uzx2rT3ONsDY1C3ZGxuO+LV
X-Google-Smtp-Source: APXvYqyWwQAwqGD6M7USrV9ncR9TFYZxN5zkFoSkLYBAQaZwnoCVdgxYzugCU+1pjr26HcfrJDfkhA==
X-Received: by 2002:a05:6000:18e:: with SMTP id p14mr16803005wrx.98.1573842354131;
        Fri, 15 Nov 2019 10:25:54 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:6008:5d87:fb8d:7600? (p200300EA8F2D7D0060085D87FB8D7600.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:6008:5d87:fb8d:7600])
        by smtp.googlemail.com with ESMTPSA id w17sm12989013wrt.45.2019.11.15.10.25.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 10:25:53 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] rtl_nic: add firmware rtl8168fp-3
To:     linux-firmware@kernel.org, Chun-Hao Lin <hau@realtek.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <3de90521-8324-087f-f3d1-f616fda021b4@gmail.com>
Date:   Fri, 15 Nov 2019 19:25:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds firmware rtl8168fp-3 for Realtek's RTL8168fp/RTL8117.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
Firmware file was provided by Realtek and they asked me to submit it.
Hau, could you please add your Signed-off-by?
The related extension to r8169 driver will be submitted in the next days.
---
 WHENCE                 |   3 +++
 rtl_nic/rtl8168fp-3.fw | Bin 0 -> 336 bytes
 2 files changed, 3 insertions(+)
 create mode 100644 rtl_nic/rtl8168fp-3.fw

diff --git a/WHENCE b/WHENCE
index 717c8c9..81ee965 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2957,6 +2957,9 @@ Version: 0.0.2
 File: rtl_nic/rtl8168h-2.fw
 Version: 0.0.2
 
+File: rtl_nic/rtl8168fp-3.fw
+Version: 0.0.1
+
 File: rtl_nic/rtl8107e-1.fw
 Version: 0.0.2
 
diff --git a/rtl_nic/rtl8168fp-3.fw b/rtl_nic/rtl8168fp-3.fw
new file mode 100644
index 0000000000000000000000000000000000000000..cc703844615bdde7a03e7238d827b0bb949bf3ca
GIT binary patch
literal 336
zcmW-c!AiqW5JktTAta%d5<*Ff1}P#%)AwQxX%z`7Mf{1VwW1(eN^mLn2mA|{uH3m1
zb>Vlsg)99B@!Em&INUeGFd`z;@;cLLb}`x9Dpagu9ckUwX;=68$vPoBq?E~NIl3%H
zx98*HZah6G5~cg9mt^tT)lH<5fl3EzTOJ<U?3Ts<XHF#lsI5SxL2Tj>k5tJLsS}?B
zm=`f37QlYn2pm&E%`Ct-76N0VVH||UL(5cA`Q+?t9nT#fZ_NNd!v=nvAu8`J$jdT9
zH)6iZyp8+j8uNAL9eleRoQ*lFxHF;m=qWv;59qt}J$g>xrytUX^dtH)X1Bn?Q^$ty
OI{0!uShL$C7uFv|s8|62

literal 0
HcmV?d00001

-- 
2.24.0

