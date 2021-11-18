Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71347455DF5
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhKROa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:30:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233001AbhKROa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:30:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 337F56128C;
        Thu, 18 Nov 2021 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637245647;
        bh=hWTg/e0a1wwLZ78Vd4mnYGKWFnORHDirRsZduOC8yhY=;
        h=From:To:Cc:Subject:Date:From;
        b=Kcpn3GyNeQOOK8er/cQ71NtHr+uIPQwQ7dAEf9gMNypgBXOmZmavLYoiMoBHR3iod
         q/Y/StYNw3DTUPMBAFyi2iFlR6lFiNdwM/dZz0Qq6805J4RVyffGog18EiBU0MjFMq
         q1l1QioMHxB6km1m0nR/EjyZfPr9k44aaMJsZpAA8PwVEUyJ+VR0RzLlcVEmFD9q1P
         aaZVtCNvvlzLfZsuFE5adttetpnUmFgTxOu1WTDVRGEZ0gAdMZIK6hZ3pVU1fyagq2
         qCOWX9yovs7fULuWkEs7E/yIPb869QAPAssUeNXPt1oBozMOYENu/EYHaim04RjB9v
         JVWtMOF3wZMVg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/4] net: constify netdev->dev_addr - x86 changes
Date:   Thu, 18 Nov 2021 06:27:16 -0800
Message-Id: <20211118142720.3176980-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending these so they can get merged while I battle random cross builds.

Jakub Kicinski (4):
  net: ax88796c: don't write to netdev->dev_addr directly
  mlxsw: constify address in mlxsw_sp_port_dev_addr_set
  wilc1000: copy address before calling wilc_set_mac_address
  ipw2200: constify address in ipw_send_adapter_address

 drivers/net/ethernet/asix/ax88796c_main.c      | 18 ++++++++++--------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c   |  2 +-
 .../net/wireless/microchip/wilc1000/netdev.c   |  6 +++---
 4 files changed, 15 insertions(+), 13 deletions(-)

-- 
2.31.1

