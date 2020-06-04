Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB451EED98
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgFDWAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgFDWAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:00:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AB2C08C5C0;
        Thu,  4 Jun 2020 15:00:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AFBDE11D53F8B;
        Thu,  4 Jun 2020 15:00:42 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:00:40 -0700 (PDT)
Message-Id: <20200604.150040.2131369235290939835.davem@davemloft.net>
To:     joyce.ooi@intel.com
Cc:     thor.thayer@linux.intel.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dalon.westergreen@linux.intel.com, ley.foon.tan@intel.com,
        chin.liang.see@intel.com, dinh.nguyen@intel.com
Subject: Re: [PATCH v3 00/10] net: eth: altera: tse: Add PTP and mSGDMA
 prefetcher
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200604073256.25702-1-joyce.ooi@intel.com>
References: <20200604073256.25702-1-joyce.ooi@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:00:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ooi, Joyce" <joyce.ooi@intel.com>
Date: Thu,  4 Jun 2020 15:32:46 +0800

> From: Joyce Ooi <joyce.ooi@intel.com>
> 
> This patch series cleans up the Altera TSE driver and adds support
> for the newer msgdma prefetcher as well as ptp support when using
> the msgdma prefetcher.
> 
> v2: Rename altera_ptp to intel_fpga_tod, modify msgdma and sgdma tx_buffer
>     functions to be of type netdev_tx_t, and minor suggested edits
> v3: Modify tx_buffer to stop queue before returning NETDEV_TX_BUSY

net-next is closed at this time
