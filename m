Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A9D6239E6
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiKJCmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiKJCmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:42:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01951A3AD
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:42:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C69061466
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A84C433D6;
        Thu, 10 Nov 2022 02:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668048129;
        bh=M0U4YxgfIU9Y5obrSNT+e+E7oJDkHmWpP3Ykbi/KhRE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YilkPfz0G6N8DIaSox8D7e9pxuIZiLdIMjC5pP55PfOAc4fME9Av2eTP4WYKHMYNf
         HZ+ZREAJuu8iFKpHquTmGBN36r6MnXW4OEFrxcHvYI0k0RVgH57oNmXyGij3UpL+dU
         7eZpO4dIw0x47ssb9+T112l2U7unYVj7smr6/BVI1Y7JV6baUovC4OwLZsRjr2K9ks
         +gtmwsTvsejs3yprQlb92+nVGs6/BkH2g+m/64L6RCTH2ZzAmoNxOmMy4IL+q5uWiS
         Et8bAI1DedabjozpPw5RKqjEF8Fpj1YpuFBQDU3suWxQ06hCIr8kSZgsRqnyAk764y
         SnZVFXGtY6zMA==
Date:   Wed, 9 Nov 2022 18:42:05 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jonathan Lemon <bsd@meta.com>, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] genetlink: fix policy dump for dumps
Message-ID: <Y2xk/bLu1tjfvViV@x130.lan>
References: <20221108204041.330172-1-kuba@kernel.org>
 <Y2vnesR4cNMVF4Jn@unreal>
 <Y2v4fVbvUdZ80A9E@unreal>
 <20221109121118.660382b5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221109121118.660382b5@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 Nov 12:11, Jakub Kicinski wrote:
>On Wed, 9 Nov 2022 20:59:09 +0200 Leon Romanovsky wrote:
>> > I added your updated patch to my CI run. Unfortunately, the regression
>> > system is overloaded due to nightly regression so won't be able to get
>> > results in sensible time frame.
>>
>> Tested-by: Leon Romanovsky <leonro@nvidia.com>
>
>To be clear - did you test as posted or v2? Or doesn't matter?
>I'm wondering how applicable the tag is to v2.

FWIW: I just tested v2 and it passed our CI.
