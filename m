Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210B9362E5A
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 09:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhDQHfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 03:35:37 -0400
Received: from mout.gmx.net ([212.227.15.18]:45693 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhDQHfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 03:35:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1618644887;
        bh=OI81KtQ7j9ZqOlCJIcKa2iYLGL2tt4lo0Rtf0X7jM+k=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=LeCA8o5efAXEaNF2Vux7HFQ8kIKQLkRUhk1cDEuy3OcYf9/wO61mnlxzx33VwonYp
         TmnCYvhohJLcdURI2TUz30cT0i7gbvWedKQP2pgcaNxyTwez6y5c7A9XGi7ouPyzTw
         RXprFogv/2ZJrj2h8ExsrABB9ArA+siYo0EC6nRI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([157.180.227.36]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mj8qd-1m3iMt3B6D-00fD3E; Sat, 17
 Apr 2021 09:34:46 +0200
Date:   Sat, 17 Apr 2021 09:34:42 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20210417072905.207032-1-dqfext@gmail.com>
References: <20210417072905.207032-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 net-next] net: ethernet: mediatek: fix a typo bug in flow offloading
Reply-to: frank-w@public-files.de
To:     linux-mediatek@lists.infradead.org,
        DENG Qingfang <dqfext@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
CC:     Alex Ryabchenko <d3adme4t@gmail.com>
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <E7AA60BD-142A-4F25-9AFC-D04D48EE4B8E@public-files.de>
X-Provags-ID: V03:K1:lTz2oUqIu4Qo6X9sbM/jutgdTIMvIjsB0d1Nw33+FomVf3pXwCM
 8LKGa+NNLIDLzU48VdCuJ7WT6llXV6NfmyTuQvkpS78rJ1rP87yD/x+LChVj6tSMukOnJVx
 gFOGtUtvtnSpBg7kPLSGxHvH8HZoOIg/kQAPb/YHx1FAFVZCZraYhhmZ5EQ5nlOSP48aEr2
 OCkgC5e5r09z7/18ngesg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7ZOMkC4rb38=:Y2ee+mpVr5Ckri1MqDZjcl
 5CKch+KexfoddAcbKjziuD2FGNoL3dGqFrOyNUnxi6iNapBgJrBSgV2TF8uT98lPqhArpec3g
 /YjSfafyagdmaYoeOfF8ufct+2Efbu+yxkPROyumacsKnEoAopWVLDG5xWdppWB6SBJjpqK22
 WoasQ7FOFOs7/3SiNFCtyD8LjTp1bGgi0S9U1XOSN1WYLsI29pg+92s56dUUJN+XCY2sSaG+b
 0brATTMWoaRTMSMhVgn3WuAojyHoWiRYbIv++zYpVQ10nWKxPFbT2zrGvboHpwDO4gXIEuaCV
 I7K+RxRSOKkVXnvucN3BHkRfeFO7ZP2OiaSMbr9NWmGlWoEknIjbnIGbsiYkS6WOmntlCraX/
 pz1GqRWSdV3s28ScRLQ7cAY47COv4cZxICvYmM+wZ3om7ejHYfOnxEP3nj9L2XdDRjch4V4tN
 Tus+jZDUzIwpw0EZuriFiVIEQJGVhZaRA6sHtUuFLoyTTsBZD6zdfZ6FQB9NY/aZTqNSGCx2O
 yb3Gi5E8RP8BdbpPCvSXkZF+IW8O30Ajhidna8Xbf+HRe+q4bAUzTmvRboIjqWNzlc7t+u33E
 fHyHCV3jDiaGtDABSztmMzQzPE3nEvBDthFuSB3hvAnMhlRSOX1NXjwjgub2AESo+RbvsqlsK
 OjCzGg97vGwtnmQIZp1fM0bvseqv+DOpv1eJHx2K8MBZNu4Wi3dZ1OORl66oBXUERDXCippVL
 AIhESTsjJyp/jMYqgoA8C8gdiEo4ljDOe6z/opzB0dOKhgXB4gofe/W7tQdD5h+AFiBRMN8zx
 fST9YSiLIhIMnykb+2DwtR5tJ1qd4fBNnzV5FDbvr3ga490LHFyPdFtIg76nY9Yev+LLrLczF
 3x7xSV84IRcvFcma9Tzo2K3aa/c4XQt5eM8fG4hzK9EPBhCEQ0yIUJ9yLIdMdiVluwQMdtGgi
 kvDBjsAXwCnRtTcidqe/rHSvx86/J1yqBVW2G0RspOWh354EMRPNnN6Ip1N446RYZ2aZdsBoi
 CjcHmQsjUWmQ2cC46MfCcR/HkhQiXBVgMavEzfEb6rrB2cvrp4tsZyuKSIEiU7PUPPPJpm6FW
 k+QM2aibotHl1xVyO0M/EF2Ka3uti+LsK4IOtK1L0CXg9a9DzwR/zG58+FgKiadkniZUrPqUy
 Bpx33jSONnisJViW14joriMOPQJiVp6k10NJulB1KWneNe93rYTkrPnM7fSrn+fX633hXwxXs
 i4Q7cucxtMMgJOrW7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested on Bananapi-r2 (please see my mt7623 patch for supporting offloading=
) with ~300 iperf3 iterations and uptime >6h

Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>
regards Frank
