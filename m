Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A13F60CAE3
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiJYLZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiJYLZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:25:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939B018953D
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:25:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FAC0618DE
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72FFC433D6;
        Tue, 25 Oct 2022 11:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666697137;
        bh=4Z6lmMwYkp1rfp+VHHKh5EQ8HUtzmWrLpNNwXwpNZBA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQMC7Ouv6RHOxYKzgjaXZcGhFIV5gepAnnz00T9IGxUgbISP0A1pbbkd8uGY7eaoN
         uP6FYoGMWlso0Gs/Pb8zfpladxAW8bP2IS/F4jJOVFq5LdBJxUjNbJbqNlEWZCap8y
         KWqagErF2v9seSKXonLvFCey01/PvjzChwCkKEMgvm5IE9eK5FsAZ3lFUfsLU5px6D
         22iF4Rzv40afU5R9OECFyLprC5wvEpOoGzAo6QqOStancA6xjQLu0gjrQ0NF/1tSl2
         Zr+OcejunNRSEhrFx8mp3hWeyUSucOQ/T6bxa15Ev3wRcM6h5rd7eoPfZGwtvJiAvv
         11K+GOjGlYldg==
Date:   Tue, 25 Oct 2022 14:25:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v1 0/6] Various cleanups for mlx5
Message-ID: <Y1fHq9HVOhgeNhlB@unreal>
References: <cover.1666630548.git.leonro@nvidia.com>
 <20221025110011.rurzxqqig4bdhhq5@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025110011.rurzxqqig4bdhhq5@sx1>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 12:00:11PM +0100, Saeed Mahameed wrote:
> On 24 Oct 19:59, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Changelog:
> > v1:
> > Patch #1:
> > * Removed extra blank line
> > * Removed ipsec initialization for uplink
> 
> This will break functionality, ipsec should only be enabled on nic and
> uplink but not on other vport representors.

I didn't hear any complain from verification. The devlink patch is in
my tree for months already.

> 
> Leon let's finish review internally, this series has to go through my trees
> anyways.

What about other 5 patches? Let's progress with them, please.

Thanks

> 
> 
