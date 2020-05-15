Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55751D4214
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgEOA3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727805AbgEOA3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:29:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BE8C061A0C;
        Thu, 14 May 2020 17:29:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 097FC14CCC99F;
        Thu, 14 May 2020 17:29:15 -0700 (PDT)
Date:   Thu, 14 May 2020 17:29:12 -0700 (PDT)
Message-Id: <20200514.172912.286966851347264575.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     ecree@solarflare.com, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, paulb@mellanox.com, ozsh@mellanox.com,
        vladbu@mellanox.com, jiri@resnulli.us, kuba@kernel.org,
        saeedm@mellanox.com, michael.chan@broadcom.com
Subject: Re: [PATCH 0/8 net] the indirect flow_block offload, revisited
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514223627.GA3170@salvia>
References: <20200513164140.7956-1-pablo@netfilter.org>
        <8f1a3b9a-6a60-f1b3-0fc1-f2361864c822@solarflare.com>
        <20200514223627.GA3170@salvia>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:29:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 15 May 2020 00:36:27 +0200

> The TC CT action crashes the kernel with an indirect flow_block in place:
> 
> https://lore.kernel.org/netfilter-devel/db9dfe4f-62e7-241b-46a0-d878c89696a8@ucloud.cn/

I've read over this patch set at least three times, and reread the
header posting, and there is no clear indication that this patch
series fixes a crash at all.

You need to be explicit about what bug this is fixing, in the commit
messages and introduction posting, with quoted crash logs etc.
