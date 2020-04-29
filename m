Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EC71BE676
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgD2Sn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2Sn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:43:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494C3C03C1AE;
        Wed, 29 Apr 2020 11:43:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32A2A1210D904;
        Wed, 29 Apr 2020 11:43:28 -0700 (PDT)
Date:   Wed, 29 Apr 2020 11:43:27 -0700 (PDT)
Message-Id: <20200429.114327.1585519928398105692.davem@davemloft.net>
To:     zou_wei@huawei.com
Cc:     aviad.krawczyk@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] hinic: Use ARRAY_SIZE for
 nic_vf_cmd_msg_handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588133860-55722-1-git-send-email-zou_wei@huawei.com>
References: <1588133860-55722-1-git-send-email-zou_wei@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 11:43:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>
Date: Wed, 29 Apr 2020 12:17:40 +0800

> fix coccinelle warning, use ARRAY_SIZE
> 
> drivers/net/ethernet/huawei/hinic/hinic_sriov.c:713:43-44: WARNING: Use ARRAY_SIZE
> 
> ----------

Please don't put this "-------" here.

> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> index b24788e..af70cca 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> @@ -704,17 +704,15 @@ int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
>  	struct hinic_hwdev *dev = hwdev;
>  	struct hinic_func_to_io *nic_io;
>  	struct hinic_pfhwdev *pfhwdev;
> -	u32 i, cmd_number;
> +	u32 i;
>  	int err = 0;

Please preserve the reverse christmas tree ordering of local variables.
