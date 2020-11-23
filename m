Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6132C0CED
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgKWOHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:07:49 -0500
Received: from mga05.intel.com ([192.55.52.43]:2526 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729111AbgKWOHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 09:07:49 -0500
IronPort-SDR: H3mGRUiQLIo1yq+Dr3kMonY9pndIOtb10ukX4FbNj8Aumsy+9emP7NqH27E6DT7d6R5BjYNQ3g
 Nu+PWNF9Yo/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="256477095"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="256477095"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 06:05:23 -0800
IronPort-SDR: DFqlhKpmZHWQBGk4cvMAv4lWpnkTYGp466gyQ1gxIMuUpsy4OOa9HlsfZDN3RCemmSSFeq7ziB
 IuDphJxzYs6g==
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="546424864"
Received: from gcavallu-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.53.119])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 06:05:18 -0800
Subject: Re: [PATCH bpf] net, xsk: Avoid taking multiple skbuff references
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     jonathan.lemon@gmail.com, yhs@fb.com, weqaar.janjua@gmail.com,
        magnus.karlsson@intel.com, weqaar.a.janjua@intel.com
References: <20201123131215.136131-1-bjorn.topel@gmail.com>
 <12b970c5-6b44-5288-0c79-2df5178d1165@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <4459b334-d1b7-f92d-5c31-1d0380e94433@intel.com>
Date:   Mon, 23 Nov 2020 15:05:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <12b970c5-6b44-5288-0c79-2df5178d1165@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-23 14:53, Daniel Borkmann wrote:
[...]
> 
> Hm, but this way free_on_busy, even though constant, cannot be optimized 
> away?
> Can't you just move the dev_xmit_complete() check out into 
> dev_direct_xmit()
> instead? That way you can just drop the bool, and the below 
> dev_direct_xmit()
> should probably just become an __always_line function in netdevice.h so you
> avoid the double call.
>

Good suggestion! I'll spin a v2.


Björn
