Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF00139F57
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 03:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbgANCL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 21:11:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729267AbgANCL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 21:11:26 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 567032084D;
        Tue, 14 Jan 2020 02:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578967885;
        bh=do5/8tFpn1ftLUvZwyUqzgM9B0niq1R6m6pOUjQ0/80=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IpaIwk3WDUpIeKFCE9T5FxE1agvvp2YmMJBCqSqzMYMI+7O6ty170bTQlOP7iyuRz
         r2awuX6Ecz6vi8WQVwoGPArRk4WRL7fXPEuGUwtN+SlzjIZGOgslQapQIrg8Y3LwIw
         q/D7A4BhWLPW6nBrZIhEdDDKeog+2ICOHZ41kFjc=
Date:   Mon, 13 Jan 2020 18:11:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        brouer@redhat.com, davem@davemloft.net, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200113181120.0e1bd4ba@cakuba>
In-Reply-To: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
References: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 14:57:44 +0100, Lorenzo Bianconi wrote:
> Socionext driver can run on dma coherent and non-coherent devices.
> Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
> now the driver can let page_pool API to managed needed DMA sync
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Looks like this is good to be applied, after all. Could you fix
the misaligned continuation lines (checkpatch will guide you to them)
and repost (giving folks last chance to object)?
