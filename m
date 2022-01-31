Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593974A4C54
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380400AbiAaQlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:41:31 -0500
Received: from elvis.franken.de ([193.175.24.41]:49232 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379067AbiAaQla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 11:41:30 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1nEZk7-000514-00; Mon, 31 Jan 2022 17:41:27 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 5D8BDC1F70; Mon, 31 Jan 2022 17:41:05 +0100 (CET)
Date:   Mon, 31 Jan 2022 17:41:05 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>
Subject: Re: [PATCH net] net: e1000e: Recover at least in-memory copy of NVM
 checksum
Message-ID: <20220131164105.GA29636@alpha.franken.de>
References: <20220127150807.26448-1-tbogendoerfer@suse.de>
 <d32ac7da-f460-6d7a-5f7f-9c9d873bf393@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d32ac7da-f460-6d7a-5f7f-9c9d873bf393@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 12:51:07PM +0200, Neftin, Sasha wrote:
> Hello Thomas,
> For security reasons starting from the TGL platform SPI controller will be
> locked for SW access. I've double-checked with our HW architect, not from
> SPT, from TGP. So, first, we can change the mac type e1000_pch_cnp to
> e1000_pch_tgp (as fix for initial patch)

ok, that would fix the mentioned bug. Are you sending a patch for that ?

> Do we want (second) to allow HW initialization with the "wrong" NVM
> checksum? It could cause unexpected (HW) behavior in the future. Even if you
> will "recover" check in shadow RAM - there is no guarantee that NVM is good.

sure. Out of curiosity why is the NVM fixup there in the first place ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
