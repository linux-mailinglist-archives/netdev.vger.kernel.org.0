Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5C11DC163
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 23:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgETVcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 17:32:33 -0400
Received: from mga03.intel.com ([134.134.136.65]:49290 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgETVcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 17:32:33 -0400
IronPort-SDR: 5+I10FcqkgI3y6Z5BodGPDLw9kiRTPKYD/TcFVgUQ4dmOoIc3WG1R8NlENtI8/5ptugZ3mmB3O
 AT49DwzdsMsA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 14:32:32 -0700
IronPort-SDR: dwvjOkxGi/G1LDJCD15yko0ECXelnv6/ROMwP6ch4TrXjU7b6iC4UWDfoL/9eHHYw4CN9fKsV1
 WgaEv/bouwng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,415,1583222400"; 
   d="scan'208";a="466679054"
Received: from alopezch-mobl.amr.corp.intel.com (HELO ellie) ([10.213.162.205])
  by fmsmga006.fm.intel.com with ESMTP; 20 May 2020 14:32:32 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
Cc:     Andre Guedes <andre.guedes@intel.com>,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com, po.liu@nxp.com,
        m-karicheri2@ti.com, Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <20200520125232.s3zrmlnesqjilcf6@soft-dev16>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <158992799425.36166.17850279656312622646@twxiong-mobl.amr.corp.intel.com> <87y2pnmr83.fsf@intel.com> <20200520125232.s3zrmlnesqjilcf6@soft-dev16>
Date:   Wed, 20 May 2020 14:32:31 -0700
Message-ID: <87blmimgwg.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joergen Andreasen <joergen.andreasen@microchip.com> writes:

>> So I thought I was better to let the driver decide what values are
>> acceptable.
>> 
>> This is a good question for people working with other hardware.
>> 
>
> I think it's most intuitive to use the values for AddFragSize as described in
> 802.3br (N = 0, 1, 2, 3).
> You will anyway have to use one of these values when you want to expose the
> requirements of your receiver through LLDP.
>

Thanks. Seems that keeping this value restricted to multiples of 64 is
the way to go. Will fix for the next version of the series.


Cheers,
-- 
Vinicius
