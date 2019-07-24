Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392D0730D6
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfGXOD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:03:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbfGXOD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 10:03:57 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 128363086202;
        Wed, 24 Jul 2019 14:03:57 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.205.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0783D19C67;
        Wed, 24 Jul 2019 14:03:55 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2]  mlx4/en_netdev: allow offloading VXLAN over VLAN
Date:   Wed, 24 Jul 2019 16:02:52 +0200
Message-Id: <cover.1563976690.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 24 Jul 2019 14:03:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When VXLAN offload is enabled on ConnectX-3 Pro devices, the NIC can
segment correctly also VXLAN packet with a VLAN tag: this series ensures
that a VLAN created on top of a mlx4_en NIC inherits the tunnel offload
capabilities.

Davide Caratti (2):
  mlx4/en_netdev: update vlan features with tunnel offloads
  mlx4/en_netdev: call notifiers when hw_enc_features change

 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 60 ++++++++++++-------
 1 file changed, 37 insertions(+), 23 deletions(-)

-- 
2.20.1

