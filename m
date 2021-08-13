Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A6C3EBBE5
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 20:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhHMSOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 14:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhHMSOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 14:14:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEE70610CC;
        Fri, 13 Aug 2021 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628878448;
        bh=pYf2UEh5Nm0666CPs41LWTiFp2UMvV32qks8VGI+LTo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C4sEO6yfVYGNZvCqvyTXxh4VRObBcvX8XDPKAdbqjYDHZVhbdhwojyD4gSU31cEY+
         ZaP3+G1EMAymx+WiaLLu069BfSlzfjFBIlAMbMRqEfdk7wK8Zjs+DP4Q/pe9umBOha
         qa1TYpete7IIkAgnBMfOVB6STmwXjC2uPS4m/rMVWyLHz0lcjDMWevFwydupPKgv4o
         SiVVV0m1XFO01c3jeJKtLteWmuEiv7wB7MH3KOJ7eq8/LFSMOEUvxFjfoCHNAPGE97
         FY91HmJlha07OFi77n0EyC3h/3ygPqIieQYTY3p/oV7Owi3v7+E0zvd3soKMfGGzYV
         Z5WssmdTkDX4Q==
Date:   Fri, 13 Aug 2021 11:14:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 net-next 1/3] ptp_ocp: Switch to use
 module_pci_driver() macro
Message-ID: <20210813111407.0c2288f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com>
References: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Aug 2021 15:27:35 +0300 Andy Shevchenko wrote:
> Eliminate some boilerplate code by using module_pci_driver() instead of
> init/exit, and, if needed, moving the salient bits from init into probe.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Jonathan has a series in flight which is fixing some of the same issues:
https://patchwork.kernel.org/project/netdevbpf/list/?series=530079&state=*

Please hold off for a day or two so it can get merged, and if you don't
mind double check at that point which of your patches are still needed.

According to patchwork your series does not apply to net-next as of
last night so it'll need a respin anyway.

Thanks!
