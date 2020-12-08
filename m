Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE7C2D2403
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 08:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgLHHEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 02:04:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:34490 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgLHHEI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 02:04:08 -0500
IronPort-SDR: S8L20bGf2CGorsXqEnYX6mrTolC1ESgIZG8MK4EO2/ksYMO89uu0+OXLLfa7T7FKtt/S/OHg48
 4pmcSAPlBitw==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="235443209"
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="235443209"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 23:03:27 -0800
IronPort-SDR: T5bzF0jYE6uQZfaVBvbR7q5Y8H2jYH6DOZcWhiY2L/MJJ/m0ydTUIVBPfSY1jJPXT5fiqzSlWH
 h6M8EAfGI7HA==
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="317669101"
Received: from snazary-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.32.66])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 23:03:22 -0800
Subject: Re: [PATCH bpf-next v4 0/5] selftests/bpf: xsk selftests
To:     Yonghong Song <yhs@fb.com>,
        Weqaar Janjua <weqaar.janjua@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        magnus.karlsson@gmail.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
References: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
 <956522ac-5a57-3755-ede5-6d33169ce6e1@fb.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <a2157b4c-7498-d160-b703-60ee8fc6c83d@intel.com>
Date:   Tue, 8 Dec 2020 08:03:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <956522ac-5a57-3755-ede5-6d33169ce6e1@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-08 04:56, Yonghong Song wrote:
> On 12/7/20 1:53 PM, Weqaar Janjua wrote:
>> This patch set adds AF_XDP selftests based on veth to selftests/bpf.
[...]
> 
> All tests passed in my environment.
> Tested-by: Yonghong Song <yhs@fb.com>
> 

Thanks for the hard work, Weqaar! And thanks Yonghong for testing/feedback.

 From my perspective this is a good selftest base for AF_XDP, and
something we can continue to build on.

For the series:

Acked-by: Björn Töpel <bjorn.topel@intel.com>
