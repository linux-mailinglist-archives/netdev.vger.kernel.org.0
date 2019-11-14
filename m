Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E577FD16A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKNXOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:14:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55620 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfKNXOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 18:14:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4179014AD0609;
        Thu, 14 Nov 2019 15:14:39 -0800 (PST)
Date:   Thu, 14 Nov 2019 15:14:38 -0800 (PST)
Message-Id: <20191114.151438.1286269607812851870.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] netfilter: flow_table_offload something
 fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
References: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 15:14:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Wed, 13 Nov 2019 12:46:38 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> 
> wenxu (4):
>   netfilter: flow_table_offload: Fix check ndo_setup_tc when setup_block
>   netfilter: flow_table_core: remove unnecessary parameter in
>     flow_offload_fill_dir
>   netfilter: nf_tables: Fix check the err for FLOW_BLOCK_BIND setup call
>   netfilter: nf_tables_api: Fix UNBIND setup in the nft_flowtable_event

Pablo, I assume you will take these.

Thanks.
