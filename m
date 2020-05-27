Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988381E50EA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgE0WH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 18:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgE0WH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 18:07:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3C4C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 15:07:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 52C87128CEF75;
        Wed, 27 May 2020 15:07:27 -0700 (PDT)
Date:   Wed, 27 May 2020 15:07:26 -0700 (PDT)
Message-Id: <20200527.150726.628683182159628508.davem@davemloft.net>
To:     tariqt@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, borisp@mellanox.com,
        maximmi@mellanox.com, saeedm@mellanox.com
Subject: Re: [PATCH net-next] net/tls: Add force_resync for driver resync
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527092526.3657-1-tariqt@mellanox.com>
References: <20200527092526.3657-1-tariqt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 15:07:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>
Date: Wed, 27 May 2020 12:25:26 +0300

> This patch adds a field to the tls rx offload context which enables
> drivers to force a send_resync call.
> 
> This field can be used by drivers to request a resync at the next
> possible tls record. It is beneficial for hardware that provides the
> resync sequence number asynchronously. In such cases, the packet that
> triggered the resync does not contain the information required for a
> resync. Instead, the driver requests resync for all the following
> TLS record until the asynchronous notification with the resync request
> TCP sequence arrives.
> 
> A following series for mlx5e ConnectX-6DX TLS RX offload support will
> use this mechanism.
> 
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

Applied, thanks.
