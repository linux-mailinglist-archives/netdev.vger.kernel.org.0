Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C29D21CE0D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 06:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgGMESG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 00:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgGMESF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 00:18:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89842C061794;
        Sun, 12 Jul 2020 21:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=9EII5lxv3w8np0WP47117d0We5uqUfds5Agb/d+0ZU4=; b=rfZ7LLpbB7M/kYF9YQ4xoJc7YE
        rwhOets/F27iPGBXigCSusd8QrijeN9WXygGkYEfzMRHSeXyCElrr7p79oOycUthcHP4HVK0vjtWP
        KLdfi46qUVbjgNMQ5wzL9uQpCRRmywTaqajoAFLNlKtBR7LzFfksZmBH0GyiEYwuHYgQXj01JIkO7
        jYf1hiYYLs2vCs91xk7hplCIvn4kSfKBL31Az5SDVXY2EWR3tBZjoW+PwfhFbBdjT61vH1LXgmW1U
        SXfKwyddagN/1t/O/RWwwH8dMoBRaiBlob2HCDdLXzLmga0nI4h4Me+b31lMRq0zN2YSgjFU1oZYU
        n3PXyYrg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jupui-0001MG-03; Mon, 13 Jul 2020 04:18:02 +0000
Subject: Re: mmotm 2020-07-09-21-00 uploaded
 (drivers/net/ethernet/mellanox/mlx5/core/en_main.c)
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Andrew Morton <akpm@linux-foundation.org>, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
References: <20200710040047.md-jEb0TK%akpm@linux-foundation.org>
 <8a6f8902-c36c-b46c-8e6f-05ae612d25ea@infradead.org>
 <20200713140238.72649525@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <55d10a82-6e23-2905-0764-234d53b11cb6@infradead.org>
Date:   Sun, 12 Jul 2020 21:17:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713140238.72649525@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/20 9:02 PM, Stephen Rothwell wrote:
> Hi Randy,
> 
> On Fri, 10 Jul 2020 10:40:29 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> on i386:
>>
>> In file included from ../drivers/net/ethernet/mellanox/mlx5/core/en_main.c:49:0:
>> ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h: In function ‘mlx5e_accel_sk_get_rxq’:
>> ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h:153:12: error: implicit declaration of function ‘sk_rx_queue_get’; did you mean ‘sk_rx_queue_set’? [-Werror=implicit-function-declaration]
>>   int rxq = sk_rx_queue_get(sk);
>>             ^~~~~~~~~~~~~~~
>>             sk_rx_queue_set
> 
> Caused by commit
> 
>   1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
> 
> from the net-next tree.  Presumably CONFIG_XPS is not set.

Yes, that's correct.

-- 
~Randy

