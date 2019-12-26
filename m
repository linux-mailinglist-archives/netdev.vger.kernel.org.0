Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CCD12AFA0
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfLZXUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:20:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44524 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfLZXUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:20:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7214015399BE5;
        Thu, 26 Dec 2019 15:20:17 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:20:16 -0800 (PST)
Message-Id: <20191226.152016.1920270671846157194.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     edumazet@google.com, willemb@google.com, maximmi@mellanox.com,
        pabeni@redhat.com, yuehaibing@huawei.com, nhorman@tuxdriver.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH net-next v2] af_packet: refactoring code for
 prb_calc_retire_blk_tmo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191223104257.132354-1-maowenan@huawei.com>
References: <CA+FuTScgWi905_NhGNsRzpwaQ+OPwahj6NtKgPjLZRjuqJvhXQ@mail.gmail.com>
        <20191223104257.132354-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:20:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Mon, 23 Dec 2019 18:42:57 +0800

> If __ethtool_get_link_ksettings() is failed and with
> non-zero value, prb_calc_retire_blk_tmo() should return
> DEFAULT_PRB_RETIRE_TOV firstly. 
> 
> This patch is to refactory code and make it more readable.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied, thanks.
