Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A93C4689AE
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 07:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhLEGLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 01:11:49 -0500
Received: from mga03.intel.com ([134.134.136.65]:23043 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231679AbhLEGLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 01:11:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="237105067"
X-IronPort-AV: E=Sophos;i="5.87,288,1631602800"; 
   d="scan'208";a="237105067"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2021 22:08:21 -0800
X-IronPort-AV: E=Sophos;i="5.87,288,1631602800"; 
   d="scan'208";a="514289189"
Received: from kgodix-mobl.gar.corp.intel.com (HELO [10.215.128.183]) ([10.215.128.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2021 22:08:19 -0800
Message-ID: <6befd600-f90c-f9fd-1196-75aa3482b1f3@linux.intel.com>
Date:   Sun, 5 Dec 2021 11:38:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] net: wwan: iosm: select CONFIG_RELAY
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Stephan Gerhold <stephan@gerhold.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211204174033.950528-1-arnd@kernel.org>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <20211204174033.950528-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/2021 11:10 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The iosm driver started using relayfs, but is missing the Kconfig
> logic to ensure it's built into the kernel:
> 
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_create_buf_file_handler':
> iosm_ipc_trace.c:(.text+0x16): undefined reference to `relay_file_operations'
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_subbuf_start_handler':
> iosm_ipc_trace.c:(.text+0x31): undefined reference to `relay_buf_full'
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_ctrl_file_write':
> iosm_ipc_trace.c:(.text+0xd5): undefined reference to `relay_flush'
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_port_rx':
> 
> Fixes: 00ef32565b9b ("net: wwan: iosm: device trace collection using relayfs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
