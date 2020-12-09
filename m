Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970112D4B67
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 21:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388163AbgLIUPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 15:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388172AbgLIUP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 15:15:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170ECC061793;
        Wed,  9 Dec 2020 12:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=vT2LeumRVmdZuBQd+zgEqW+31k7g/hZC7ygemlxuDL0=; b=lihKyoV1WlUFcBILw6J+5RQIuy
        TufE3r2rCPt8d+abi7LhY0S7za+9g0+/YLvCtDRarEefff/JvK+Y1/qDce+IMNoas8VaMguapYHg4
        ru1x/RryyBNvIRwySuz8MbQZKv4sahCtfI8RltY/Eca6pyjggYl+eTYqHVvwP+RlVeRPiDh7rQMQ4
        s8DRx3Jn6jeGXWioGBx+JlYlJ8zr2jVGAV5E2X/IINOAe5BLveaTm8S0rbcyS6dAyeT6bWwB+I+nO
        iu83kqwxe3TumEsAeSv//bIE6a6C/yXT/p9OoKIWYk9p5KxDKqDN4DooV8jNVogDrPAZPDCYyaam7
        eaD78qGw==;
Received: from [2601:1c0:6280:3f0::1494]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn5rI-0006d0-4l; Wed, 09 Dec 2020 20:14:44 +0000
Subject: Re: linux-next: Tree for Dec 9 (ethernet/mellanox/mlx5)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20201209214447.3bfdeb87@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e5519ac6-1d25-632a-9b55-087d8ffaf386@infradead.org>
Date:   Wed, 9 Dec 2020 12:14:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201209214447.3bfdeb87@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/20 2:44 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20201208:
> 

on i386:

I see this warning:/note: repeated 106 times on i386 build:

                 from ../drivers/net/ethernet/mellanox/mlx5/core/alloc.c:34:
../include/vdso/bits.h:7:26: warning: left shift count >= width of type [-Wshift-count-overflow]
 #define BIT(nr)   (UL(1) << (nr))
                          ^
../include/linux/mlx5/mlx5_ifc.h:10716:46: note: in expansion of macro ‘BIT’
  MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT(0x20),
                                              ^~~



-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
