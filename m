Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6DD1D45CD
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 08:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgEOGXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 02:23:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:33638 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgEOGXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 02:23:15 -0400
IronPort-SDR: FCDWVGuGOWk+Y8tn0QdhJOySxFBo2VYzZB5n59a2QJ2yBsVHHnNdNnW0aHcLvlmW+/z54ZvNIm
 ZbgzgrrSPKBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 23:23:14 -0700
IronPort-SDR: OgyP/bfos+4e4WPUn848uWnpfzZvJcHZ+d7/PMjIH4KHVWQvIJoOqJcdKXuciFBjd4+OuGr3ta
 43+quwsSdmnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,394,1583222400"; 
   d="scan'208";a="281119242"
Received: from bdallmer-mobl3.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.38.223])
  by orsmga002.jf.intel.com with ESMTP; 14 May 2020 23:23:11 -0700
Subject: Re: [PATCH bpf-next v2 00/14] Introduce AF_XDP buffer allocation API
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     maximmi@mellanox.com, maciej.fijalkowski@intel.com
References: <20200514083710.143394-1-bjorn.topel@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <8273458d-c4ef-bf53-bdf5-b5de53c012d3@intel.com>
Date:   Fri, 15 May 2020 08:23:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514083710.143394-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-14 10:36, Björn Töpel wrote:
> Overview
> ========
> 
> Driver adoption for AF_XDP has been slow. The amount of code required
> to proper support AF_XDP is substantial and the driver/core APIs are
> vague or even non-existing. Drivers have to manually adjust data
> offsets, updating AF_XDP handles differently for different modes
> (aligned/unaligned).
> 
> This series attempts to improve the situation by introducing an AF_XDP
> buffer allocation API. The implementation is based on a single core
> (single producer/consumer) buffer pool for the AF_XDP UMEM.

I'll need to respin, adapting to Jesper's 'xdp-grow-tail' merge.


Cheers,
Björn
