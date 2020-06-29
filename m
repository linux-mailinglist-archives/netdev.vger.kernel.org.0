Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4082E20D1D5
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgF2SoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:44:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:40929 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729206AbgF2SoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:44:06 -0400
IronPort-SDR: ihZRz+fMNHKFoSUNnziKKlMkJ0UXhbMkno1qpEjOES9lpQ+jp9H3GIcfD/hCxE3SM19s6ifrTW
 Q/VKGce89L5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134315268"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="134315268"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 09:23:35 -0700
IronPort-SDR: ew6c6XfsnDZieu6Kj7KBL7Ukg7p0HAZg9LfTg3/OJyk7NWtYn8Fhv36+W/Fj20mUDTdHWxEjGm
 SNR0uj/5R7IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="313096285"
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.252.54.90])
  by fmsmga002.fm.intel.com with ESMTP; 29 Jun 2020 09:23:32 -0700
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Christoph Hellwig <hch@lst.de>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        konrad.wilk@oracle.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        maximmi@mellanox.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20200626134358.90122-1-bjorn.topel@gmail.com>
 <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net>
 <20200627070406.GB11854@lst.de>
 <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com>
 <e879bcc8-5f7d-b1b3-9b66-1032dec6245d@iogearbox.net>
 <81aec200-c1a0-6d57-e3b6-26dad30790b8@intel.com>
 <903c646c-dc74-a15c-eb33-e1b67bc7da0d@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <fa7ffbe4-f863-7dd9-f833-4054a2baa149@intel.com>
Date:   Mon, 29 Jun 2020 18:23:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <903c646c-dc74-a15c-eb33-e1b67bc7da0d@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-06-29 17:18, Daniel Borkmann wrote:
> Nice, tossed from bpf tree then! (Looks like it didn't land on the bpf 
> list yet,
> but seems other mails are currently stuck as well on vger. I presume it 
> will be
> routed to Linus via Christoph?)

Thanks!

Christoph (according to the other mail) was OK taking the series via 
your bpf, Dave's net, or his dma-mapping tree.


Björn
