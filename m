Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B1538E3B5
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 12:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhEXKKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 06:10:08 -0400
Received: from mga12.intel.com ([192.55.52.136]:8602 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232625AbhEXKKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 06:10:03 -0400
IronPort-SDR: tOxTB0gM28MN9N3TiHAFprhs1KnEeXvnahDBteFdftutSzpIALyPolH+/rRdOxpkc915soAxlc
 34SasD6KoAmA==
X-IronPort-AV: E=McAfee;i="6200,9189,9993"; a="181538742"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="181538742"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 03:08:09 -0700
IronPort-SDR: oUgJrVishDJYBoLnANl96t2nGkezf1JZXbqoz6PI+xW0sBuK0wIIbMS6GXLoWEBG9mdVbQqRoz
 CI0KAVaCA4gg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="475791830"
Received: from dfuxbrux-desk.ger.corp.intel.com (HELO [10.12.48.255]) ([10.12.48.255])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 03:08:06 -0700
Subject: Re: [Intel-wired-lan] [PATCH intel-net v2 6/6] igc: add correct
 exception tracing for XDP
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
References: <20210510093854.31652-1-magnus.karlsson@gmail.com>
 <20210510093854.31652-7-magnus.karlsson@gmail.com>
From:   Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Message-ID: <5c85e89c-47f7-c6aa-1589-3f4991c3a4e1@linux.intel.com>
Date:   Mon, 24 May 2021 13:08:05 +0300
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
> 
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
