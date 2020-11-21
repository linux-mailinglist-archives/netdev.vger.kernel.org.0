Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C552BBCCD
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgKUDwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgKUDwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 22:52:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 017F322269;
        Sat, 21 Nov 2020 03:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605930767;
        bh=50xL13QWys/2TwMmcLztBlckytj8sEvIsO0Oy/i5qWw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EegFuB2M94d1/gOFCRaJgmbp3glUdyWPshL0zqqvBC750lZ5yHjlMoHWHvCKlmgYL
         ImoNZ6/YP7L1rqo12tOGjTgjeJ7ZuvqJNy4aD58IQ0httk9Z+CtB+wrjPaONLec2JR
         IO6DiOJ3+rZOzcJGX5ssDKnJ1b+xCWCZIVGAjv7k=
Date:   Fri, 20 Nov 2020 19:52:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cforno12@linux.ibm.com, ljp@linux.vnet.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com
Subject: Re: [PATCH net-next v2 0/9] ibmvnic: Performance improvements and
 other updates
Message-ID: <20201120195246.18533062@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 19:12:16 -0600 Thomas Falcon wrote:
> The first three patches utilize a hypervisor call allowing multiple 
> TX and RX buffer replenishment descriptors to be sent in one operation,
> which significantly reduces hypervisor call overhead. The xmit_more
> and Byte Queue Limit API's are leveraged to provide this support
> for TX descriptors.
> 
> The subsequent two patches remove superfluous code and members in
> TX completion handling function and TX buffer structure, respectively,
> and remove unused routines.
> 
> Finally, four patches which ensure that device queue memory is
> cache-line aligned, resolving slowdowns observed in PCI traces,
> as well as optimize the driver's NAPI polling function and 
> to RX buffer replenishment are provided by Dwip Banerjee.
> 
> This series provides significant performance improvements, allowing
> the driver to fully utilize 100Gb NIC's.

Applied, thanks!
