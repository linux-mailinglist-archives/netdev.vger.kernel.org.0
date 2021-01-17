Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D6C2F8FF5
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 01:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbhAQArZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 19:47:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbhAQArY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 19:47:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3101D207B6;
        Sun, 17 Jan 2021 00:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610844403;
        bh=LXcb55zAQbGkBOVJb24dn4h2LrxG+4xK5GkqZylNRS0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KOVd01MX9A4dTCU3HMsSGcd5ukJ9Rp7KGvvuRYA9VaKVezQl4AaWzjoUZc14CLrvD
         VH4iNxtla/MgMMyTXKelrRfQXVrVHu4F3wYAIIIgjvadAop22ESUhDKfH2OFGQX7Ib
         8pD4NFtSvkC0ryUURyiLNvLXXGfWoipRPttWsFlnaHrzHyNSQC1yMhaMKMbAVKLv8/
         r8ZJPiuds0UETkXFwBHOTVqrJUutz7pOr9HvhtuSbrWLT16DXpqmfMTTSAVfe6CSIa
         QyMMc0KsUAMpNuza5+vINcQPKSmRZ/3zOURsj6iA2RfRihyjTWi2DsUXYvvgfuxUlH
         nAHvSCqDhMSTw==
Date:   Sat, 16 Jan 2021 16:46:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pravin B Shelar <pbshelar@fb.com>
Cc:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        <laforge@gnumonks.org>, <jonas@norrbonn.se>
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling
 API
Message-ID: <20210116164642.4af4de8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210110070021.26822-1-pbshelar@fb.com>
References: <20210110070021.26822-1-pbshelar@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 Jan 2021 23:00:21 -0800 Pravin B Shelar wrote:
> Following patch add support for flow based tunneling API
> to send and recv GTP tunnel packet over tunnel metadata API.
> This would allow this device integration with OVS or eBPF using
> flow based tunneling APIs.
> 
> Signed-off-by: Pravin B Shelar <pbshelar@fb.com>

Applied, thanks!
