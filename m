Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F7922A3A3
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733259AbgGWAam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:30:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:54986 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbgGWAam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 20:30:42 -0400
IronPort-SDR: g3Gcmu3Pg//dsBReqCWF3vEOX4oyONPxeQVibZPEtCMgFTEJd8VA8nNTTukeVmYpGPZWF3HJP4
 dVq4o3Alhzew==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="215066149"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="215066149"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 17:30:42 -0700
IronPort-SDR: d+9gaZnE5qBVNvIXSjhFlyQHWsh3CKrQDACySQl8GBSDsqRFV4Uu/6kmc2EkyEBzkWg+Cc8x65
 WrGdw2fUGfvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="488643015"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.81.73]) ([10.212.81.73])
  by fmsmga005.fm.intel.com with ESMTP; 22 Jul 2020 17:30:41 -0700
Subject: Re: [PATCH net-next v3 10/12] fm10k: convert to new udp_tunnel_nic
 infra
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        thomas.lendacky@amd.com, aelior@marvell.com, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com
References: <20200714191830.694674-1-kuba@kernel.org>
 <20200714191830.694674-11-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <4563bd21-96c3-26da-4798-68820baf23eb@intel.com>
Date:   Wed, 22 Jul 2020 17:30:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200714191830.694674-11-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/2020 12:18 PM, Jakub Kicinski wrote:
> Straightforward conversion to new infra. Driver restores info
> after close/open cycle by calling its internal restore function
> so just use that, no need for udp_tunnel_nic_reset_ntf() here.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Maybe late, but LGTM

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks for this type of cleanup, it's good to see it progressing!

-Jake
