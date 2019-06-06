Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCC837F4B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfFFVOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:14:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFVN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:13:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 68DF914E14FC3;
        Thu,  6 Jun 2019 14:13:59 -0700 (PDT)
Date:   Thu, 06 Jun 2019 14:13:58 -0700 (PDT)
Message-Id: <20190606.141358.1771495306166670685.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net-next 00/13] nfp: tls: add basic TX offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 14:13:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed,  5 Jun 2019 14:11:30 -0700

> This series adds initial TLS offload support to the nfp driver.
> Only TX side is added for now.  We need minor adjustments to
> the core tls code:
>  - expose the per-skb fallback helper;
>  - grow the driver context slightly;
>  - add a helper to get to the driver state more easily.
> We only support TX offload for now, and only if all packets
> keep coming in order.  For retransmissions we use the
> aforementioned software fallback, and in case there are
> local drops we completely give up on given TCP stream.
> 
> This will obviously be improved soon, this patch set is the
> minimal, functional yet easily reviewable chunk.

Series applied, thanks Jakub.
