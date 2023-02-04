Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20AE68A94F
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjBDKJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjBDKJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1268C1B55E
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE258B80AB4
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEF4C4339B;
        Sat,  4 Feb 2023 10:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505354;
        bh=WM2HXigoFCpPOIhmAqU/1N5f5ZaR8gGqdjcIWApxYL4=;
        h=From:To:Cc:Subject:Date:From;
        b=qjsf/785806VcMRJ6/ol2wbfiuKzIt6mzmwVSf4NHtKT35cDXjQXlwQVAecwG7Lt9
         9kb75ZvJ+z1cEi43ZwiQsWEKfCpj+IqZonoz3Crt7DqRPNW/GKwAUxXlDdGWHuvfwM
         T2pjK8TSD6ntjSw48e6rUL7PuSAHs/doVfeNitYeITWSza4T8QIvaYrpmROIIHsmNk
         ZMwR/IyxJDk2S2Ji3lOVMLNbSVDnUL2J8CEHju6AgzWp1edKaSHx5uOQtX3Jhpg9Tp
         YlON06H9LPOO7fXEulKQafcYYdYfjcarMzydYdCuwSEpKvE+h5H7uWeRNvgroTHBwb
         V8xPsdOufm34A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-02-04
Date:   Sat,  4 Feb 2023 02:08:39 -0800
Message-Id: <20230204100854.388126-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series adds misc updates to mlx5.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 042b7858d50f33af1f3569ad23f23afd5234b0f6:

  Merge branch 'net-smc-parallelism' (2023-02-04 09:48:19 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-02-04

for you to fetch changes up to 79efecb41f58430454cbb5809fa7b3135150da6d:

  net/mlx5e: Trigger NAPI after activating an SQ (2023-02-04 02:07:04 -0800)

----------------------------------------------------------------
mlx5-updates-2023-02-04

This series provides misc updates to mlx5 driver:

1) Trivial LAG code cleanup patches from Roi

2) Rahul improves mlx5's documentation structure
Separates the documentation into multiple pages related to different
components in the device driver. Adds Kconfig parameters, devlink
parameters, and tracepoints that were previously introduced but not added
to the documentation. Introduces a new page on ethtool statistics counters
with information about counters previously implemented in the mlx5_core
driver but not documented in the kernel tree.

3) From Raed, policy/state selector support for IPSec.

4) From Fragos, add support for XDR speed in IPoIB mlx5 netdev

5) Few more misc cleanups and trivial changes

----------------------------------------------------------------
Dragos Tatulea (1):
      net/mlx5e: IPoIB, Add support for XDR speed

Jack Morgenstein (1):
      net/mlx5: Enhance debug print in page allocation failure

Mark Bloch (1):
      net/mlx5: Lag, Use flag to check for shared FDB mode

Maxim Mikityanskiy (1):
      net/mlx5e: Trigger NAPI after activating an SQ

Raed Salem (1):
      net/mlx5e: IPsec, support upper protocol selector field offload

Rahul Rameshbabu (6):
      net/mlx5: Separate mlx5 driver documentation into multiple pages
      net/mlx5: Update Kconfig parameter documentation
      net/mlx5: Document previously implemented mlx5 tracepoints
      net/mlx5: Add counter information to mlx5 driver documentation
      net/mlx5: Document support for RoCE HCA disablement capability
      net/mlx5: Add firmware support for MTUTC scaled_ppm frequency adjustments

Roi Dayan (4):
      net/mlx5: Lag, Update multiport eswitch check to log an error
      net/mlx5: Lag, Use mlx5_lag_dev() instead of derefering pointers
      net/mlx5: Lag, Remove redundant bool allocation on the stack
      net/mlx5: Lag, Move mpesw related definitions to mpesw.h

 .../networking/device_drivers/ethernet/index.rst   |    2 +-
 .../device_drivers/ethernet/mellanox/mlx5.rst      |  746 -----------
 .../ethernet/mellanox/mlx5/counters.rst            | 1302 ++++++++++++++++++++
 .../ethernet/mellanox/mlx5/devlink.rst             |  224 ++++
 .../ethernet/mellanox/mlx5/index.rst               |   26 +
 .../ethernet/mellanox/mlx5/kconfig.rst             |  168 +++
 .../ethernet/mellanox/mlx5/switchdev.rst           |  239 ++++
 .../ethernet/mellanox/mlx5/tracepoints.rst         |  229 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |    2 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |    4 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |    6 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   23 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   10 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   23 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   15 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |    2 +
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |   15 -
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |    8 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   20 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h    |   19 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   15 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |    3 +-
 include/linux/mlx5/mlx5_ifc.h                      |   12 +-
 26 files changed, 2328 insertions(+), 803 deletions(-)
 delete mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/index.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/kconfig.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/tracepoints.rst
