Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8B42E2374
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 02:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgLXBnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 20:43:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbgLXBnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 20:43:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B3C92256F;
        Thu, 24 Dec 2020 01:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608774154;
        bh=hj3LIqPER0CrgBuPt3h2bHK5UOX6uFmYMNl6ErgMRWY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iB5PtpJT3W1rTYYwZ+y1cDEgFVLUG6hPwFMWw4lQQAQdBbEW5pAAHg6QDaqBsA5GB
         nFyMoU0yX5cfE8A2yI9qWdc1bPokhuU+PgFdRJtDQ2BYQ8+Rix7C+t0b32/tNcDbXV
         /ILlceI0ym1Ct4N1UAPeN0rD8Vabs56tteQcBj4yBvAEVTJ9OvTVSQrZrwYNPCHaIs
         Pvjs0PqEcfSPXeZtU7+yyFhfdT4uMIRU90PWV+MjPJiaq3jCM16lThu1SaIt22AfyA
         U+RDD2pi3CuI6bUht1+87S0kftQRs+m65wd3Tl+bA4D0SeWa6OiFnO3i0woU5Q33eC
         LWJiZk/7XOlZw==
Date:   Wed, 23 Dec 2020 17:42:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wong, Vee Khee" <vee.khee.wong@intel.com>
Cc:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>
Subject: Re: [PATCH net-next v1] stmmac: intel: Add PCI IDs for TGL-H
 platform
Message-ID: <20201223174232.49cc68c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BYAPR11MB28703D0C520657C8D3078DFAABDD0@BYAPR11MB2870.namprd11.prod.outlook.com>
References: <20201222160337.30870-1-muhammad.husaini.zulkifli@intel.com>
        <20201223121337.58b0c276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BYAPR11MB28703D0C520657C8D3078DFAABDD0@BYAPR11MB2870.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Dec 2020 01:23:25 +0000 Wong, Vee Khee wrote:
> > On Wed, 23 Dec 2020 00:03:37 +0800 Muhammad Husaini Zulkifli wrote:  
> > > From: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> > >
> > > Add TGL-H PCI info and PCI IDs for the new TSN Controller to the list
> > > of supported devices.
> > >
> > > Signed-off-by: Noor Azura Ahmad Tarmizi  
> > <noor.azura.ahmad.tarmizi@intel.com>  
> > > Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> > > Signed-off-by: Muhammad Husaini Zulkifli  
> > <muhammad.husaini.zulkifli@intel.com>
> > 
> > Applied, thanks. Are these needed in the 5.10 LTS branch?  
> 
> Yes, these are needed in the 5.10 LTS branch.

Okay, queued.
