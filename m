Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8CF18DDA7
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 03:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgCUCei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 22:34:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgCUCei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 22:34:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8230158C34B8;
        Fri, 20 Mar 2020 19:34:37 -0700 (PDT)
Date:   Fri, 20 Mar 2020 19:34:34 -0700 (PDT)
Message-Id: <20200320.193434.1013418419753934109.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320135134.436907-1-pablo@netfilter.org>
References: <20200320135134.436907-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Mar 2020 19:34:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 20 Mar 2020 14:51:30 +0100

> The following patchset contains Netfilter fixes for net:
> 
> 1) Refetch IP header pointer after pskb_may_pull() in flowtable,
>    from Haishuang Yan.
> 
> 2) Fix memleak in flowtable offload in nf_flow_table_free(),
>    from Paul Blakey.
> 
> 3) Set control.addr_type mask in flowtable offload, from Edward Cree.

Pulled, thanks Pablo.
