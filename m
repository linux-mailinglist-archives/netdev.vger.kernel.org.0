Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC7E2BB4D8
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgKTTH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:07:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:9616 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbgKTTH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 14:07:28 -0500
IronPort-SDR: 2FrcaxVfZ6PsSf73tCHopWMXDVBEY5emOEHgCDCyglUMSIBJYWsRYtzoH9jpR7lmSQuTpd2cqx
 FOW1rkYHIVjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9811"; a="158566084"
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="158566084"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 11:07:27 -0800
IronPort-SDR: AsRrJPokzC90Pm0ifA4RIAi1RGX7TZd6txpeqY2EQgu+LwCI0I3uPN7WpmslQ6e3Fr6bVt2Mkp
 8jPx+q4L59DQ==
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="545552447"
Received: from deeppate-mobl1.amr.corp.intel.com (HELO ellie) ([10.212.22.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 11:07:26 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
In-Reply-To: <20201118075534.2a5e63c4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201114025704.GA15240@hoboy.vegasvil.org>
 <874klo7pwp.fsf@intel.com> <20201117014926.GA26272@hoboy.vegasvil.org>
 <87d00b5uj7.fsf@intel.com>
 <20201118075534.2a5e63c4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Fri, 20 Nov 2020 11:07:21 -0800
Message-ID: <87361326fq.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 17 Nov 2020 17:21:48 -0800 Vinicius Costa Gomes wrote:
>> > Also, what is the point of providing time measurements every 1
>> > millisecond?  
>> 
>> I sincerely have no idea. I had no power on how the hardware was
>> designed, and how PTM was implemented in HW.
>
> Is the PTMed latency not dependent on how busy the bus is?
> That'd make 1ms more reasonable.

At least from the values of the registers I couldn't see any difference
if I was fully using the 2.5G ethernet link or not.


Cheers,
-- 
Vinicius
