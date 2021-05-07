Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15D4376C7C
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhEGWYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:24:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:49034 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhEGWYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 18:24:45 -0400
IronPort-SDR: pxGI/b5jc5C+UB/X2s9zski/IIzudOx/MWp8feNNbAG2gcMaz4XbO99DThgieXSQbc6p1CRV03
 JH8loTJyjqug==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="185955807"
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; 
   d="scan'208";a="185955807"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 15:23:43 -0700
IronPort-SDR: wu49lprSn5yTXAGJGa/jXtNxLz73g2TkT2oI8klxsHLSzVmhpbbVNNwUFcg88TjEQZjkucXt0c
 BjWEO+1v3GSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; 
   d="scan'208";a="533849261"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 07 May 2021 15:23:41 -0700
Date:   Sat, 8 May 2021 00:11:35 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Cristian Dumitrescu <cristian.dumitrescu@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        edwin.verplanke@intel.com
Subject: Re: [PATCH net-next 0/4] i40e: small improvements on XDP path
Message-ID: <20210507221135.GB18159@ranger.igk.intel.com>
References: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
 <CAJ8uoz3YSuPj6F+GHkk6yXHryUEOUhVSg2pDVEVrFA6b8Hgu6g@mail.gmail.com>
 <20210118103233.49bfd205@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118103233.49bfd205@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 10:32:33AM -0800, Jakub Kicinski wrote:
> On Mon, 18 Jan 2021 08:31:23 +0100 Magnus Karlsson wrote:
> > On Thu, Jan 14, 2021 at 3:34 PM Cristian Dumitrescu
> > <cristian.dumitrescu@intel.com> wrote:
> > >
> > > This patchset introduces some small and straightforward improvements
> > > to the Intel i40e driver XDP path. Each improvement is fully described
> > > in its associated patch.
> > 
> > Thank you for these clean ups Cristian!
> > 
> > For the series:
> > 
> > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> FWIW since this series is 100% driver code I'm expecting it will 
> come downstream via Tony's tree. Please LMK if that's not the case.

I just realized that this set got somewhat abandonded. Tony, can you pick
this? I wouldn't be surprised if it wouldn't apply cleanly anymore since
it has been almost 4 months since the initial submission, but let's see...
Otherwise we probably would have to ask Cristian to re-submit directly to
IWL I guess.
