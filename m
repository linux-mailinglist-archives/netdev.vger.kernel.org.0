Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADB44582F3
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 11:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbhKUKge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 05:36:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:16327 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhKUKge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 05:36:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10174"; a="215369331"
X-IronPort-AV: E=Sophos;i="5.87,252,1631602800"; 
   d="scan'208";a="215369331"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2021 02:33:29 -0800
X-IronPort-AV: E=Sophos;i="5.87,252,1631602800"; 
   d="scan'208";a="508550724"
Received: from krausnex-mobl.ger.corp.intel.com (HELO [10.13.8.200]) ([10.13.8.200])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2021 02:33:24 -0800
Subject: Re: [Intel-wired-lan] [PATCH net-next 2/2] igc: enable XDP metadata
 in driver
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, bjorn@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, magnus.karlsson@intel.com
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
 <163700859087.565980.3578855072170209153.stgit@firesoul>
From:   "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>
Message-ID: <a991d408-df9e-4a4a-1887-8973553adb23@linux.intel.com>
Date:   Sun, 21 Nov 2021 12:33:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <163700859087.565980.3578855072170209153.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/2021 22:36, Jesper Dangaard Brouer wrote:
> Enabling the XDP bpf_prog access to data_meta area is a very small
> change. Hint passing 'true' to xdp_prepare_buff().
> 
> The SKB layers can also access data_meta area, which required more
> driver changes to support. Reviewers, notice the igc driver have two
> different functions that can create SKBs, depending on driver config.
> 
> Hint for testers, ethtool priv-flags legacy-rx enables
> the function igc_construct_skb()
> 
>   ethtool --set-priv-flags DEV legacy-rx on
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c |   29 +++++++++++++++++++----------
>   1 file changed, 19 insertions(+), 10 deletions(-)
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>




