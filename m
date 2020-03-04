Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F22DE17895C
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCDEGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:06:39 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55964 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725861AbgCDEGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:06:39 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 4 Mar 2020 06:06:34 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02446XJQ014213;
        Wed, 4 Mar 2020 06:06:33 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org, jiri@mellanox.com,
        parav@mellanox.com
Subject: [PATCH net-next iproute2 0/2] devlink: Introduce devlink port flavour virtual
Date:   Tue,  3 Mar 2020 22:06:24 -0600
Message-Id: <20200304040626.26320-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently PCI PF and VF devlink devices register their ports as
physical port in non-representors mode.

Introduce a new port flavour as virtual so that virtual devices can
register 'virtual' flavour to make it more clear to users.

An example of one PCI PF and 2 PCI virtual functions, each having
one devlink port.

$ devlink port show
pci/0000:06:00.0/1: type eth netdev ens2f0 flavour physical port 0
pci/0000:06:00.2/1: type eth netdev ens2f2 flavour virtual port 0
pci/0000:06:00.3/1: type eth netdev ens2f3 flavour virtual port 0



Parav Pandit (2):
  Update devlink kernel header
  devlink: Introduce devlink port flavour virtual

 devlink/devlink.c            | 2 ++
 include/uapi/linux/devlink.h | 3 +++
 2 files changed, 5 insertions(+)

-- 
2.19.2

