Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5307438E3AC
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 12:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhEXKHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 06:07:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:52174 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232599AbhEXKHF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 06:07:05 -0400
IronPort-SDR: 5/iuTGq+9JTkjqkzVSL3g/j3XcfWDK4YmIsnEI9VdedlPERz1tPfTbJA4ePZO5pUfZ9ov1oGLg
 J2dE3F8dPrbg==
X-IronPort-AV: E=McAfee;i="6200,9189,9993"; a="189021501"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="189021501"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 03:05:36 -0700
IronPort-SDR: 35wEytosB0lthWneSatwK8hRCOxP32WnWaTA9s5Bl3WTO87ivIfVYsWcbEyaKoD3E+OfmcjTNT
 kQL/S1lVepwg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="475790095"
Received: from dfuxbrux-desk.ger.corp.intel.com (HELO [10.12.48.255]) ([10.12.48.255])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 03:05:34 -0700
Subject: Re: [Intel-wired-lan] [PATCH intel-net v2 6/6] igc: add correct
 exception tracing for XDP
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
References: <20210510093854.31652-1-magnus.karlsson@gmail.com>
 <20210510093854.31652-7-magnus.karlsson@gmail.com>
From:   Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Message-ID: <4761eca6-5007-9898-3cab-f974af68d956@linux.intel.com>
Date:   Mon, 24 May 2021 13:05:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210510093854.31652-7-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05/2021 12:38, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Add missing exception tracing to XDP when a number of different
> errors can occur. The support was only partial. Several errors
> where not logged which would confuse the user quite a lot not
> knowing where and why the packets disappeared.
> 
> Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
> Fixes: 4ff320361092 ("igc: Add support for XDP_REDIRECT action")
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
> Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
