Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E8C1DBBE3
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgETRsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgETRsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 13:48:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F8DC206BE;
        Wed, 20 May 2020 17:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589996902;
        bh=4ieD8YRK2PImWhRibMI6y/F4XeiEGYiD34shQLWceps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=y3jKNsYocbMm19AhL4guUv1Aks4ozZNxjPC9BGKqPVHEHeYrYeLdRKIFHpraEpgeD
         qfnQxbHtmqlJdwbTXFjvkPsHeXXQXLvr4bOJXb0YKavoqDxha9VkHdiql+9GY87Qt5
         EZwDx0v2TlpvDuoJT90X+XckygltyLaeWbn3o1Wg=
Date:   Wed, 20 May 2020 10:48:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andre Guedes <andre.guedes@intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-19
Message-ID: <20200520104820.6e6b9506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <158999658919.45243.7209081350174716035@djmeffe-mobl1.amr.corp.intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
        <20200519190026.5334f3c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <158999658919.45243.7209081350174716035@djmeffe-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 10:43:09 -0700 Andre Guedes wrote:
> Quoting Jakub Kicinski (2020-05-19 19:00:26)
> > On Tue, 19 May 2020 17:04:05 -0700 Jeff Kirsher wrote:  
> > > This series contains updates to igc only.
> > > 
> > > Sasha cleans up the igc driver code that is not used or needed.
> > > 
> > > Vitaly cleans up driver code that was used to support Virtualization on
> > > a device that is not supported by igc, so remove the dead code.
> > > 
> > > Andre renames a few macros to align with register and field names
> > > described in the data sheet.  Also adds the VLAN Priority Queue Fliter
> > > and EType Queue Filter registers to the list of registers dumped by
> > > igc_get_regs().  Added additional debug messages and updated return codes
> > > for unsupported features.  Refactored the VLAN priority filtering code to
> > > move the core logic into igc_main.c.  Cleaned up duplicate code and
> > > useless code.  
> > 
> > No automated warnings :)
> > 
> > It's a little strange how both TCI and ETYPE filters take the queue ID.
> > Looking at the code it's not immediately clear which one take
> > precedence. Can I install two rules for the same TCI and different ETYPE
> > or vice versa?  
> 
> Although the driver currently accepts such rules, they don't work as expected
> (as you probably noticed already). Jeff has already a patch in his queue
> fixing this issue.

Okay, looking forward to those fixes.

Acked-by: Jakub Kicinski <kuba@kernel.org>

> And just clarifying, ETYPE filters precede VLAN priority filters.

