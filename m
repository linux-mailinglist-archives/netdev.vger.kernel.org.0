Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE3B1C7BD8
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgEFVCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726538AbgEFVCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:02:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E172C061A0F;
        Wed,  6 May 2020 14:02:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B4C961210D920;
        Wed,  6 May 2020 14:02:39 -0700 (PDT)
Date:   Wed, 06 May 2020 14:02:39 -0700 (PDT)
Message-Id: <20200506.140239.2129195871879981516.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     jeffrey.t.kirsher@intel.com, piotr.azarewicz@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] i40e: Make i40e_shutdown_adminq() return void
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506061835.19662-1-yanaijie@huawei.com>
References: <20200506061835.19662-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 14:02:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Wed, 6 May 2020 14:18:35 +0800

> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/intel/i40e/i40e_adminq.c:699:13-21: Unneeded
> variable: "ret_code". Return "0" on line 710
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Jeff, please pick this up.

Thank you.
