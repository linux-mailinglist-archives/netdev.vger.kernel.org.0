Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF30429DEF9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403858AbgJ2A6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731582AbgJ1WRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9B90222D9;
        Wed, 28 Oct 2020 00:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603846471;
        bh=bd15X0ZO/kKl56YTZtPK2286ovxkGWRvjUY09nh7kq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L20IJGQtEtrEoLKXAHARu3Eqoz4drhMWZC/OnKcl8MOLELTjQqaxghn1LeYvApIY/
         vN4gel8NeDlz/iH/e0Bp9YTi+sOsaE18ZIp3689mKtyOTuOaX+FyejQ/DefkkPBu9f
         Yd/cSwI3PDj7pZC0vxW3vKMU2TWO4ZvBpCzyLd0E=
Date:   Tue, 27 Oct 2020 17:54:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Michal Suchanek <msuchanek@suse.de>, netdev@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cris Forno <cforno12@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ibmveth: Fix use of ibmveth in a bridge.
Message-ID: <20201027175430.1f6a74b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201026200407.fcf43678ba4cef7fe0cb7c98@suse.de>
References: <20201026104221.26570-1-msuchanek@suse.de>
        <20201026115237.21b114fe@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201026200407.fcf43678ba4cef7fe0cb7c98@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 20:04:07 +0100 Thomas Bogendoerfer wrote:
> > On Mon, 26 Oct 2020 11:42:21 +0100 Michal Suchanek wrote:  
> > > From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> > > 
> > > The check for src mac address in ibmveth_is_packet_unsupported is wrong.
> > > Commit 6f2275433a2f wanted to shut down messages for loopback packets,
> > > but now suppresses bridged frames, which are accepted by the hypervisor
> > > otherwise bridging won't work at all.
> > > 
> > > Fixes: 6f2275433a2f ("ibmveth: Detect unsupported packets before sending to the hypervisor")
> > > Signed-off-by: Michal Suchanek <msuchanek@suse.de>  
> > 
> > Since the From: line says Thomas we need a signoff from him.  
> 
> you can add
> 
> Signed-off-by: tbogendoerfer@suse.de

Applied, thanks.
