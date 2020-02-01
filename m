Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C560714FA55
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgBATl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgBATl6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 14:41:58 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AAB6205F4;
        Sat,  1 Feb 2020 19:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580586117;
        bh=THUAKBWjKggEytL4zH1vRB3o3bIqYaHUSzP4CYfxoXY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XTuDV9Ji6Wbz5Z0kNqmiMileyoqWKJ8LtUrkyLn6y9gi+z3VmS58iVBiY2kVzhRlr
         WO4NRer/Oo2KrJF1jYGxI70gHa0ioLVHT1pp7L1k3d5WTLcpzf/GsuRe6mGCQ3a8do
         6zzRl6gH9/Mn5aDB4lnWcM7vMTB19w3IyGw5j5CI=
Date:   Sat, 1 Feb 2020 11:41:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] qed: Fix a error code in qed_hw_init()
Message-ID: <20200201114156.33e77496@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200131050326.n3axoo7axxvzcrv3@kili.mountain>
References: <20200131050326.n3axoo7axxvzcrv3@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 08:03:26 +0300, Dan Carpenter wrote:
> If the qed_fw_overlay_mem_alloc() then we should return -ENOMEM instead
> of success.
> 
> Fixes: 30d5f85895fa ("qed: FW 8.42.2.0 Add fw overlay feature")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks Dan!
