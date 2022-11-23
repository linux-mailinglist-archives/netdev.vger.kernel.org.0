Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F91C636EA1
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiKWX5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiKWX5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:57:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5087FDD86
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:57:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92ABCB82557
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 23:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445F1C433D6;
        Wed, 23 Nov 2022 23:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669247828;
        bh=cMc3aPWmJNOHlTu+Z4Ig49ZDhBtCfweqAz2z6dEQrVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sYK/Yad+I2tYIA4KxAsEaXxsKpuorlDziJ7wjffqfni2fT6fPfcc/2BDLuWar+puz
         TYjsvZdJClDdk+KSR7Javq29Z/xB0GAoLj7JEXXyepsYISbyOZJnMZTV8r5+XroZDT
         vC3gO7c6ZiHlzST7pOhmH2VwDGZkU2+q5NqbBo7MlDXeTfZMlruXG77+CePfj5E7GU
         5l1Q+Y70QjVohOQCTEwdC6FUiAfn8b/mzTGAeOnrWSKPAsm9tThOj5i+SLuHJ0AqS/
         b8Q+2G18Afa1wm0sGKHA9NGpWjmIFxTSIb4Jr5waurABpB5yAq7k/e9pZ1N/VFny3h
         wv9hl1PMC2F+g==
Date:   Wed, 23 Nov 2022 15:57:07 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [net 13/14] net/mlx5e: Fix MACsec update SecY
Message-ID: <Y36zU4/dv9wwMGmg@x130.lan>
References: <20221122022559.89459-1-saeed@kernel.org>
 <20221122022559.89459-14-saeed@kernel.org>
 <Y346jo+YByPirHSm@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y346jo+YByPirHSm@boxer>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 Nov 16:21, Maciej Fijalkowski wrote:
>On Mon, Nov 21, 2022 at 06:25:58PM -0800, Saeed Mahameed wrote:
>> From: Emeel Hakim <ehakim@nvidia.com>
>>
>> Currently updating SecY destroys and re-creates RX SA objects,
>> the re-created RX SA objects are not identical to the destroyed
>> objects and it disagree on the encryption enabled property which
>
>nit: disagrees?
>

I think this is minor, let's be considerate, many contributors are non
native english speakers, so as long as the commit message is
understandable and sound, i think we should just ignore such simple
mistakes. We are not here to review proper grammar.. 
