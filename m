Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D93112339D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 18:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfLQRde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 12:33:34 -0500
Received: from mga06.intel.com ([134.134.136.31]:60835 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbfLQRde (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 12:33:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 09:33:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="227570830"
Received: from kprakasa-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.49.247])
  by orsmga002.jf.intel.com with ESMTP; 17 Dec 2019 09:33:15 -0800
Subject: Re: [PATCH bpf v2 0/4] Fix concurrency issues between XSK wakeup and
 control path using RCU
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20191217162023.16011-1-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <cfe64691-7a0f-5b8a-d511-ebe742cec3c0@intel.com>
Date:   Tue, 17 Dec 2019 18:33:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191217162023.16011-1-maximmi@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-17 17:20, Maxim Mikityanskiy wrote:
> This series addresses the issue described in the commit message of the
> first patch: lack of synchronization between XSK wakeup and destroying
> the resources used by XSK wakeup. The idea is similar to
> napi_synchronize. The series contains fixes for the drivers that
> implement XSK. I haven't tested the changes to Intel's drivers, so,
> Intel guys, please review them.
>

Max, thanks a lot for compiling the series on your vacation!


Cheers,
Björn
