Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED9931C7F7
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBPJXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:23:15 -0500
Received: from mga04.intel.com ([192.55.52.120]:52161 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229913AbhBPJXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 04:23:08 -0500
IronPort-SDR: TbhuKvJ7cRdOPuhdJ7IDpQciIUq3hWUyNXBQ6GdiGywiPAd+NRDg9VE0vlqSkRkNJJAJ9x6rv5
 WVonyILUSnWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="180282458"
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="180282458"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 01:22:24 -0800
IronPort-SDR: FFDiqO33NPBrOmNLwOz7dQPMU04A/+aV0iMepFDLcmYZYGh2982QRLSHG0yf6kWgZjS3VbyBfD
 SjNoyeaGTb4w==
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="399439138"
Received: from tkanteck-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.159])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 01:22:20 -0800
Subject: Re: [PATCH bpf-next 3/3] samples: bpf: do not unload prog within
 xdpsock
To:     John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-4-maciej.fijalkowski@intel.com>
 <602ad895e1810_3ed41208b6@john-XPS-13-9370.notmuch>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <2e9b5266-047c-95d0-f056-03457e485862@intel.com>
Date:   Tue, 16 Feb 2021 10:22:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <602ad895e1810_3ed41208b6@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-15 21:24, John Fastabend wrote:
> Maciej Fijalkowski wrote:
>> With the introduction of bpf_link in xsk's libbpf part, there's no
>> further need for explicit unload of prog on xdpsock's termination. When
>> process dies, the bpf_link's refcount will be decremented and resources
>> will be unloaded/freed under the hood in case when there are no more
>> active users.
>>
>> While at it, don't dump stats on error path.
>>
>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>> ---
> 
> Can we also use it from selftests prog so we have a test that is run there
> using this? Looks like xdpxceiver.c could do the link step as well?
> 

Yes! Good point!


Björn
