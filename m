Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4485625F067
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 21:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgIFTyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 15:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgIFTyA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 15:54:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E6D2208B3;
        Sun,  6 Sep 2020 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599422040;
        bh=oBKLczEV77qvBkz0mJGWX9SWJA35KC0/Ff6JsnS75+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IqDexc9OopTiNlPmkyHtBluvxD5NQ3BP9gq8/tpKP+k/YItX1qBcIgPW8Q+99YJa8
         fiw9GOKVDtAMwd+7l+Bmqz21e4gSE/cVI/QQDTN+p1vuHDqgemnNpxsj1YHgMjkXYN
         WQLB6hohGHHlMZ4ioPsoiRr/euBi1oOwPInQVxW0=
Date:   Sun, 6 Sep 2020 12:53:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     benve@cisco.com, govind@gmx.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] enic: switch from 'pci_' to 'dma_' API
Message-ID: <20200906125358.04be09a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200906124541.309003-1-christophe.jaillet@wanadoo.fr>
References: <20200906124541.309003-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  6 Sep 2020 14:45:41 +0200 Christophe JAILLET wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'vnic_dev_classifier()', 'vnic_dev_fw_info()',
> 'vnic_dev_notify_set()' and 'vnic_dev_stats_dump()' (vnic_dev.c) GFP_ATOMIC
> must be used because its callers take a spinlock before calling these
> functions.

Applied, thank you!
