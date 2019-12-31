Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5109E12D59D
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 02:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfLaBwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 20:52:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49936 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfLaBwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 20:52:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6F411556051F;
        Mon, 30 Dec 2019 17:52:37 -0800 (PST)
Date:   Mon, 30 Dec 2019 17:52:35 -0800 (PST)
Message-Id: <20191230.175235.1109525824306658097.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     linux-net-drivers@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] sfc: avoid duplicate error handling code in
 'efx_ef10_sriov_set_vf_mac()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191226150224.8701-1-christophe.jaillet@wanadoo.fr>
References: <20191226150224.8701-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 17:52:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Thu, 26 Dec 2019 16:02:24 +0100

> 'eth_zero_addr()' is already called in the error handling path. This is
> harmless, but there is no point in calling it twice, so remove one.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied to net-next, thank you.
