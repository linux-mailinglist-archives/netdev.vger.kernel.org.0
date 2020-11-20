Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72CD2BB8F2
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgKTWWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:22:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:32916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgKTWWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 17:22:52 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F12F2245F;
        Fri, 20 Nov 2020 22:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605910971;
        bh=GXSWj2zD4d6BED+9vU8TZXtAdQRsiEy3qrU6qzRml64=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ARfSjSvc/OgWn987P8GjCgHauGJFj8OZkWo/TRTkm38BAQN/f9eJ0jH8+GvTHs4Mf
         tqd2oKObaYziga5USrLQGMMSowZleOvZVJS2XEzfiXPinVswZYpfmfd+b1VjFrX/g9
         41PYh2DWqAkx07Fuik23DG2wXmOeoAJSwFMb2c3g=
Date:   Fri, 20 Nov 2020 14:22:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v6 0/6] netdevsim: add ethtool coalesce and
 ring settings
Message-ID: <20201120142250.6008acf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201118204522.5660-1-acardace@redhat.com>
References: <20201118204522.5660-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 21:45:16 +0100 Antonio Cardace wrote:
> Output of ethtool-ring.sh and ethtool-coalesce.sh selftests:
> 
> # ./ethtool-ring.sh
> PASSED all 4 checks
> # ./ethtool-coalesce.sh
> PASSED all 22 checks
> # ./ethtool-pause.sh
> PASSED all 7 checks
> 
> Changelog v5 -> v6
> - moved some bits from patch 3, they
>   were part of a refactoring made in patch 2

Applied, thanks!
