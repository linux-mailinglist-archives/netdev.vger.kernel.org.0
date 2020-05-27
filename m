Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4621E5134
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgE0Wcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 18:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgE0Wcu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 18:32:50 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99B3920707;
        Wed, 27 May 2020 22:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590618769;
        bh=G4KfFF72ZP/5iafEUV2q8lKQyCbx8/b35XY+5A9cvNQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jyaXf8FdBYU9duz7kEKkk1yUTz7JYaMxE2uttEDtNxwEurGmlBsdulgQ2NIFwX7OE
         smRm+22fPto1IJU8f0U3Ag/sEvZWifT7uj3xAWE89zoSaNYpO8MORE+D7NSxPA8Tdp
         wVoYdNppLgBQJ9LjEBr1YPJYfLWkPpHXCTv11Zr8=
Date:   Wed, 27 May 2020 15:32:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Boris Pismenny <borisp@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next] net/tls: Add force_resync for driver resync
Message-ID: <20200527153248.53965eee@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527092526.3657-1-tariqt@mellanox.com>
References: <20200527092526.3657-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 12:25:26 +0300 Tariq Toukan wrote:
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

Please document this, in tls-offload.rst.
