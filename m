Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A4DF0C11
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbfKFCeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:34:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42352 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFCeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:34:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85EB11510CDEE;
        Tue,  5 Nov 2019 18:34:19 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:34:19 -0800 (PST)
Message-Id: <20191105.183419.190417522967170590.davem@davemloft.net>
To:     tariqt@mellanox.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        saeedm@mellanox.com
Subject: Re: [PATCH net V2] Documentation: TLS: Add missing counter
 description
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105121348.12956-1-tariqt@mellanox.com>
References: <20191105121348.12956-1-tariqt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:34:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>
Date: Tue,  5 Nov 2019 14:13:48 +0200

> Add TLS TX counter description for the handshake retransmitted
> packets that triggers the resync procedure then skip it, going
> into the regular transmit flow.
> 
> Fixes: 46a3ea98074e ("net/mlx5e: kTLS, Enhance TX resync flow")
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Applied
