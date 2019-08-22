Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D5498A2F
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 06:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfHVEJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 00:09:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfHVEJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 00:09:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 915CC15247F14;
        Wed, 21 Aug 2019 21:09:08 -0700 (PDT)
Date:   Wed, 21 Aug 2019 21:09:07 -0700 (PDT)
Message-Id: <20190821.210907.884869474698105971.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, saeedm@mellanox.com, leon@kernel.org,
        eranbe@mellanox.com, lorenzo.pieralisi@arm.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kys@microsoft.com, sthemmin@microsoft.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next,v3, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566346948-69497-1-git-send-email-haiyangz@microsoft.com>
References: <1566346948-69497-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 21:09:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 21 Aug 2019 00:23:19 +0000

> This patch set adds paravirtual backchannel in software in pci_hyperv,
> which is required by the mlx5e driver HV VHCA stats agent.
> 
> The stats agent is responsible on running a periodic rx/tx packets/bytes
> stats update.

These patches don't apply cleanly to net-next, probably due to some recent
mlx5 driver changes.

Please respin.
