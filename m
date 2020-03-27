Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 882B9194F67
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgC0DEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:04:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57858 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0DEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:04:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CFC115CE71E1;
        Thu, 26 Mar 2020 20:04:10 -0700 (PDT)
Date:   Thu, 26 Mar 2020 20:04:09 -0700 (PDT)
Message-Id: <20200326.200409.835123184765124238.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v2] netfilter: Fix incorrect tc_setup_type
 type for flowtable offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585006465-27664-1-git-send-email-wenxu@ucloud.cn>
References: <1585006465-27664-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 20:04:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Tue, 24 Mar 2020 07:34:25 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> Flowtable offload setup flow_offlod_block in TC_SETP_FT. The indr block
> offload of flowtable also should setup in TC_SETUP_FT.
> But flow_indr_block_call always sets the tc_set_up_type as TC_SETUP_BLOCK.
> So function flow_indr_block_call should expose a parameters to set
> the tc_setup_type for each offload subsystem.
> 
> Fixes: b5140a36da78 ("netfilter: flowtable: add indr block setup support")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v2: modify the comments

Do the netfilter folks want to take this or should I apply it directly?

Thanks.
