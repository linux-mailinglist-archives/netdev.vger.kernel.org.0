Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C51BFFFB0
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfD3SYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:24:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:47726 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbfD3SYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:24:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 11:24:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="147164319"
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.255.41.105])
  by fmsmga007.fm.intel.com with ESMTP; 30 Apr 2019 11:24:45 -0700
Subject: Re: [PATCH net-next 4/6] xsk: Extend channels to support combined
 XSK/non-XSK traffic
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20190426114156.8297-1-maximmi@mellanox.com>
 <20190426114156.8297-5-maximmi@mellanox.com>
 <e4c2a6ee-5aa4-eabf-444f-b5f6df17fe38@intel.com>
 <4e830da4-086b-4157-e0d6-bd1adcf49788@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <5e2b78de-b66c-bba6-23a5-c89b1bc50391@intel.com>
Date:   Tue, 30 Apr 2019 20:24:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <4e830da4-086b-4157-e0d6-bd1adcf49788@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-04-30 20:11, Maxim Mikityanskiy wrote:
> I'm going to respin this series, adding the mlx5 patches and addressing
> the other comments. If you feel like there are more things to discuss
> regarding this patch, please move on to the v2.

Very cool, thanks for working on this Maxim!

It's Labor Day in Sweden tomorrow, I'll have a look Thu/Fri!


Cheers,
Björn
