Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0EE86F6F
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405226AbfHIBo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:44:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbfHIBoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:44:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 160E514384FE1;
        Thu,  8 Aug 2019 18:44:55 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:44:54 -0700 (PDT)
Message-Id: <20190808.184454.1230954896965640540.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     jakub.kicinski@netronome.com, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v7 0/6] flow_offload: add indr-block in
 nf_table_offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
References: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:44:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Wed,  7 Aug 2019 09:13:48 +0800

> This series patch make nftables offload support the vlan and
> tunnel device offload through indr-block architecture.
> 
> The first four patches mv tc indr block to flow offload and
> rename to flow-indr-block.
> Because the new flow-indr-block can't get the tcf_block
> directly. The fifth patch provide a callback list to get 
> flow_block of each subsystem immediately when the device
> register and contain a block.
> The last patch make nf_tables_offload support flow-indr-block.
> 
> This version add a mutex lock for add/del flow_indr_block_ing_cb

Series applied, thank you.
