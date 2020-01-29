Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4961F14CB04
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 13:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgA2M7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 07:59:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgA2M7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 07:59:37 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7238814C16B21;
        Wed, 29 Jan 2020 04:59:35 -0800 (PST)
Date:   Wed, 29 Jan 2020 13:59:31 +0100 (CET)
Message-Id: <20200129.135931.874705887000597696.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        sven.auhagen@voleatech.de, andrew@lunn.ch
Subject: Re: [PATCH net] net: mvneta: fix XDP support if sw bm is used as
 fallback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <50f682e9e1f835011df18e08c837e61a0b579c15.1580296745.git.lorenzo@kernel.org>
References: <50f682e9e1f835011df18e08c837e61a0b579c15.1580296745.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 04:59:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Wed, 29 Jan 2020 12:50:53 +0100

> In order to fix XDP support if sw buffer management is used as fallback
> for hw bm devices, define MVNETA_SKB_HEADROOM as maximum between
> XDP_PACKET_HEADROOM and NET_SKB_PAD and let the hw aligns the IP header
> to 4-byte boundary.
> Fix rx_offset_correction initialization if mvneta_bm_port_init fails in
> mvneta_resume routine
> 
> Fixes: 0db51da7a8e9 ("net: mvneta: add basic XDP support")
> Tested-by: Sven Auhagen <sven.auhagen@voleatech.de>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied and queued up for v5.5 -stable, thanks.
