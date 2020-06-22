Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B4D203C1C
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgFVQEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:04:31 -0400
Received: from m12-14.163.com ([220.181.12.14]:41004 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729298AbgFVQE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 12:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=GQowN
        qmoyj4kwdiKWWbLTZBxwMI8tC95BLG31CQkfsw=; b=j4bSP3K8au6Z9uvpu+lZA
        7zGQjwZ8UGJZgJQVCfCcjhDZVg18x+b8kF4iDyXVFaxF2zcAhQA83ikxxBi5woEc
        ytP3u7V1cqixEPc8uNYfgMJvmqsdRF3PAS2QHs8aeffY4zIVYJ7JmxCe17dI4RSm
        7ScXnSs4Gogjsn+MXyNp+k=
Received: from SZA191027643-PM.china.huawei.com (unknown [120.235.53.225])
        by smtp10 (Coremail) with SMTP id DsCowABnbelA1vBeGrmZHw--.17892S2;
        Tue, 23 Jun 2020 00:03:15 +0800 (CST)
From:   yunaixin03610@163.com
To:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, wuguanping@huawei.com,
        wangqindong@huawei.com
Cc:     yunaixin <yunaixin03610@163.com>
Subject: [PATCH 0/5] Adding Huawei BMA drivers
Date:   Tue, 23 Jun 2020 00:03:06 +0800
Message-Id: <20200622160311.1533-1-yunaixin03610@163.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID: DsCowABnbelA1vBeGrmZHw--.17892S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtw4DtFWUKrW3tr15Aw1UZFb_yoWxtFWxpa
        yjya4UurWxKFy7Xw1vy3W8KFn8J3WDtry5u393Z3WrX3s2yry5JryDWF15uF1fWa97Gr4I
        vF1Y9F1fWFZ8X3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziX4S7UUUUU=
X-Originating-IP: [120.235.53.225]
X-CM-SenderInfo: 51xqtxx0lqijqwrqqiywtou0bp/xtbBZwNL5letzVI0DQAAsV
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yunaixin <yunaixin03610@163.com>

This patch set contains 5 communication drivers for Huawei BMA software.=0D
The BMA software is a system management software. It supports the status=0D
monitoring, performance monitoring, and event monitoring of various=0D
components, including server CPUs, memory, hard disks, NICs, IB cards,=0D
PCIe cards, RAID controller cards, and optical modules.=0D
=0D
These 5 drivers are used to send/receive message through PCIe channel in=0D
different ways by BMA software.

yunaixin (5):
  Huawei BMA: Adding Huawei BMA driver: host_edma_drv
  Huawei BMA: Adding Huawei BMA driver: host_cdev_drv
  Huawei BMA: Adding Huawei BMA driver: host_veth_drv
  Huawei BMA: Adding Huawei BMA driver: cdev_veth_drv
  Huawei BMA: Adding Huawei BMA driver: host_kbox_drv

 drivers/net/ethernet/huawei/Kconfig           |    1 +
 drivers/net/ethernet/huawei/Makefile          |    1 +
 drivers/net/ethernet/huawei/bma/Kconfig       |    5 +
 drivers/net/ethernet/huawei/bma/Makefile      |    9 +
 .../net/ethernet/huawei/bma/cdev_drv/Kconfig  |   11 +
 .../net/ethernet/huawei/bma/cdev_drv/Makefile |    2 +
 .../ethernet/huawei/bma/cdev_drv/bma_cdev.c   |  369 +++
 .../ethernet/huawei/bma/cdev_veth_drv/Kconfig |   11 +
 .../huawei/bma/cdev_veth_drv/Makefile         |    2 +
 .../bma/cdev_veth_drv/virtual_cdev_eth_net.c  | 1839 ++++++++++++
 .../bma/cdev_veth_drv/virtual_cdev_eth_net.h  |  300 ++
 .../net/ethernet/huawei/bma/edma_drv/Kconfig  |   11 +
 .../net/ethernet/huawei/bma/edma_drv/Makefile |    2 +
 .../huawei/bma/edma_drv/bma_devintf.c         |  597 ++++
 .../huawei/bma/edma_drv/bma_devintf.h         |   40 +
 .../huawei/bma/edma_drv/bma_include.h         |  116 +
 .../ethernet/huawei/bma/edma_drv/bma_pci.c    |  533 ++++
 .../ethernet/huawei/bma/edma_drv/bma_pci.h    |   94 +
 .../ethernet/huawei/bma/edma_drv/edma_host.c  | 1462 ++++++++++
 .../ethernet/huawei/bma/edma_drv/edma_host.h  |  351 +++
 .../huawei/bma/include/bma_ker_intf.h         |   94 +
 .../net/ethernet/huawei/bma/kbox_drv/Kconfig  |   11 +
 .../net/ethernet/huawei/bma/kbox_drv/Makefile |    2 +
 .../ethernet/huawei/bma/kbox_drv/kbox_dump.c  |  121 +
 .../ethernet/huawei/bma/kbox_drv/kbox_dump.h  |   33 +
 .../ethernet/huawei/bma/kbox_drv/kbox_hook.c  |  101 +
 .../ethernet/huawei/bma/kbox_drv/kbox_hook.h  |   33 +
 .../huawei/bma/kbox_drv/kbox_include.h        |   40 +
 .../ethernet/huawei/bma/kbox_drv/kbox_main.c  |  168 ++
 .../ethernet/huawei/bma/kbox_drv/kbox_main.h  |   23 +
 .../ethernet/huawei/bma/kbox_drv/kbox_mce.c   |  264 ++
 .../ethernet/huawei/bma/kbox_drv/kbox_mce.h   |   23 +
 .../ethernet/huawei/bma/kbox_drv/kbox_panic.c |  187 ++
 .../ethernet/huawei/bma/kbox_drv/kbox_panic.h |   25 +
 .../huawei/bma/kbox_drv/kbox_printk.c         |  363 +++
 .../huawei/bma/kbox_drv/kbox_printk.h         |   33 +
 .../huawei/bma/kbox_drv/kbox_ram_drive.c      |  188 ++
 .../huawei/bma/kbox_drv/kbox_ram_drive.h      |   31 +
 .../huawei/bma/kbox_drv/kbox_ram_image.c      |  135 +
 .../huawei/bma/kbox_drv/kbox_ram_image.h      |   84 +
 .../huawei/bma/kbox_drv/kbox_ram_op.c         |  986 +++++++
 .../huawei/bma/kbox_drv/kbox_ram_op.h         |   77 +
 .../net/ethernet/huawei/bma/veth_drv/Kconfig  |   11 +
 .../net/ethernet/huawei/bma/veth_drv/Makefile |    2 +
 .../ethernet/huawei/bma/veth_drv/veth_hb.c    | 2502 +++++++++++++++++
 .../ethernet/huawei/bma/veth_drv/veth_hb.h    |  440 +++
 46 files changed, 11733 insertions(+)
 create mode 100644 drivers/net/ethernet/huawei/bma/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_drv/bma_cdev.c
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_veth_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_veth_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_veth_drv/virtual_c=
dev_eth_net.c
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_veth_drv/virtual_c=
dev_eth_net.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.c
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_include.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/edma_host.h
 create mode 100644 drivers/net/ethernet/huawei/bma/include/bma_ker_intf.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_include.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive=
.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive=
.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image=
.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image=
.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.h
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.c
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.h

--=20
2.26.2.windows.1


