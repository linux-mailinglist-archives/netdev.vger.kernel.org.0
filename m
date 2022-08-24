Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FBB5A0443
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiHXWra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHXWra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:47:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D2461D70
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12D5961983
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 22:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480BEC433C1;
        Wed, 24 Aug 2022 22:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661381248;
        bh=tn08UDmuECXgP2Z9ptkI9ER6epyXdtGwV4HxLnQba6E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WYRkHs81xzSGWQsKJ821P3iEpPR/fXBQCwPUo3Tg8hYLfOU1/kPTQ8tHegliPHpUQ
         t2x1dOe9WD/ykWPU8zd3Icw6X15rNBElbQ/pebm7oIodPmDdBjRm2ZFPv9PxKAD9ye
         3QJJeP9eVg1hRxsY503E5IHGmozmn2lcTwc1NC9ajMiwWKwdtLG3GnhHzpEihfHR0q
         GjDkS1O7VYfpk3dQ79iLweHecPPY8jINhUD6a9UKy5Ugpt9j1i9gR1Sv1GMnrFYgz2
         ceATKTMPxVzj9WUmIuNtGHDrN9yfNpM8Hf6BkhMMPNUpb+lBrUc+GD5tTx8sUUMCGc
         Jg88sXOpQt1OQ==
Date:   Wed, 24 Aug 2022 15:47:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Greenwalt, Paul" <paul.greenwalt@intel.com>
Subject: Re: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC
 disabled via ETHTOOL_SFECPARAM
Message-ID: <20220824154727.450ff9d9@kernel.org>
In-Reply-To: <CO1PR11MB508971C03652EF412A43DD80D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <20220823150438.3613327-3-jacob.e.keller@intel.com>
        <20220823151745.3b6b67cb@kernel.org>
        <CO1PR11MB508971C03652EF412A43DD80D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
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

On Wed, 24 Aug 2022 21:29:31 +0000 Keller, Jacob E wrote:
> Ok I got information from the other folks here. LESM is not a
> standard its just the name we used internally for how the firmware
> establishes link. I'll rephrase this whole section and clarify it.

Hold up, I'm pretty sure this is in the standard.
