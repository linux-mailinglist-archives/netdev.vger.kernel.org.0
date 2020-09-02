Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE9F25B3C9
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 20:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgIBSfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 14:35:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:52144 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgIBSfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 14:35:30 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDXbR-0004oI-74; Wed, 02 Sep 2020 20:35:25 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDXbQ-000VRx-Uj; Wed, 02 Sep 2020 20:35:24 +0200
Subject: Re: [PATCH][next] xsk: fix incorrect memory allocation failure check
 on dma_map->dma_pages
To:     Colin King <colin.king@canonical.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200902161332.199961-1-colin.king@canonical.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <01a1216b-3b9e-1755-33a2-b491cf48ab8c@iogearbox.net>
Date:   Wed, 2 Sep 2020 20:35:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200902161332.199961-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25918/Wed Sep  2 15:41:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/20 6:13 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The failed memory allocation check for dma_map->dma_pages is incorrect,
> it is null checking dma_map and not dma_map->dma_pages. Fix this.
> 
> Addresses-Coverity: ("Logicall dead code")
> Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, already applied a fix that was sent earlier [0].

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=1d6fd78a213ee3874f46bdce083b7a41d208886d
