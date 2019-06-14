Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48BB746856
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 21:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfFNTvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 15:51:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:30568 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfFNTvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 15:51:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 12:51:04 -0700
X-ExtLoop1: 1
Received: from nisrael1-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.255.41.147])
  by orsmga006.jf.intel.com with ESMTP; 14 Jun 2019 12:50:54 -0700
Subject: Re: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612155605.22450-8-maximmi@mellanox.com>
 <20190612132352.7ee27bf3@cakuba.netronome.com>
 <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
 <20190613164514.00002f66@gmail.com>
 <eb175575-1ab4-4d29-1dc9-28d85cddd842@mellanox.com>
 <20190614191549.0000374d@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <9ee7363b-508a-4461-1c4f-252c2ba9cf76@intel.com>
Date:   Fri, 14 Jun 2019 21:50:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190614191549.0000374d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-14 19:15, Maciej Fijalkowski wrote:
> Why would I want to run AF_XDP without ZC? The main reason for having AF_XDP
> support in drivers is the zero copy, right?

In general I agree with you on this point. Short-term, I see copy-mode
useful for API adoption reasons (as XDP_SKB), so from that perspecitve
it's important. Longer term I'd like to explore AF_XDP as a faster
AF_PACKET for pcap functionality.


Björn

