Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D97222F55
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgGPXpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgGPXpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:45:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AD562089D;
        Thu, 16 Jul 2020 22:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594938561;
        bh=lJAuFaP/boMTQF/Myn/WDJz7XFJtcefOVcVKvpBPn/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1gjsbJc8m/d5EwvGMVpVgpi5L1GAh0i+eb6zQ7f3xRyf556kdCCrkQNKugYZbzT+0
         Ly2DZ0OOrG+E84JmDP3f9xgitb2QerAuGBeCLo15zZqyB4eYhBx3pbDveNqgwD8+bi
         qUQrNsNy3OZE76n1o3e2fUi9NORcKx5L3KpLvR1A=
Date:   Thu, 16 Jul 2020 15:29:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 3/3] net: mscc: ocelot: add support for PTP
 waveform configuration
Message-ID: <20200716152919.6ef79fc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716213622.zlsmaz56io4d6vgl@skbuf>
References: <20200716212032.1024188-1-olteanv@gmail.com>
        <20200716212032.1024188-4-olteanv@gmail.com>
        <20200716213622.zlsmaz56io4d6vgl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 00:36:22 +0300 Vladimir Oltean wrote:
> which I used for testing until I exposed this into an ioctl. I knew I
> forgot to do something, and that was to squash that patch into this one.
> So I'll need to send a v2, because otherwise this doesn't apply to
> mainline. Please review taking this into consideration.

Ah, only noticed this now.
