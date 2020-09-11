Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A1C2667C0
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgIKRue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:50:34 -0400
Received: from mout.gmx.net ([212.227.17.21]:35399 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgIKRu2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 13:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599846582;
        bh=9A8KbB8JAsMszk5e8nKi2X4m4uBUOMdvLJVTs/9a5M0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=D0E7FCBpwplg3djfX9eZpQ8jMx2EgJadPN7JIVCxXspHLZ/LmZFs1BGhw5e2scCg2
         p8vYCsVtju9xTEBJ1G7w9aFb1uvTfOfiZ4eIiIxMjmQNSHKLzQ1hCPNbm8UY2htjp4
         3y8pGHCa6Tg3hfbOR/za9PBKOKtsZuPc/n1EEn3k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.150.14] ([217.61.150.14]) by web-mail.gmx.net
 (3c-app-gmx-bs18.server.lan [172.19.170.70]) (via HTTP); Fri, 11 Sep 2020
 19:49:42 +0200
MIME-Version: 1.0
Message-ID: <trinity-cc01b89b-ddcc-488a-84eb-3c96376c2be6-1599846582837@3c-app-gmx-bs18>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        opensource@vdorst.com, dqfext@gmail.com,
        Landen Chao <landen.chao@mediatek.com>
Subject: Aw: [PATCH net-next v5 6/6] arm64: dts: mt7622: add mt7531 dsa to
 bananapi-bpi-r64 board
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 11 Sep 2020 19:49:42 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <9ad3baefb672805153c737f6259966d1c9b98c2b.1599829696.git.landen.chao@mediatek.com>
References: <cover.1599829696.git.landen.chao@mediatek.com>
 <9ad3baefb672805153c737f6259966d1c9b98c2b.1599829696.git.landen.chao@mediatek.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:BZ5FW3bde8rsAWlm88krnef1H4ZN4Kuf+O7Ne2Cm4MZCc4sc5ttQ+z8IF1opvo/9lcj/r
 9I6xdSujcRKZeLkBtfmSAk7aUzR3218XQlCGOBux68+Z694KQ36aad/LlwK/qylSsjFP+D/rGGol
 VrmbHcyqn6HdAPrckkS5g3sQPKoTAQOIsTgBjWQb3gDipCpSSRDyGGVCZnMpaB3sC5TDU5Ku+idy
 CCwoiWfcWe+cxrzdyb0JYzOrxrHW/zXqWxQ5CkZWwMjDPEUmqzNV3qD3vHDWeOJmX7g1x5DwiUhE
 o8=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NVdLXOaaAJE=:Q3I5oVV0MKWr7w/B/Hm9FX
 Xa2yjHH+k1CRjLuf9bvOevSCj5x4BZTpsWbJL00MT/ufFi8U2FQaxqJPLYbxLX6tbXZ1jDaV6
 1+RLv3BUazXnMDJ0ktrgT7ftmWGU4FA1kni16MXltLwUXQ60AFKLPwUohAvdecCN9BenNVFbd
 ft5+4RF+maNQcqrRttnbVRXQjRCTa66mthKgbggRpDbS8B96FQAbwWL1/ZQaZPwWs3h+scTAn
 Nl3bZQQKqVs288iH82tnN6NRmu5e37glrZpSykjROu/SWvI2cpIMSzfmQh+05V6ioqb+k18FD
 yEWUFxRanextYUnhLp3OoP0L9jdJ8+iGoTzo4GhRQM6iWXSfU4ZCQnM0RqFEeTcRNODhwuM7D
 0Mn+qJmcmNvUdsnIuWsJJ7NgjDUJPwklKz6va6yBhOsj9sHm20DTI2D3Xi0QghD1Ak1l05kmW
 2ZuzJ20r+OWICmcgf1F26bZm4G2wFtJGG6P/Z0dp/4bfnctdIbxK66eJ8DW037Eod3aVZGkmn
 Vi5wk6SGN54oJ7lttCGeyCKpjKr3hSQMeMr3KD800OoH+9JG8wc25nlhrYJinPBS2leH5jPI0
 VSgfl664hHIVyxTX0MvrX5fkclwmaKY+i+Z8zaF05hG9XOPEYRDQjAOMQUDL77zrZsCF7WYn+
 9AJKxTMNAqNIOXWpUzqruVd11I7I4KwjmhGYHenUnm1zLHrwtIzi+R2s+DGSEQn2Kxc4=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested full series on Bananapi-r2 and r64, results as in v3

Tested-By: Frank Wunderlich <frank-w@public-files.de>

regards Frank
