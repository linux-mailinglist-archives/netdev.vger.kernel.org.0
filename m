Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB7F42CF44
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 01:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhJMXmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 19:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhJMXmt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 19:42:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1DDF610FE;
        Wed, 13 Oct 2021 23:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634168446;
        bh=+kWEokZK4ZXtke5N8xJitfx/X2TAQbwwTqQUiwOxpDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GMaEvca3Z/ixkxaQFoWtrpXl9XafpaoGFX2rIaqDVfYR+tzHagS6/3gZAxlT+WMeu
         zAUsuMc5kxDwWLBiGwyFY8Z5dpLm0XNZZGSUoBKEdy+qFVhP31b5l4xgJBsvwcERDt
         3gaEP9+bGBP+TQnVlWvs0GXMTeLb3Td7nyavx/KmVoW0MxaLW/wQjVX9RXgOs2K+sw
         cot7sdKjQxboX3IUi8sBhiNCGQfW6t0B17kQtvAv36Er1YcFgPE3f3bkhcLax5fvIl
         UUgy7eK4FIoCDE8T+4qCR0zAf0IKf321HHWgvelHX4pWA61SBqVwHDtmPB+O56Xy5P
         DmikvqF9W8BZw==
Date:   Wed, 13 Oct 2021 16:40:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Prestwood <prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
Message-ID: <20211013164044.33178f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013163714.63abdd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
        <20211013163714.63abdd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 16:37:14 -0700 Jakub Kicinski wrote:
> Please make sure you run ./scripts/get_maintainers.pl on the patch
> and add appropriate folks to CC.

Ah, and beyond that please make sure to CC wireless folks.
The linux-wireless mailing list, Johannes, Jouni, etc.
The question of the "real root cause" is slightly under-explained.
Sounds like something restores carrier before the device is actually up.
