Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4685258262
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgHaUVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:21:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:40940 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgHaUVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 16:21:06 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCqIW-0004hx-02; Mon, 31 Aug 2020 22:21:00 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCqIV-000IJ5-Nw; Mon, 31 Aug 2020 22:20:59 +0200
Subject: Re: [PATCH bpf-next v5 00/15] xsk: support shared umems between
 devices and queues
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
References: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <10257218-3b58-fd2e-c38f-ce320ca62de5@iogearbox.net>
Date:   Mon, 31 Aug 2020 22:20:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25916/Mon Aug 31 15:26:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 10:26 AM, Magnus Karlsson wrote:
[...]
> v4 -> v5:
> 
> * Fixed performance problem with sharing a umem between different
>    queues on the same netdev. Sharing the dma_pages array between
>    buffer pool instances was a bad idea. It led to many cross-core
>    snoop traffic messages that degraded performance. The solution: only
>    map the dma mappings once as before, but copy the dma_addr_t to a per
>    buffer pool array so that this sharing dissappears.
> * Added patch 10 that improves performance with 3% for l2fwd with a
>    simple fix that is now possible, as we pass the buffer pool to the driver.
> * xp_dma_unmap() did not honor the refcount. Fixed. [Maxim]
> * Fixed bisectabilty problem in patch 5 [Maxim]

Applied, thanks!
