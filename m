Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AED2F9035
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbhAQC2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 21:28:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbhAQC2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 21:28:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8E5C223E8;
        Sun, 17 Jan 2021 02:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610850487;
        bh=THWpwXbk8mB4B1FxqgJVaX8Upp+yuwgXFub7WnDkQII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H2F7fbmePkA4AnDokYKYRBTMTztEwMERLRF8EB8bd0oYX6bdVeATSLncpr6jUk7V+
         gkjOh3U6mJfmWpo6dfBWzB46Ubwmm9pX8kbSGSo8YZv9CRp2gPL9yKCJWun+tRna+c
         +As+wViN0ZdckYx1kgcIdjuSTISdl3eqbPf3Cd1WnYP6NuzTw2SvP38dYk0MLQQ6B0
         eG7IDDi1QpVsB/Zk+e+V7Dd+ErHruELI0QUBmwBctyjwPajYluOznOxqmA80nAlaAR
         FP+oBySgL3wfMrk2xF5ngVLFf6iuHNbLD9i2kAUwPfjCso6xOfxPnmqLcZKWdNx9Qi
         YXq+PC+S/yW+w==
Date:   Sat, 16 Jan 2021 18:28:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bhaskar Upadhaya <bupadhaya@marvell.com>
Cc:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
Subject: Re: [PATCH net-next 3/3] qede: set default per queue rx/tx usecs
 coalescing parameters
Message-ID: <20210116182806.625c540e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610701570-29496-4-git-send-email-bupadhaya@marvell.com>
References: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
        <1610701570-29496-4-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 01:06:10 -0800 Bhaskar Upadhaya wrote:
> Here we do the initialization of coalescing values on load.
> Although the default device values are the same - explicit
> config is better visible.

Can you also make the driver store the settings across ifdown / ifup
and allow the settings to be checked while the interface is down, 
while at it?
