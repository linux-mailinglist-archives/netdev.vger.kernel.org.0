Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F4B46704A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378230AbhLCCzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:55:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49974 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243536AbhLCCzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:55:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85252B825A5;
        Fri,  3 Dec 2021 02:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00D6C00446;
        Fri,  3 Dec 2021 02:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638499897;
        bh=SPyWCI8ZuPK4KnQdtSifu2zrWu2175zpw89LiBJE9qE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gZ4p7GvY5pv+BrYDsURNHh+DbsdYNX25UFmQuBoPNAzSPqZU8IeDD2xByrrK3p2V/
         b5pl/+KBiErbBMBuUjNOyJsemGPB71AL8WeOddXp5Sg7sCAJu96uWnOOWVwmRP9PHK
         Hj7EHVoUhdjjJ3BMdPi7QE+TAF4OIZ88UNoTPgfE+Sa+AHtKQ0hsrxTTEYRk25hw34
         eB4eyyg9H9hBs6IzxssWyOEAUyO4esUCYjeexvQIWQuWs0rykgbAnJfjql7vkoDhv6
         S2gitia4NfJNRWHPOsaNhkqlJOmSVL0TWqi9Wd2l0iFC0BhUhl1ULBJMmNF3g95AoY
         Uf7Pes7OL4giw==
Date:   Thu, 2 Dec 2021 18:51:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: broadcom: Catch the Exception
Message-ID: <20211202185135.5b1f4d1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211203012615.1512601-1-jiasheng@iscas.ac.cn>
References: <20211203012615.1512601-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Dec 2021 09:26:15 +0800 Jiasheng Jiang wrote:
> The return value of dma_set_coherent_mask() is not always 0.
> To catch the exception in case that dma is not support the mask.
> 
> Fixes: 9d61d138ab30 ("net: broadcom: rename BCM4908 driver & update DT
> binding")

Please don't line wrap the Fixes tags.

Please CC Florian as he reviewed the original patch.

Repost with those changes made. 

Thanks!
