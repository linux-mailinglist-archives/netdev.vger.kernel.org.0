Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AAC2E9F82
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbhADV0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbhADV0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:26:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7464216C4;
        Mon,  4 Jan 2021 21:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609795572;
        bh=vUKbmWW7gR9LF1YaYghwwDlkadkMy6wpuNgwZq9cC4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zyb7gFx7Qf0AQnIrr2QxtMxq5qqjFepsWUvTgDHl2inpp+gaGZdyNpJz51SyI79MR
         TYEMBvTIHQvv+plTvrRp+aWL/2hjOsCytqjLyVsesxGx9YUbgXEXx9jAgLorfMZyvQ
         OQcwOJ0S1YRzQ9fQAcNSLnhmH891gJ2CrLK96I3nhsUjfupMuTiiH7GKQ5aUZlKIIY
         Smz7XGOKF2wc8YAQKg88MGRqBkMNrXoXb7OpnKYJJRHt1CWh9QgcYDzGdEzY5KeWP8
         swcLovMsECGJ/vJrfvW22JFsPUdxSeyOA50nGOvc+gKdrDzuYj0gkABAxdV6pQ4370
         HuSqcmuWgwGCw==
Date:   Mon, 4 Jan 2021 13:26:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyingjie55@126.com
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] af/rvu_cgx: Fix missing check bugs in rvu_cgx.c
Message-ID: <20210104132610.6d7e3578@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1609313066-5353-1-git-send-email-wangyingjie55@126.com>
References: <1609313066-5353-1-git-send-email-wangyingjie55@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Dec 2020 23:24:26 -0800 wangyingjie55@126.com wrote:
> From: Yingjie Wang <wangyingjie55@126.com>
> 
> In rvu_mbox_handler_cgx_mac_addr_get() and rvu_mbox_handler_cgx_mac_addr_set(),
> the msg is expected only from PFs that are mapped to CGX LMACs.
> It should be checked before mapping, so we add the is_cgx_config_permitted() in the functions.
> 
> Signed-off-by: Yingjie Wang <wangyingjie55@126.com>

Please include an appropriate Fixes tag and repost, thanks!
