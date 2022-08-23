Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A957859CF0E
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 05:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbiHWDB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 23:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239821AbiHWDBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 23:01:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634B75C971
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 20:01:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 191FCB81A7F
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F20DC433C1;
        Tue, 23 Aug 2022 03:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661223677;
        bh=Ed70jXVlwq4A1WmuyWKCUnTwoJaOD5UEsL4er0C51K4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mhw/RC86WAVSWLFO4tb2twqcFGPzgZAt1abnolO490FkwdfCCuywuEGhgbT8j4oNC
         HFirawpIMIdtzgj2ATjnfo8ZI+Nk2VpToyb09r0PXqeyOyA1wJbdB6wCSK86O8R42Z
         noD1QNY/cnMNQkSKgyXsLaTegSPKqxWSzm4JMVXy8uvY+2y+w591uejjsEm/oEG75V
         2VoNipd1H3sqeIxAcIR27OlY9nb73M7KaKydSwnwxXb1A48Rl6vFqjFtJ+NNodGn0v
         TfsCVg7GxuJdS9nvbMte+3CXIV7lIeQIBcUrShZocfhsapeYLfsIcoV6H2m00sWtj2
         XRl98P2z0GFZQ==
Date:   Mon, 22 Aug 2022 20:01:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next v2 4/4] net: devlink: expose the info about
 version representing a component
Message-ID: <20220822200116.76f1d11b@kernel.org>
In-Reply-To: <20220822170247.974743-5-jiri@resnulli.us>
References: <20220822170247.974743-1-jiri@resnulli.us>
        <20220822170247.974743-5-jiri@resnulli.us>
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

On Mon, 22 Aug 2022 19:02:47 +0200 Jiri Pirko wrote:
> If certain version exposed by a driver is marked to be representing a
> component, expose this info to the user.
> 
> Example:
> $ devlink dev info
> netdevsim/netdevsim10:
>   driver netdevsim
>   versions:
>       running:
>         fw.mgmt 10.20.30
>       flash_components:
>         fw.mgmt

I don't think we should add API without a clear use, let's drop this 
as well.
