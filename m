Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5275D5A16B1
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 18:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239089AbiHYQaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 12:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiHYQaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 12:30:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F3F27CDB
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 09:30:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B2FCB829E4
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 16:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3AAC433D6;
        Thu, 25 Aug 2022 16:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661444999;
        bh=dIxJc1ZouT+m7cn0IoDhIUz9nox8lstePNhTeB9Imb8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=haK05/mt8JvoNXTKO9aMRqiSJHAlQPcAG14iDRrdkGaOaE/yPs+v2ZeUxamUMHtJN
         AO1BJ+nLUw2IPc2xcSGvV5INMDLKeGL8Z+JWsmHXNav+dQRTV1yEVn4BVVZdQfg2w4
         UoP49VYpq4N3iWjvmGdKmTK4BhKsp0INN6tuNNYgxIzHkCylx2RCDYAjGsWIXtx2yr
         aClFLRZfsG4/e/uLhE1e6osb01mTHSxQiiZ9+2JOp2QitBJS0hYgzwe0LjCuzZl+/T
         LUNQnUODBgOuel/wpBN8oQWHeOjHImntt2p5F5cmy379MztpTDSd6trpNuUQ6p373X
         MIIYPC9y772uw==
Date:   Thu, 25 Aug 2022 09:29:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Message-ID: <20220825092957.26171986@kernel.org>
In-Reply-To: <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
        <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 10:08:05 +0300 Gal Pressman wrote:
> Then maybe adding a new flag is the right thing to do here.
> 
> That way the existing auto mode will keep its current meaning (all modes
> including off), which you'll be able to support on newer firmware
> versions, and the new auto flag (all modes excluding off) will be
> supported on all firmware versions.
> Then maybe we can even add support for the new flag in mlx5 (I need to
> check whether that's feasible with our hardware).

Sorry, I misinterpreted your previous reply, somehow I thought you
quoted option (3), because my fallible reading of mlx5 was that it
accepts multiple flags.

(First) option 2 is fine.

Do you happen to have a link to what SONiC defined?
We really need to establish some expectations before we start extending
the API. Naively I thought the IEEE spec was more prescriptive :(
