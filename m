Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BD32313D0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgG1UYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgG1UYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:24:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A32C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 13:24:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75C15128AB37D;
        Tue, 28 Jul 2020 13:07:16 -0700 (PDT)
Date:   Tue, 28 Jul 2020 13:23:58 -0700 (PDT)
Message-Id: <20200728.132358.869679039982834710.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/13] mlx5 updates 2020-07-28
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 13:07:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 28 Jul 2020 02:43:58 -0700

> This series contains small misc updates to mlx5 driver.
> 
> Note that the pci relaxed ordering patch is now much smaller and 
> without the driver private knob by following the discussion conclusions 
> on the previous patch to only use the pcie_relaxed_ordering_enabled()
> kernel helper, and setpci to disable it as a chicken bit.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thank you.
