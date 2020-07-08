Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CACF2185EA
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgGHLSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:18:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:24012 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgGHLSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 07:18:39 -0400
IronPort-SDR: 9zZoIoYFvvtLVy/DzbiwfqDOGz0R9Wa9WkSa2D0o1PRsgo4MV64nUMvuWVaoPGxscC9KZCQna4
 zEoBdeV+qMoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145277461"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="145277461"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 04:18:38 -0700
IronPort-SDR: 3XUpf49xC1pHqWSEi9TRl9qBzYRTpAOZ9LaLt/XthCV/FeplKdpnk6gfiTSAGPLbTRa+lngOEv
 oKeEhwB0X1dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="457469396"
Received: from nncongwa-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.47.82])
  by orsmga005.jf.intel.com with ESMTP; 08 Jul 2020 04:18:37 -0700
Subject: Re: [PATCH bpf-next 0/3] xsk: add new statistics
To:     Ciara Loftus <ciara.loftus@intel.com>, bpf@vger.kernel.org,
        magnus.karlsson@intel.com,
        Network Development <netdev@vger.kernel.org>
References: <20200708072835.4427-1-ciara.loftus@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <e9e077dd-5bb1-dbce-de2e-ed8f46ac9b75@intel.com>
Date:   Wed, 8 Jul 2020 13:18:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708072835.4427-1-ciara.loftus@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-07-08 09:28, Ciara Loftus wrote:
> This series introduces new statistics for af_xdp:
> 1. drops due to rx ring being full
> 2. drops due to fill ring being empty
> 3. failures pulling an item from the tx ring
> 
> These statistics should assist users debugging and troubleshooting
> peformance issues and packet drops.
> 
> The statistics are made available though the getsockopt and xsk_diag
> interfaces, and the ability to dump these extended statistics is made
> available in the xdpsock application via the --extra-stats or -x flag.
> 
> A separate patch which will add ss/iproute2 support will follow.
>

+netdev

Thanks for working on this, Ciara!

For the series:
Acked-by: Björn Töpel <bjorn.topel@intel.com>

> Ciara Loftus (3):
>    xsk: add new statistics
>    samples: bpf: add an option for printing extra statistics in xdpsock
>    xsk: add xdp statistics to xsk_diag
> 
>   include/net/xdp_sock.h            |  4 ++
>   include/uapi/linux/if_xdp.h       |  5 +-
>   include/uapi/linux/xdp_diag.h     | 11 ++++
>   net/xdp/xsk.c                     | 36 +++++++++++--
>   net/xdp/xsk_buff_pool.c           |  1 +
>   net/xdp/xsk_diag.c                | 17 ++++++
>   net/xdp/xsk_queue.h               |  6 +++
>   samples/bpf/xdpsock_user.c        | 87 ++++++++++++++++++++++++++++++-
>   tools/include/uapi/linux/if_xdp.h |  5 +-
>   9 files changed, 163 insertions(+), 9 deletions(-)
> 
