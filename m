Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47775AC6F4
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 16:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391998AbfIGOeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 10:34:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45586 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388202AbfIGOeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 10:34:10 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B224152863F4;
        Sat,  7 Sep 2019 07:34:09 -0700 (PDT)
Date:   Sat, 07 Sep 2019 16:34:05 +0200 (CEST)
Message-Id: <20190907.163405.2109572655243996399.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/8] Netfilter updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905160400.25399-1-pablo@netfilter.org>
References: <20190905160400.25399-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 07:34:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu,  5 Sep 2019 18:03:52 +0200

> The following patchset contains Netfilter updates for net-next:
> 
> 1) Add nft_reg_store64() and nft_reg_load64() helpers, from Ander Juaristi.
> 
> 2) Time matching support, also from Ander Juaristi.
> 
> 3) VLAN support for nfnetlink_log, from Michael Braun.
> 
> 4) Support for set element deletions from the packet path, also from Ander.
> 
> 5) Remove __read_mostly from conntrack spinlock, from Li RongQing.
> 
> 6) Support for updating stateful objects, this also includes the initial
>    client for this infrastructure: the quota extension. A follow up fix
>    for the control plane also comes in this batch. Patches from
>    Fernando Fernandez Mancera.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks.
