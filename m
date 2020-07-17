Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC3D2244E8
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 22:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgGQUI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 16:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgGQUI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 16:08:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE6BC0619D2;
        Fri, 17 Jul 2020 13:08:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF22011E45925;
        Fri, 17 Jul 2020 13:08:27 -0700 (PDT)
Date:   Fri, 17 Jul 2020 13:08:26 -0700 (PDT)
Message-Id: <20200717.130826.2116036973011121784.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     kuba@kernel.org, sameo@linux.intel.com, cuissard@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] nfc: nci: add missed destroy_workqueue in
 nci_register_device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717071016.33319-1-wanghai38@huawei.com>
References: <20200717071016.33319-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 13:08:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Fri, 17 Jul 2020 15:10:16 +0800

> When nfc_register_device fails in nci_register_device,
> destroy_workqueue() shouled be called to destroy ndev->tx_wq.
> 
> Fixes: 3c1c0f5dc80b ("NFC: NCI: Fix nci_register_device init sequence")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
> v1->v2:
>  Change the module from "net: cxgb3:" to "nfc: nci:"

Applied, thanks.
