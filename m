Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E7F104433
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 20:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfKTTVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 14:21:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfKTTVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 14:21:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E141314BF1ACB;
        Wed, 20 Nov 2019 11:21:52 -0800 (PST)
Date:   Wed, 20 Nov 2019 11:21:50 -0800 (PST)
Message-Id: <20191120.112150.813819380036515927.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] nf_tables_offload: vlan matching support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191119220555.17391-1-pablo@netfilter.org>
References: <20191119220555.17391-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 11:21:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 19 Nov 2019 23:05:51 +0100

> The following patchset contains Netfilter support for vlan matching
> offloads:
> 
> 1) Constify nft_reg_load() as a preparation patch.
> 2) Restrict rule matching to ingress interface type ARPHRD_ETHER.
> 3) Add new vlan_tci field to flow_dissector_key_vlan structure,
>    to allow to set up vlan_id, vlan_dei and vlan_priority in one go.
> 4) C-VLAN matching support.
> 
> Please, directly apply to net-next if you are OK with this batch.

Series applied, thanks.
