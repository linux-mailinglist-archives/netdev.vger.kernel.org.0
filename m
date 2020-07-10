Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1469B21BC70
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgGJRki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 13:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgGJRki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 13:40:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60B3C08C5DC;
        Fri, 10 Jul 2020 10:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=nzj9xEzg94TiDWiQ2mj7wOcGxexy5FgiHulDtZkhqco=; b=E0sLL2v+dosTWZ483q887n3x/L
        ongb9Eg5BLuc74OARhk+JyNg+hKdT/4dEJvtxdmYeCiG25LIaUcL06KNdIsf8e7v1123jmPex6Wtc
        vMoShmm64O2B3f8BixYU08T8GF0h8eXZjHJPhcuXCObxj+AH3tjisMjSDxHM7rkcVwVD87E6rJ3GE
        nqsaMOp2BrUs0H9u0gLeTYaEhVhTpqhet2OpS4ExVBZvspLqGGClUd1s+QMwgjkEfmF6No41r8Hed
        TVeEDTDaZpaZ2iiHafIzUEtX0BU+Gx1gKetifX6dcTOXLbiwQDcHb6D39ediV8HpQq4tbCaHAwb3O
        2tUyTfnA==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtx0k-00079r-Uz; Fri, 10 Jul 2020 17:40:35 +0000
Subject: Re: mmotm 2020-07-09-21-00 uploaded
 (drivers/net/ethernet/mellanox/mlx5/core/en_main.c)
To:     Andrew Morton <akpm@linux-foundation.org>, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20200710040047.md-jEb0TK%akpm@linux-foundation.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8a6f8902-c36c-b46c-8e6f-05ae612d25ea@infradead.org>
Date:   Fri, 10 Jul 2020 10:40:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200710040047.md-jEb0TK%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/20 9:00 PM, Andrew Morton wrote:
> The mm-of-the-moment snapshot 2020-07-09-21-00 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 
> You will need quilt to apply these patches to the latest Linus release (5.x
> or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> http://ozlabs.org/~akpm/mmotm/series
> 

on i386:

In file included from ../drivers/net/ethernet/mellanox/mlx5/core/en_main.c:49:0:
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h: In function ‘mlx5e_accel_sk_get_rxq’:
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h:153:12: error: implicit declaration of function ‘sk_rx_queue_get’; did you mean ‘sk_rx_queue_set’? [-Werror=implicit-function-declaration]
  int rxq = sk_rx_queue_get(sk);
            ^~~~~~~~~~~~~~~
            sk_rx_queue_set



-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
