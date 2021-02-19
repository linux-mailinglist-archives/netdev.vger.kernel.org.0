Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B09031FE5A
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhBSRvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:51:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:13083 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhBSRux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 12:50:53 -0500
IronPort-SDR: YUxLMyzsFCICTRpCQjUaq49axq7ZleZiBzZmryKQ8WLfZMDGgMorkb8gFqGlObd0OjkL/UANXF
 WNm7LYGZ50rQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9900"; a="247978909"
X-IronPort-AV: E=Sophos;i="5.81,189,1610438400"; 
   d="scan'208";a="247978909"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 09:49:13 -0800
IronPort-SDR: MJNWFA6kOP/j6fUyLSeBS8PjBHho7kp2jfPzW0WwU0UOgE0MIfZzI6qXx4/U+cJzKBwUkoV2WL
 y52Nfe2eYq6g==
X-IronPort-AV: E=Sophos;i="5.81,189,1610438400"; 
   d="scan'208";a="401127004"
Received: from martafor-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.56.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 09:49:09 -0800
Subject: Re: [PATCH bpf-next 2/2] bpf, xdp: restructure redirect actions
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
References: <20210219145922.63655-1-bjorn.topel@gmail.com>
 <20210219145922.63655-3-bjorn.topel@gmail.com> <87r1lchtkf.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <3e3e61af-b6e0-0755-f5f1-39fcd4e47f2d@intel.com>
Date:   Fri, 19 Feb 2021 18:49:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87r1lchtkf.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-19 18:10, Toke Høiland-Jørgensen wrote:
>> +	case XDP_REDIR_DEV_MAP: {
>>   		struct bpf_dtab_netdev *dst = fwd;
> I thought the braces around the case body looked a bit odd. I guess
> that's to get a local scope for the dst var (and xs var below), right?
> This is basically a cast, though, so I wonder if you couldn't just as
> well use the fwd pointer directly (with a cast) in the function call
> below? WDYT?

Yeah. I'll fix that in the next verison!


Thanks, and have a nice weekend!
Björn
