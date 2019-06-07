Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 265A53981C
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbfFGV44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:56:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:13995 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729577AbfFGV4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 17:56:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 14:56:55 -0700
X-ExtLoop1: 1
Received: from unknown (HELO localhost) ([10.241.226.14])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jun 2019 14:56:54 -0700
Date:   Fri, 7 Jun 2019 14:56:54 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        jesse.brandeburg@intel.com
Subject: Re: [pull request][net 0/7] Mellanox, mlx5 fixes 2019-06-07
Message-ID: <20190607145654.00006187@intel.com>
In-Reply-To: <20190607214716.16316-1-saeedm@mellanox.com>
References: <20190607214716.16316-1-saeedm@mellanox.com>
X-Mailer: Claws Mail 3.14.0 (GTK+ 2.24.30; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jun 2019 21:47:35 +0000 Saeed wrote:
> Hi Dave,
> 
> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.
> 
> For -stable v4.17
>   ('net/mlx5: Avoid reloading already removed devices')
> 
> For -stable v5.0
>   ('net/mlx5e: Avoid detaching non-existing netdev under switchdev mode')
> 
> For -stable v5.1
>   ('net/mlx5e: Fix source port matching in fdb peer flow rule')
>   ('net/mlx5e: Support tagged tunnel over bond')
>   ('net/mlx5e: Add ndo_set_feature for uplink representor')
>   ('net/mlx5: Update pci error handler entries and command translation')
> 

For the series:
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
