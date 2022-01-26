Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B1649C24D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiAZDum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:50:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47740 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiAZDul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:50:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2016861551;
        Wed, 26 Jan 2022 03:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2750EC340E3;
        Wed, 26 Jan 2022 03:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643169040;
        bh=bUEyqTE3wW9PTA5v+s//0JwnrjvPDueySOlPKcGveMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uT40UsbOUxWQBJx7pcrLRGQ6cEUB8SvUbMXmBhQAlJ3YVxWJG/3euMGOzWzugyqPk
         HFUtZcLlHcVixKhBOpuevndO1cnYsBUJ8sKvValnDMV3Z2B8A6v+K6UKfKyIvaih5o
         7WF6U1Gwqy/Eqji+nwc9pZExP5dE3kj91QF0u612GKAf613oh1PXU9CwPLAnW5Z0Bp
         y2hTWTbmHpjaZdSJUX/53LiYFBHMJYKWdsUJrQNrMY8X3u4n+ddPvDDspGOU3qNh9i
         mqRCUv7jUnQCdD7ZjpoVvMtrxoI5ZfRVY/qiAqr6AfPdMbmD/4B/aNqS4VM2Hvh+/3
         4INpy9hMQQvVQ==
Date:   Tue, 25 Jan 2022 19:50:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <wangjie125@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
Subject: Re: [RESEND PATCH net-next 1/2] net: hns3: add support for TX push
 mode
Message-ID: <20220125195038.6a07b3c4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125072149.56604-2-huangguangbin2@huawei.com>
References: <20220125072149.56604-1-huangguangbin2@huawei.com>
        <20220125072149.56604-2-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 15:21:48 +0800 Guangbin Huang wrote:
> +	__iowrite64_copy(ring->tqp->mem_base, desc,
> +			 (sizeof(struct hns3_desc) * HNS3_MAX_PUSH_BD_NUM) /
> +			 HNS3_BYTES_PER_64BIT);

Doesn't build, missing closing bracket?
