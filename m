Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C2D5FDE6
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfGDUto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:49:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53394 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfGDUto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:49:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36B06146A4B60;
        Thu,  4 Jul 2019 13:49:43 -0700 (PDT)
Date:   Thu, 04 Jul 2019 13:49:40 -0700 (PDT)
Message-Id: <20190704.134940.462462778251829402.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, saeedm@mellanox.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2019-07-03
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190703224740.15354-1-daniel@iogearbox.net>
References: <20190703224740.15354-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jul 2019 13:49:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Thu,  4 Jul 2019 00:47:40 +0200

> The following pull-request contains BPF updates for your *net-next* tree.
> 
> There is a minor merge conflict in mlx5 due to 8960b38932be ("linux/dim:
> Rename externally used net_dim members") which has been pulled into your
> tree in the meantime, but resolution seems not that bad ... getting current
> bpf-next out now before there's coming more on mlx5. ;) I'm Cc'ing Saeed
> just so he's aware of the resolution below:
 ...

Thanks for the detailed merge resolution guidance, it helps a lot.

> Let me know if you run into any issues. Anyway, the main changes are:
 ...
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Pulled.
