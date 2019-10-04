Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64992CBEE4
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389773AbfJDPRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:17:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57026 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388802AbfJDPRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:17:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bG+jGchCJisskgibLt1J7/dZrtMJBAxpqKMI+1hUuT4=; b=ioU7GGNNSV0DjkOzU2y1+zLUj
        i+LHddUVLHVrT+9EiUvW20tGRjMrP7MJ4vIrOJQfAfUysMYg/ZAgundZKFxDtE9UAuJYRWi5mMWjo
        edcPHh/0qwQF8d4KxqbN0sOe0L61Alv6RVyKiQfu0jaSSNZraK8g8fDQx0I1eG2HYnQxW3XSUPD6G
        rWrvlKNY30QQpk0BHLQelBOPiJ1vEuDNyVOtNTo2dKlh8BMgGaJeL83GVo1MwdYjiT6hBG2fY19iU
        ZgnaNAj5I0YQTv8ykpsGOnmq0yqp/J12Ie1ZCjZn6PFPPAiKkmlcvTyayIo2TObzMN31VQIhWx+Jj
        4s8fQtlaQ==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iGPL0-0000o3-FN; Fri, 04 Oct 2019 15:17:46 +0000
Subject: Re: linux-next: Tree for Oct 4 (net/rds/ib)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
References: <20191004155929.3ac043b5@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b9529d01-ad20-3235-c0af-b3dee17ca521@infradead.org>
Date:   Fri, 4 Oct 2019 08:17:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191004155929.3ac043b5@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/3/19 10:59 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20191003:
> 

on i386:

../net/rds/ib.c: In function ‘rds_ib_dev_free’:
../net/rds/ib.c:111:3: error: implicit declaration of function ‘dma_pool_destroy’; did you mean ‘mempool_destroy’? [-Werror=implicit-function-declaration]
   dma_pool_destroy(rds_ibdev->rid_hdrs_pool);
   ^~~~~~~~~~~~~~~~
   mempool_destroy
../net/rds/ib.c: In function ‘rds_ib_add_one’:
../net/rds/ib.c:187:29: error: implicit declaration of function ‘dma_pool_create’; did you mean ‘mempool_create’? [-Werror=implicit-function-declaration]
  rds_ibdev->rid_hdrs_pool = dma_pool_create(device->name,
                             ^~~~~~~~~~~~~~~
                             mempool_create
../net/rds/ib.c:187:27: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
  rds_ibdev->rid_hdrs_pool = dma_pool_create(device->name,
                           ^



-- 
~Randy
