Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C1225B3C3
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 20:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgIBSd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 14:33:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:51896 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgIBSdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 14:33:55 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDXZn-0004fd-Hx; Wed, 02 Sep 2020 20:33:43 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kDXZn-000QLd-A8; Wed, 02 Sep 2020 20:33:43 +0200
Subject: Re: [PATCH][next] xsk: Fix null check on error return path
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200902150750.GA7257@embeddedor>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9b7e36c3-0532-245c-763a-8f4e7e36b358@iogearbox.net>
Date:   Wed, 2 Sep 2020 20:33:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200902150750.GA7257@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25918/Wed Sep  2 15:41:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/20 5:07 PM, Gustavo A. R. Silva wrote:
> Currently, dma_map is being checked, when the right object identifier
> to be null-checked is dma_map->dma_pages, instead.
> 
> Fix this by null-checking dma_map->dma_pages.
> 
> Addresses-Coverity-ID: 1496811 ("Logically dead code")
> Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied, thanks!
