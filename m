Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142652113D7
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgGATqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgGATqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:46:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6EAC08C5C1;
        Wed,  1 Jul 2020 12:46:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B90CF12722D0A;
        Wed,  1 Jul 2020 12:46:29 -0700 (PDT)
Date:   Wed, 01 Jul 2020 12:46:28 -0700 (PDT)
Message-Id: <20200701.124628.2214462813443329914.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     hulkci@huawei.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] qed: Make symbol 'qed_hw_err_type_descr'
 static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701153803.69360-1-weiyongjun1@huawei.com>
References: <20200701153803.69360-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 12:46:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Wed, 1 Jul 2020 23:38:03 +0800

> From: Hulk Robot <hulkci@huawei.com>
> 
> Fix sparse build warning:
> 
> drivers/net/ethernet/qlogic/qed/qed_main.c:2480:6: warning:
>  symbol 'qed_hw_err_type_descr' was not declared. Should it be static?
> 
> Signed-off-by: Hulk Robot <hulkci@huawei.com>

Applied.
