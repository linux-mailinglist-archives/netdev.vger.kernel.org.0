Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0898818FE66
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgCWUBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:01:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgCWUBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:01:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B5E115AD6068;
        Mon, 23 Mar 2020 13:01:37 -0700 (PDT)
Date:   Mon, 23 Mar 2020 13:01:36 -0700 (PDT)
Message-Id: <20200323.130136.1140495791175015677.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, paulb@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] flow_offload: add TC_SETP_FT type in
 flow_indr_block_call
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584522012-5692-1-git-send-email-wenxu@ucloud.cn>
References: <1584522012-5692-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 13:01:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Wed, 18 Mar 2020 17:00:12 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> Add TC_SETP_FT type in flow_indr_block_call for supporting indr block call
> in nf_flow_table_offload
> 
> Fixes: b5140a36da78 ("netfilter: flowtable: add indr block setup support")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

I don't understand what this patch is doing, why it is necessary, and why
it was implemented the way that it was.

You must write proper, full, commit log messages for your changes.
