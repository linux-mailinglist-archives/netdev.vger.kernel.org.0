Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D17DB4C4F
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 12:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfIQKzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 06:55:04 -0400
Received: from mga17.intel.com ([192.55.52.151]:38760 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfIQKzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 06:55:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 03:55:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,516,1559545200"; 
   d="scan'208";a="191360143"
Received: from gkarolko-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.40.172])
  by orsmga006.jf.intel.com with ESMTP; 17 Sep 2019 03:54:59 -0700
Subject: Re: [PATCH bpf-next] i40e: fix xdp handle calculations
To:     Maxim Mikityanskiy <maxtram95@gmail.com>,
        Kevin Laatz <kevin.laatz@intel.com>
Cc:     maximmi@mellanox.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, bruce.richardson@intel.com,
        ciara.loftus@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
References: <20190905011144.3513-1-kevin.laatz@intel.com>
 <CAKErNvpe3htU-ETe0y0XQ=SwY047qc3Z3=aHN6g2BbkoGHNNUQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <b1d2a07d-20cc-7410-a296-d5245a2ffe54@intel.com>
Date:   Tue, 17 Sep 2019 12:54:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKErNvpe3htU-ETe0y0XQ=SwY047qc3Z3=aHN6g2BbkoGHNNUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-17 12:48, Maxim Mikityanskiy wrote:
> Hi, it looks to me that headroom is still broken after this commit.
> i40e_run_xdp_zc adds it a second time, i.e.:

Indeed, but Ciara fixed that in this series [1]. Thanks for reviewing
the patch!

Cheers,
Björn

[1] 
https://lore.kernel.org/bpf/20190913103948.32053-1-ciara.loftus@intel.com/
