Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D35343FC8
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCVLah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhCVLaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 07:30:08 -0400
Received: from mxwww.masterlogin.de (mxwww.masterlogin.de [IPv6:2a03:2900:1:1::a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5501CC061574;
        Mon, 22 Mar 2021 04:30:07 -0700 (PDT)
Received: from mxout2.routing.net (unknown [192.168.10.82])
        by backup.mxwww.masterlogin.de (Postfix) with ESMTPS id 9E17A2C507;
        Mon, 22 Mar 2021 11:21:44 +0000 (UTC)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout2.routing.net (Postfix) with ESMTP id 079555FA25;
        Mon, 22 Mar 2021 11:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1616412100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fAfm5d45zVhZhTCL6xmuYVatc8OOf7hdInt0jJzTI/s=;
        b=tQzm0AytTusaC9sgjVBpygi4A40dsq73kw5wLj26GDKuOEY/uhrzf+W/sd9lET1f6h8BQ6
        YPdKbuhBQZ3aCZ6AvuKpz6gzVCa8eVtUlfQf7paF6fXzYfKNbzutUVJKp9IidcCIvbQRHM
        RfDm1cIgtKpfz58GfKc9Qrl1huE8nyw=
Received: from localhost.localdomain (unknown [80.245.73.88])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id 25EBA36010D;
        Mon, 22 Mar 2021 11:21:39 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] support mt7623 and ipv6
Date:   Mon, 22 Mar 2021 12:21:15 +0100
Message-Id: <20210322112117.16162-1-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 39cf0cc5-dd48-4042-b3b9-87b31c10b3b8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Extending functionality of recently sent nftables flow offload.

This Series contains 2 Patches where the second is for RFC, because i cannot test it,
but it is reported by author as working and i should send it

Series depend on HW offload Patches:
https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=233310&archive=both&state=*

Frank Wunderlich (2):
  net: mediatek: add flow offload for mt7623
  [RFC] net: ethernet: mtk_eth_soc: add ipv6 flow offload support

 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  1 +
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 55 +++++++++++++++++++
 2 files changed, 56 insertions(+)

-- 
2.25.1

