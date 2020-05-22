Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB071DEE32
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgEVR17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730554AbgEVR17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 13:27:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDE46206C3;
        Fri, 22 May 2020 17:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590168479;
        bh=Ubl2ANeWaoKJylT1axYk0iaj/E62mtHqk13NUfe3RHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DdydeRkXtbJqEa1jZzELny9uhTToVfTokYicwQaDxl7w6oXB0na+IF9A8RzM5+pDg
         QrC9SqykQ9p+EvtzuTRUbe5N+ymfW9NN0Gs9/i5FegCxRsHpgk/EIUh27Id31c3CNk
         iScBN9QazgNCLUrwWfPlOkSNnvyEkvnAQ0WVz47E=
Date:   Fri, 22 May 2020 10:27:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v2 00/15][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-21
Message-ID: <20200522102756.1b9d3feb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
References: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 17:10:53 -0700 Jeff Kirsher wrote:
> This series contains updates to igc and e1000.
> 
> Andre cleans up code that was left over from the igb driver that handled
> MAC address filters based on the source address, which is not currently
> supported.  Simplifies the MAC address filtering code and prepare the
> igc driver for future source address support.  Updated the MAC address
> filter internal APIs to support filters based on source address.  Added
> support for Network Flow Classification (NFC) rules based on source MAC
> address.  Cleaned up the 'cookie' field which is not used anywhere in
> the code and cleaned up a wrapper function that was not needed.
> Simplified the filtering code for readability and aligned the ethtool
> functions, so that function names were consistent.
> 
> Alex provides a fix for e1000 to resolve a deadlock issue when NAPI is
> being disabled.
> 
> Sasha does additional cleanup of the igc driver of dead code that is not
> used or needed.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
