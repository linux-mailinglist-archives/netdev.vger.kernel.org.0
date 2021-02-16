Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F113631C7FF
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBPJYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:24:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:59820 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229694AbhBPJYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 04:24:36 -0500
IronPort-SDR: fJpSG0HMUHjRXbQhpI0bIXnDtkfXdNzmz3cYOBUZt0m0U9L82PGWGD4LtpwWRKcpvD5uer82Mh
 3xywKt8sKwZQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="202030842"
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="202030842"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 01:23:54 -0800
IronPort-SDR: GE0423LPgWcwhwoYCRRpHkvEGbH7lbc39OKwd+PbMGjsml438GEfoNzMsr+T2qU6HUaXcpMd8W
 nDKn3qhrayKA==
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="399439394"
Received: from tkanteck-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.159])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 01:23:50 -0800
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org,
        magnus.karlsson@intel.com, ciara.loftus@intel.com
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com> <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
 <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch> <8735xxc8pf.fsf@toke.dk>
 <602b0f54c05a6_3ed41208dc@john-XPS-13-9370.notmuch>
 <20210216022320.GC9572@ranger.igk.intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <cb4865d0-4521-ad85-d473-13bc0205cf74@intel.com>
Date:   Tue, 16 Feb 2021 10:23:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210216022320.GC9572@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-16 03:23, Maciej Fijalkowski wrote:
> On Mon, Feb 15, 2021 at 04:18:28PM -0800, John Fastabend wrote:

[...]

> 
> Once again, is libxdp going to land in th kernel? Still not clear to me.
>

No, libxdp does not live in the kernel tree.


Björn

[...]
