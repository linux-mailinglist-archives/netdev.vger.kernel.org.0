Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943F61C0567
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgD3S5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3S5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:57:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63286C035494;
        Thu, 30 Apr 2020 11:57:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0640F1288A0FB;
        Thu, 30 Apr 2020 11:57:51 -0700 (PDT)
Date:   Thu, 30 Apr 2020 11:57:51 -0700 (PDT)
Message-Id: <20200430.115751.581150594033352826.davem@davemloft.net>
To:     zou_wei@huawei.com
Cc:     aviad.krawczyk@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v3] hinic: Use ARRAY_SIZE for
 nic_vf_cmd_msg_handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588211491-29670-1-git-send-email-zou_wei@huawei.com>
References: <1588211491-29670-1-git-send-email-zou_wei@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 11:57:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>
Date: Thu, 30 Apr 2020 09:51:31 +0800

> fix coccinelle warning, use ARRAY_SIZE
> 
> drivers/net/ethernet/huawei/hinic/hinic_sriov.c:713:43-44: WARNING: Use ARRAY_SIZE
> 
> v1-->v2:
>    remove cmd_number
> 
> v2-->v3:
>    preserve the reverse christmas tree ordering of local variables
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Applied.
