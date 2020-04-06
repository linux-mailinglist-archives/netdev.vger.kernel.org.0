Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC9619F6E8
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgDFN0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:26:21 -0400
Received: from mout.gmx.net ([212.227.17.22]:40757 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbgDFN0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 09:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1586179542;
        bh=cZxryEa5tb+4ohfc5V2brSTnlGtEjAXGe6KYmDrG5hk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=FDqxf/03Me6n52488Y18Rabb5YSwMPn1mam4w4B6S2FebURiMOjtlneLssYKRhVZV
         iSU2GotSw9c5FzSAXDal/a4PO8MaL4SCiPIb+eHaWbjHqRuSJ33O0zYBXMHpZOxGAl
         xWbb/xhuYuR4UuaOcC6KNdWEzXaA+6JGSVrclXek=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.149.116] ([217.61.149.116]) by web-mail.gmx.net
 (3c-app-gmx-bap62.server.lan [172.19.172.132]) (via HTTP); Mon, 6 Apr 2020
 15:25:42 +0200
MIME-Version: 1.0
Message-ID: <trinity-fb0cdf15-dfcf-4d60-9144-87d8fbfad5ba-1586179542451@3c-app-gmx-bap62>
From:   "Frank Wunderlich" <frank-w@public-files.de>
To:     sean.wang@mediatek.com
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@savoirfairelinux.com, Mark-MC.Lee@mediatek.com,
        john@phrozen.org, Landen.Chao@mediatek.com,
        steven.liu@mediatek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?=22Ren=C3=A9_van_Dorst=22?= <opensource@vdorst.com>,
        linux-mediatek@lists.infradead.org
Subject: Aw: [PATCH v2 net 1/2] net: dsa: mt7530: move mt7623 settings out
 off the mt7530
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 6 Apr 2020 15:25:42 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <1586122974-22125-1-git-send-email-sean.wang@mediatek.com>
References: <1586122974-22125-1-git-send-email-sean.wang@mediatek.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:O1vU5Y4cQTpCmCr8F/qiebVj81nxiFnE5QlNKEK3tTiupQQ3ghXSyk0ZApsFymcjQ8Rlf
 q3gIdeGy49auc3bph4SXTubVy51+lvbVajZaENnxiiY8AGOJyiDriMDc65Dxc1SGJxXySuhC5XQP
 7dZJruxEuXE8FNuPSWK7mQG6+8T74Sgv3bm0myeTblKgGfMo37EXtoCaVevDZ0leLdhR/1pvqa/+
 5Cy0ZI35eRixcMb2Wf/oSUvbkqsdv8kS5iQa451qd/x8IpPyMXJeL0cbKqNmWWLJyPfrBiVvGzx4
 SI=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pBy9zcz6aqI=:Y+q9/7RkJD0R8BQoabs8+k
 a0AtodGnx1+Sp3KQ0UES8c/6igKsZhu5lFK65lXFmsdIh3X0GZSZlWegMyGqnjhL/0ToWRS/4
 GYhN0gfTjU6h+5s12FFxOYwXf6VLs2yor9iT9yur1I8vtFClWoIaCyHG9UP7RqSr0OsxNHSmn
 LdMrwrv4Gyr5MfdBQCHKEou0Iz8RnAvmxSJJmVmB193gLABJGj+2Mj1hRumOjn5AZvtiibO9x
 N6QlD4QGWYnyJVW+v1Lebc82GVX0Pw88mDoHyuGQMFhurajKscffLM7rVVnLU2ZyvQHAGAylI
 RtZtNldAVDfH/Mp0pEsH/FcS7Yw9xmx+2LQIrl9lO839TIpHSxpuoiMbsXqBW6MTWag5uFXEJ
 08yCayHNEP2KWwsBpIOO7428ykDDzHPhX+R/+NUcEALWl4sculIltOspefQv4o2l2AFj/0HVr
 clH+GOPY9Qem2S7z0JItFBkIEdQ/k3rdJkjWVdbJviTwBwcZVzBrRbhC9VoN52dtjys/pcorJ
 1y29sm4VqxoRCFPZW8KfIN5ME6SGyE6CO7kYQk3Y00Pclq/F6lG4sHiUCtm2oo/iAwFIg2Jgj
 vxvIThhIyWGt7zWiaUX2D2WDlgHyE7HZm6kz+nOhszj33OysxFo2mFgrlE6fUkfkiIXN6ZmYO
 0mhKgc1gZJ4sLMNLVD3LnopNOy+aunQVJN/+KJg62hcm4D1SnKQpl+h+WtXMDmfhTvAM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

have tested these 2 and additional rene's 3rd Patch on my tree [1] on BPi-R2, no problem with trgmii yet (multiple power-cycle+reboots). I had issues with current 5.6.0 version, so imho these should go also into 5.6.y

regards Frank

Tested-by: Frank Wunderlich <frank-w@public-files.de>

[1] https://github.com/frank-w/BPI-R2-4.14/commits/5.6-trgmii
