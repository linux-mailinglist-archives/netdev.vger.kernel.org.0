Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C6960E349
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbiJZO1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiJZO1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:27:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A3A10F8B3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63EB8B822B2
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 14:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E99BC433D6;
        Wed, 26 Oct 2022 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666794456;
        bh=6TwQH+cTs6GCFpVa3ArHzD8LWLpEyIzh7FTU6Z89sV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nHCiJuvwvNUClwuI2lPtrL7xUg2FCbPtihK94007yvNg93oF+YbJ+gG2GxLjN4JHB
         x+QILz5eDi4fG/MlYaFwJ3oxxuqC5AkxLttu6E/Azcak3NY2jTGQrClxlagaUf+I67
         7rFkk9uM4JciaokxCDWqbeTaeniGWS4QxZK3N0Ydqef2GJM4UY+VUsZ7/JJ7pGpsBE
         yQsJGnfjn5p4Mcz1WEHUzQf6hq9xfsA/2IAR+lzl2QrHeVgIjKQ0pQoj1pwqMB2f2G
         pe9nQSX6UwXiRgnl+rawb8NOUrF9waZMBTHjbmaIpaFroIMIiVuo3QShDsikPYItpR
         le9X2UThEzh/A==
Date:   Wed, 26 Oct 2022 15:27:31 +0100
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v1 0/6] Various cleanups for mlx5
Message-ID: <20221026142731.nrmhssgn5dhi7jot@sx1>
References: <cover.1666630548.git.leonro@nvidia.com>
 <20221025110011.rurzxqqig4bdhhq5@sx1>
 <Y1fHq9HVOhgeNhlB@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y1fHq9HVOhgeNhlB@unreal>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25 Oct 14:25, Leon Romanovsky wrote:
>On Tue, Oct 25, 2022 at 12:00:11PM +0100, Saeed Mahameed wrote:
>> On 24 Oct 19:59, Leon Romanovsky wrote:
>> > From: Leon Romanovsky <leonro@nvidia.com>
>> >
>> > Changelog:
>> > v1:
>> > Patch #1:
>> > * Removed extra blank line
>> > * Removed ipsec initialization for uplink
>>
>> This will break functionality, ipsec should only be enabled on nic and
>> uplink but not on other vport representors.
>
>I didn't hear any complain from verification. The devlink patch is in
>my tree for months already.
>

the regression is clear in the code. Ask Raed he added the functionality
for uplink.

>>
>> Leon let's finish review internally, this series has to go through my trees
>> anyways.
>
>What about other 5 patches? Let's progress with them, please.
>

Sure, I will take other patches into my tree, but please let's do internal
reviews next time, no need to clutter ML with mlx5 specific stuff.

