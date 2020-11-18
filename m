Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3C62B8258
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgKRQvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:51:54 -0500
Received: from mout.gmx.net ([212.227.15.15]:56325 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbgKRQvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 11:51:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1605718303;
        bh=gWwwCwfISDjmpy8OSIHFij5Di1bQqJTgV20bl7nQn58=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=BF2ZGNovrL5ODt20K7zGFp8JXPFL36xCmuabld4IfTUx8KvXls7pmOO3QMNiK0gBs
         TRjjxBIIbyKsKNIY5IB57boFaVWARpk6nkWO4ueRtgWV29KAPB45eHDPXxkGlFy05H
         RBKrty5EmFTjd3IkNcIRO1ksSVMgWD4hj3n/UX8g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from MX-Linux-Intel.fritz.box ([79.242.191.181]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1N2mFi-1kGFQg3jQ4-01358A; Wed, 18 Nov 2020 17:51:43 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        joe@perches.com
Subject: [PATCH net-next v2 0/2] lib8390: Remove custom padding solution
Date:   Wed, 18 Nov 2020 17:51:05 +0100
Message-Id: <20201118165107.12419-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uwI0J+/nhAAMEUXl5VdMZL+3JZb2Zbg8u51scFzEcuO8afOTv37
 +sHsqkaRGPDFS16xu6YsI/LXnC0TBKSuzPYItuSPcL3/3wnGolSdVniYoQWkk86eIhhF812
 hVCXJIMzyhmqTTTGSc1Z+aeS5fSOjtqViSOdE/LJq+xaTeNcZa/iR7HZcQBtYosbYJPhwVL
 iTPhNwjqiKUGvsK3mezwQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7n4KS9aTaXY=:cxeMQJKP7DmYTkM7at0S/j
 a6N4HwYXvx/UwN6VCGDFCffaiRJtX+0KGsQDxfz7AYrIgfw6TlqADp3BaabQr7EExwq9O6HFj
 39UIQbBvIOBEludBEXYnMthlwuuG0Jg6dnn/vFjz7sByupm2z5eGLLnu+u5oaw6W1zTyJM7M4
 iH+g1GfLA2tMV3NLGCUvMwwE3tHbaoSG1vIBFCZYYHptxHNRrAqrKmgwtnPQzRHR8pb6YDdIM
 YOfIzEUq9XbaQkx3cQob/S4t+5Mu3vYGF604NK4ir5WwuzFizPlcMkkZTt+o2Cc4lcjg/f5Nj
 TC4MzEX2YYSkKAJ9m7OdbIP1h0rLv8imX0/V1d/44XvJSAQIAGOFMzEjqnZVcFZ4l0ciEENCo
 nKBWfWooptOjPQt3CuV0CAn9tYcSEHUKwsxgyT/GqVe4zdHxOEn0ddyLd+pgJNcjkd3aud4gv
 WJrJuqyeUxVJ4CKjEIlUmNTf3lAAGvEL5ahh3q6a9hGM5fNfJlcwR03aRMPSo6Dc87btmhPvu
 ZSiE+9eaeimv044np0KWI9VmK7t72FH5TGZqF56vg2e1qv4dCvDQwp0xY+FO1hcFpYfpD+ZVD
 zW1vwi2zHCIHNRR481PPhO4iW6zqjYD+65In31YDN8nn2yybeUi0FfFYs4UzSnTvUcGGX58Uy
 oyedBDg+wyuin2isZM/PP4gaHOhPyRe7E6LAWqDT0uKRDVVwFyEcn+7INR5hdzpWNIB0JjLh/
 J0JYB1P5HRxcalAW9RWhUYlR8x1TceRCViTy8UOt/dcKlG4op9wkERWhg2T+eWKBDlu5sTDY/
 MVW/r/aiZoHBxDzIbaw60g2dP5tX13vlcgonlxBfp6eysNuWd81gv4A2dhi1u06Tp7Uij24pk
 HFzVvd1w3YHsKvhpxWAw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When padding undersized frames, lib8390.c utilizes a stack scratch area
plus memset/memcpy. In doing so, it is overwriting content already
zeroed with memset, which seems not optimal even when commented as
being more efficient. Using eth_skb_pad() allows us to remove
memset/memcpy and the stack scratch area altogether.

v2 changes:
- split cleanup of variables in seperate patch
- revise commit description


Armin Wolf (2):
  lib8390: Use eth_skb_pad()
  lib8390: Cleanup variables

 drivers/net/ethernet/8390/lib8390.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

=2D-
2.20.1

