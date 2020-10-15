Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD08328F752
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389959AbgJOQ7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388946AbgJOQ7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:59:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 510A3206CA;
        Thu, 15 Oct 2020 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602781176;
        bh=ujL9oNNWzVMk05DMcn2bzsxOL16HuGiZa0KEqe1bElg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DydYbh7bfc69lQmuP8e3KBRQXUxds4sygAzWYMMCfxzn+pj+3Rxdu0Oj/ELqbn6cz
         jWsCKG3GDbKfmz+8qvSVUp3JJrpnijrZgwU2OvGPgTYuws/neOyf9vg08e+nRlaFej
         6610XI6WwAiHG7BLf/BznBXEyk4zL9HtwvGtvv9U=
Date:   Thu, 15 Oct 2020 09:59:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        raspl@linux.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/3] net/smc: fixes 2020-10-14
Message-ID: <20201015095934.72b09e9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014174329.35791-1-kgraul@linux.ibm.com>
References: <20201014174329.35791-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 19:43:26 +0200 Karsten Graul wrote:
> Please apply the following patch series for smc to netdev's net tree.
> 
> The first patch fixes a possible use-after-free of delayed llc events.
> Patch 2 corrects the number of DMB buffer sizes. And patch 3 ensures
> a correctly formatted return code when smc_ism_register_dmb() fails to
> create a new DMB.

Applied and queued for stable, thanks!
