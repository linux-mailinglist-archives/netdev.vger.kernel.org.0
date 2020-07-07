Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7FA217B00
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgGGWaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgGGWaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:30:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3999C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 15:30:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72360120F93E0;
        Tue,  7 Jul 2020 15:30:02 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:30:01 -0700 (PDT)
Message-Id: <20200707.153001.905708444706327662.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: act_ct: add miss tcf_lastuse_update.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593848567-14288-1-git-send-email-wenxu@ucloud.cn>
References: <1593848567-14288-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:30:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Sat,  4 Jul 2020 15:42:47 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> When tcf_ct_act execute the tcf_lastuse_update should
> be update or the used stats never update
> 
> filter protocol ip pref 3 flower chain 0
> filter protocol ip pref 3 flower chain 0 handle 0x1
>   eth_type ipv4
>   dst_ip 1.1.1.1
>   ip_flags frag/firstfrag
>   skip_hw
>   not_in_hw
>  action order 1: ct zone 1 nat pipe
>   index 1 ref 1 bind 1 installed 103 sec used 103 sec
>  Action statistics:
>  Sent 151500 bytes 101 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
>  cookie 4519c04dc64a1a295787aab13b6a50fb
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Applied.
