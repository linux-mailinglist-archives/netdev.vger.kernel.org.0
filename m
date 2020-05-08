Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375511CB669
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgEHR5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:57:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:10480 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgEHR5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 13:57:17 -0400
IronPort-SDR: sXOYk73iCH5SI5zKYesswyS8W5aZsoiwpu4UqdMwJDmKOHKpgQGBoLzdSua+Puo3eecseMqpQ1
 cfXO6SsK5B3g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 10:57:05 -0700
IronPort-SDR: zV3cofSOmJXoSwfr7//9/2zcwa2b7mMftHqyQw+sV1oDukNXQI86myVaYsOVu+PVgTzPHu73U7
 8UEb1VShmRqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,368,1583222400"; 
   d="scan'208";a="305553148"
Received: from aghafar1-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.56.248])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2020 10:57:02 -0700
Subject: Re: [PATCH bpf-next 10/14] mlx5, xsk: migrate to new
 MEM_TYPE_XSK_BUFF_POOL
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
 <20200507104252.544114-11-bjorn.topel@gmail.com>
 <40eb57c7-9c47-87dc-bda9-5a1729352c43@mellanox.com>
 <3c42954a-8bb3-85b1-8740-a096b0a76a98@intel.com>
 <cf65cc80-f16a-5b76-5577-57c55e952a52@mellanox.com>
 <CAJ+HfNiU8jyNMC1VMCgqGqz76Q8G1Pui09==TO8Qi73Y_2xViQ@mail.gmail.com>
 <CAJ+HfNiBuDWX77PbR4ZPR_vuUyOTLA5MOGfyQrGO3EtQC1WwJQ@mail.gmail.com>
 <4c627f32-bbe6-21ff-f06f-c151093ec0e8@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <67f4ba56-a5ac-ed07-8c4e-57fffbba339f@intel.com>
Date:   Fri, 8 May 2020 19:57:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <4c627f32-bbe6-21ff-f06f-c151093ec0e8@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-08 19:34, Maxim Mikityanskiy wrote:
[]
> 
> You are right, thanks, it was indeed missing. However, adding it was not 
> enough, I still get zeros, will continue investigating on Monday.
>

Thanks Max! Let me know if I can help out.


Have a nice weekend,
Björn

