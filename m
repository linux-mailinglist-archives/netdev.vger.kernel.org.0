Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A15E2619EF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731716AbgIHS2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:28:41 -0400
Received: from mga18.intel.com ([134.134.136.126]:64232 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbgIHS2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 14:28:19 -0400
IronPort-SDR: /+K4GfWQ/belPr3gIptrPZWe7jp+qxN+2wNFnJXDEFaI1yU7lTBy+VqKaqlBvFfmMZDespM/P+
 ogw4eRRKV4sw==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="145915014"
X-IronPort-AV: E=Sophos;i="5.76,406,1592895600"; 
   d="scan'208";a="145915014"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 11:28:17 -0700
IronPort-SDR: rIk4qiBYBbFqOusR2NS4novT1JNqm7J1bFNOuDpX6Fzl17TOITXUt2bnEVUcysEaTBJaFqXxuw
 PnYgv8M8CM1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,406,1592895600"; 
   d="scan'208";a="284608686"
Received: from pgierasi-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.2])
  by fmsmga007.fm.intel.com with ESMTP; 08 Sep 2020 11:28:14 -0700
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is
 full
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, davem@davemloft.net,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
 <20200904162751.632c4443@carbon>
 <27e05518-99c6-15e2-b801-cbc0310630ef@intel.com>
 <20200904165837.16d8ecfd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1d2e781e-b26d-4cf0-0178-25b8835dbe26@intel.com>
 <20200907114055.27c95483@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8f698ac5-916f-9bb0-cce2-f00fba6ba407@intel.com>
 <20200908102438.28351aab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <12536115-3dae-1efa-5c0d-34fc951fca48@intel.com>
Date:   Tue, 8 Sep 2020 20:28:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908102438.28351aab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-08 19:24, Jakub Kicinski wrote:
>> I'll start playing around a bit, but again, I think this simple series
>> should go in just to make AF_XDP single core usable*today*.
> No objection from me.

Thanks Jakub, but as you (probably) noticed in the other thread Maxim 
had some valid concerns. Let's drop this for now, and I'll get back 
after some experimentation/hacking.


Again, thanks for the ideas! Very much appreciated!
Björn
