Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7D72995C5
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790476AbgJZSwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790466AbgJZSwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 14:52:39 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FB9207E8;
        Mon, 26 Oct 2020 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603738359;
        bh=t2EQbcyl5c3xdLTzNkFpT08fzGpuuYyPqlb0/xDd3r4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JckPPeS6Q4j3QYgNH76zNGhEI+P2JRsz0T+do+ZJ0jXBaGM/h3iWH2jzj+1PmQ4yh
         qsl/JLRqufoBVgCw8TWFwiDAnMyBF0gzRXIKT8uv0Gm8e5QCTQZuBT9ARs90+bIeoM
         jA3gBYtw+K4gukXB97CGMg0jaj6i8HzU5aol5USc=
Date:   Mon, 26 Oct 2020 11:52:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        netdev@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cris Forno <cforno12@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ibmveth: Fix use of ibmveth in a bridge.
Message-ID: <20201026115237.21b114fe@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201026104221.26570-1-msuchanek@suse.de>
References: <20201026104221.26570-1-msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 11:42:21 +0100 Michal Suchanek wrote:
> From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> 
> The check for src mac address in ibmveth_is_packet_unsupported is wrong.
> Commit 6f2275433a2f wanted to shut down messages for loopback packets,
> but now suppresses bridged frames, which are accepted by the hypervisor
> otherwise bridging won't work at all.
> 
> Fixes: 6f2275433a2f ("ibmveth: Detect unsupported packets before sending to the hypervisor")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

Since the From: line says Thomas we need a signoff from him.
