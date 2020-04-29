Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207CF1BE9B0
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 23:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgD2VP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 17:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2VP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 17:15:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D610C03C1AE;
        Wed, 29 Apr 2020 14:15:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8567F1210A3E3;
        Wed, 29 Apr 2020 14:15:55 -0700 (PDT)
Date:   Wed, 29 Apr 2020 14:15:52 -0700 (PDT)
Message-Id: <20200429.141552.1972809396140800173.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] Netfilter updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429194243.22228-1-pablo@netfilter.org>
References: <20200429194243.22228-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 14:15:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 29 Apr 2020 21:42:37 +0200

> The following patchset contains Netfilter updates for nf-next:
> 
> 1) Add IPS_HW_OFFLOAD status bit, from Bodong Wang.
> 
> 2) Remove 128-bit limit on the set element data area, rise it
>    to 64 bytes.
> 
> 3) Report EOPNOTSUPP for unsupported NAT types and flags.
> 
> 4) Set up nft_nat flags from the control plane path.
> 
> 5) Add helper functions to set up the nf_nat_range2 structure.
> 
> 6) Add netmap support for nft_nat.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks Pablo.
