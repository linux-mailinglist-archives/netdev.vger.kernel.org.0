Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDD531584A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhBIVFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:05:12 -0500
Received: from smtp1.emailarray.com ([65.39.216.14]:60730 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbhBIUuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:50:05 -0500
Received: (qmail 33948 invoked by uid 89); 9 Feb 2021 19:49:09 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 9 Feb 2021 19:49:09 -0000
Date:   Tue, 9 Feb 2021 11:49:06 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     saeedm@nvidia.com
Cc:     netdev@vger.kernel.org
Subject: mlx5e compilation failure
Message-ID: <20210209194906.vo3ssh3gwzt3k5u2@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On mlx5e fails to compile on the latesst net-next:

  CC      drivers/net/ethernet/mellanox/mlx5/core/en_main.o
In file included from ../drivers/net/ethernet/mellanox/mlx5/core/en_tc.h:40,
                 from ../drivers/net/ethernet/mellanox/mlx5/core/en_main.c:45:
../drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h:24:29: error: field ‘match_level’ has incomplete type
   24 |  enum mlx5_flow_match_level match_level;
      |                             ^~~~~~~~~~~

With this .config snippet:
    CONFIG_MLX5_CORE=y
    # CONFIG_MLX5_FPGA is not set
    CONFIG_MLX5_CORE_EN=y
    # CONFIG_MLX5_EN_ARFS is not set
    CONFIG_MLX5_EN_RXNFC=y
    CONFIG_MLX5_MPFS=y
    # CONFIG_MLX5_ESWITCH is not set
    CONFIG_MLX5_CORE_EN_DCB=y
    # CONFIG_MLX5_CORE_IPOIB is not set
    # CONFIG_MLX5_SF is not set

Presumably because ESWITCH is not enabled.
-- 
Jonathan
