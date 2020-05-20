Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA861DBBC7
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgETRnL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 13:43:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:44449 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgETRnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 13:43:11 -0400
IronPort-SDR: hjMODPIdTvndMAWglcv+qTKyoKUwG8Q9kdUagLGIQNYylXjg9RGN4gbM3HhcOqc4pbXXLDi+j9
 w1H46YkUl1kQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 10:43:10 -0700
IronPort-SDR: ZV6cf8hus1y348MdpciDSmsxq3eL2jtoDwZbCSH7OmgGc/ByDXupznDnulgS425v7QIt+jZvrb
 6ipVkFbs2WLQ==
X-IronPort-AV: E=Sophos;i="5.73,414,1583222400"; 
   d="scan'208";a="253735289"
Received: from djmeffe-mobl1.amr.corp.intel.com (HELO localhost) ([10.255.230.216])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 10:43:10 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200519190026.5334f3c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com> <20200519190026.5334f3c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver Updates 2020-05-19
From:   Andre Guedes <andre.guedes@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
To:     Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date:   Wed, 20 May 2020 10:43:09 -0700
Message-ID: <158999658919.45243.7209081350174716035@djmeffe-mobl1.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Quoting Jakub Kicinski (2020-05-19 19:00:26)
> On Tue, 19 May 2020 17:04:05 -0700 Jeff Kirsher wrote:
> > This series contains updates to igc only.
> > 
> > Sasha cleans up the igc driver code that is not used or needed.
> > 
> > Vitaly cleans up driver code that was used to support Virtualization on
> > a device that is not supported by igc, so remove the dead code.
> > 
> > Andre renames a few macros to align with register and field names
> > described in the data sheet.  Also adds the VLAN Priority Queue Fliter
> > and EType Queue Filter registers to the list of registers dumped by
> > igc_get_regs().  Added additional debug messages and updated return codes
> > for unsupported features.  Refactored the VLAN priority filtering code to
> > move the core logic into igc_main.c.  Cleaned up duplicate code and
> > useless code.
> 
> No automated warnings :)
> 
> It's a little strange how both TCI and ETYPE filters take the queue ID.
> Looking at the code it's not immediately clear which one take
> precedence. Can I install two rules for the same TCI and different ETYPE
> or vice versa?

Although the driver currently accepts such rules, they don't work as expected
(as you probably noticed already). Jeff has already a patch in his queue
fixing this issue.

And just clarifying, ETYPE filters precede VLAN priority filters.

Regards,

Andre
