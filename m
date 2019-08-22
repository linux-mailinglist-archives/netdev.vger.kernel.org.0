Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3308299924
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387825AbfHVQ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:27:15 -0400
Received: from mout.gmx.net ([212.227.17.22]:43233 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729213AbfHVQ1P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 12:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1566491191;
        bh=EFlLendt8CWQXL+vG3NFYTimiM+PuQRe0tn54GrTJvI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=J1oj+y+FOWEcxd/2mh0ST+byTtNPBFHL7bTKRkcLdRVhO4qIBRhkO711lC3ZS0f8l
         tP/t/UOMLwhRNCwvneZ2G3U6hBel+vnnplJFKcx8aEdZmwtlwzIBVpMf4qjx0A7jvO
         nzT6ewyRND+nEsfYOPLPwhhdT7aDBUU/5XNsvkcY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.154.89] ([217.61.154.89]) by web-mail.gmx.net
 (3c-app-gmx-bap07.server.lan [172.19.172.77]) (via HTTP); Thu, 22 Aug 2019
 18:26:31 +0200
MIME-Version: 1.0
Message-ID: <trinity-34b058f1-59d5-44b0-8783-a2c2440daf91-1566491191041@3c-app-gmx-bap07>
From:   "Frank Wunderlich" <frank-w@public-files.de>
To:     "Frank Wunderlich" <frank-w@public-files.de>
Cc:     =?UTF-8?Q?=22Ren=C3=A9_van_Dorst=22?= <opensource@vdorst.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        "Sean Wang" <sean.wang@mediatek.com>, linux-mips@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-mediatek@lists.infradead.org,
        "John Crispin" <john@phrozen.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Aw: [PATCH net-next v2 0/3] net: dsa: mt7530: Convert to PHYLINK
 and add support for port 5
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 22 Aug 2019 18:26:31 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <trinity-b1f48e51-af73-466d-9ecf-d560a7d7c1ee-1566488653737@3c-app-gmx-bap07>
References: <20190821144547.15113-1-opensource@vdorst.com>
 <trinity-b1f48e51-af73-466d-9ecf-d560a7d7c1ee-1566488653737@3c-app-gmx-bap07>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:Kj7CZobsPnsr7zMq8BK+GQacgt27Jspm9jpx7yWGWaplZdZd8aja9akdwt++VHup9BcS0
 IVp0fhJXRc3pZQS4I0+mu06yvbd8TsfKwAREa02+QVekEJ9ZwW3K+gtAQC8lX7eO8ECuCls76G46
 72xV4qHPnIgvR9hBqOZoe8uPVuAiERZUUlmSIozv8fYLE+Aqq90YDQjFBGPhS6htpYNcKSQ11Jl1
 648imqiT/DAtQW6R+4saQlf8rnlqp5ePVxVuBhFol+gkPP4CWDhTRaRJI5t1tTv2hXEeqV4TL3aT
 s8=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:t+0B4WWivmI=:H2oz4bEmfWxC94hqA5jzqm
 KkusajgSnBgs/U3CkieChIr/hk41B8/m7wcoQfMR+PwI3GKgXuvhFfVTUsc1yCgTqslVUUD29
 VCSEuIaFgfW4rmaoET0PimCX+/6DvAVYQpOqqF3MJ9qZAxs1vh0sQxQ6hGNWnA3RgR37DPz+5
 EasdTGiXpaOXejgPQCwtUfC1xAqRhlm1yRDmzAbPDG89ePmQ23raCpn0X3yw8WtBpZJiWTqVD
 DpWY36Ii4Ep7KJD4KmuOKAFRccfZG5/deBsQe0Y5fGzz3U1DiOCttZpL1UQBkcDNTgz+vZ7p5
 zjmfhXeb2uICSFDTOWOmm0LwT8oezRBjfGRifBPENq02qfAOHCmZta3E2Rh5wts7ohCr6ybbI
 LBTZIUsEckzDBdOPG3cW8ypxAsJd0PLSJlOud2igzVImOD75iZA5ypn6zp3JdRu+3WGYpDBxk
 w2UxlslnJKHuPVHMY06YII3Bs/0/D+7m4aFEESes6kHB4NVJY6OYxQm9vL1MvXOjbPVtjlK0X
 tj/mKnR+ncWOcoTJNYyXhzAvYoPt2rhaKKpSXWxucCV7/XVjjhgEygWiOIGq7jV1gY7GDT8VI
 OWnmEKD3hnMJ20F49WuPuqpH4dyN25U+wLFMLHgWpeNefs7Rbta6TqoiINQOeekH/n3j++tiq
 humnnsNH/695SjU8Vww/AlCF0ru7gDq90sQDJ/hCy9AwEng==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tested now also on bpi-r64 (mt7622) v0.1 (rtl8367 switch), without linux-next to avoid power-regulator-problems like on bpi-r2

dmesg without warnings/errors caused by this patches
link came up as desired
iperf3 looks good: 943 Mbits/sec in both directions and no other issues

so it is currently only the rx-throughput-problem on mt7623/bpi-r2

regards Frank
