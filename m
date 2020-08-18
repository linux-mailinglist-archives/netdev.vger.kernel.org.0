Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED29D248CFA
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 19:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgHRRcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 13:32:04 -0400
Received: from mout.gmx.net ([212.227.15.19]:45577 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbgHRRcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 13:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1597771879;
        bh=MuzodkzXFlQqlZOXkPhy7wbYV96XJcj5ljN9UAV22AI=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=bxDdpiJjndCI3UC/MOlheD0Zwd+8I4WIrgbVUKPLJJ4473ryoUygMcTywR689lVo4
         L5gt8X0boORhnxRKqo+3lqwW0o0CulaGX8SGQ5BVTQ+3XwrxrRo2ZPttzj7lx3WxPR
         +4czsL3mIigaP5AjunMDCX5IMHl/iY7MJY7tjJY4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([185.53.43.192]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MWAOW-1kAvuv1BcY-00XdDL; Tue, 18
 Aug 2020 19:31:19 +0200
Date:   Tue, 18 Aug 2020 19:31:01 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <a56f3029b913d31fbd27562b98d485e981815165.1597729692.git.landen.chao@mediatek.com>
References: <cover.1597729692.git.landen.chao@mediatek.com> <a56f3029b913d31fbd27562b98d485e981815165.1597729692.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next v2 3/7] net: dsa: mt7530: Extend device data ready for adding a new hardware
Reply-to: frank-w@public-files.de
To:     linux-mediatek@lists.infradead.org,
        Landen Chao <landen.chao@mediatek.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        matthias.bgg@gmail.com, robh+dt@kernel.org, mark.rutland@arm.com
CC:     devicetree@vger.kernel.org, dqfext@gmail.com,
        netdev@vger.kernel.org, sean.wang@mediatek.com,
        linux-kernel@vger.kernel.org, opensource@vdorst.com,
        davem@davemloft.net
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <883BB20A-48CD-4B73-9D2F-E5CC21DD2B70@public-files.de>
X-Provags-ID: V03:K1:RHA4uIrsqvBmFN2vJOdO4H+IjP89S5tlylzz2vL0VK7JvBRx6Zg
 D2a9/54EsigXuEOoaa6ykZRzsCqJxH8BVSzQlxQMcnlf1RdYxa8ovqah6R/3d2kzFK3PMky
 x/cq2s51kaoZ9F3ESokT3WIp815pypysw1/mAQehDEoopEiDUrN5JKceIjW34ySZTbyuEpz
 YTWXV/lC4Hk4rOBll4UJg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ysoVgdAP2ws=:7hZ0WFuTmv9t+qc2gunHBb
 ezfwPSqdtyYobAeEzguiyOaA1byPYhC+x84rFOOSNNlvHFl7+2QLMACbva9t0k/h7yfJ2vjjH
 aD8i25Mq1UGLE7iq1xh9qE59E0st8smtiazLD1OMv01D9dgILIZo5NDXucckz9Cti5yVOYY+u
 1dLjMzb5V3CXiujgUabv7fOzEDoBdnUc7mqR4x8ynAIVIXqhiWGMfB0jhE1zAGDqGsNAN/PkI
 Vs0yW28amGgEw2lIOUS/jPsqSnhI+dclbx2ckHuuVuAqamz+PoOqD+yRVOIH6pAa/9nx1XlCz
 pgoNaXu0kHuHSAzJRRDqT/KFPjieicTqE2ejiGHjI7YDlifPVzOFT3ctpSIku5+jf0/tpfreP
 Jyz/9F4yUAMr0frYAbCwwncV9gS7Q5ucivdFLZZPw0MO+y4c5iWpw946WPJGFNa6Oa/BVILqf
 VQMtGQtqqI9AuypK79mZbw1pjBN5y7l/fGWcKrrLGKV8iUCbaNXhq1PICjTQTAYaE4pRq79v6
 bLuUHLu8IOQY1SJDpQrEPF3FflBOzDZMVO6Ppt2KStzbc59jGzlXrgBn9sO+v3LkvvJ/lHdgf
 QF/ej9nebquSZUgMlkVRd1jMr+RlrCrt+g/n24NlJ5d2g1ZkUvNMMI65ZdvuTYmEgS0sDuwCl
 Bd8Z+zxMiBpCGKsdsaYrx524SQRfOLWABi2YuYT9pOHLkNbgcMX4DgdykiUz46twAY/RIg0Lj
 zZMyaC3Hmdk9VyEQXuO1r+m6uJOqNx7fZW69PmyWeZNHfzsd2t5If54PdCGVVjoHwHkoM6+1U
 ANNmoW9MypPAv+8yUWDRcL/4DsuDfRw4C/LPgejZDrdryUmkOG+GzOp1LbLsTZ/64K+/w2F05
 9t4Lik0bL/rnBSpb6JUwtmB3tLvNsI/bfoTiw7qFVX5mFk5CY7ROnlOdKx7ksW+xNFkIoX3k2
 eicVjkRMMvePORhNvVCGIoFWrgYReIB5th+1TktetOteZdmJ3WDFednsZ+01nF4fLg7v7Pxl8
 j1LuJmsI6ZmdqJwugPfeUJpVyaNQXjZ+9My2maESx8HMA6cUuG6dQJ8ous7Eg2yxkZaBfVEYR
 mXGOZ7hnhVAU/Qn6Q77IGX4Tg4BcCasVZBMFHLjUpQRLYP3/ByeZGlvUPKPM55Dep4498NMvW
 IT6oWBUqARVoutnViYuNBshvYsMIfbF4H0mv+P5QmLzyVoA2UKQ5mzzUPyxlFIWrbvmxB6xmT
 0EXqjOGY9m4/e8AFST81v0bkWcwfnEPm+sIUh/A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just a little typo you've inherited from existing code

>+/* Setup TX circuit incluing relevant PAD and driving */

including

regards Frank
