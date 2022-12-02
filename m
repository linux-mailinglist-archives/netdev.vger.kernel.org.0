Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8AA640EC7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiLBTwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiLBTwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:52:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B04EE94A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 11:52:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B7CEB82279
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 19:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1609C433D6;
        Fri,  2 Dec 2022 19:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670010734;
        bh=LPRdq9V5F9HtS6TkON8cv2elgG+YwRH+FkbNPqRMrOE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bciDORSAdFY1ERPFH5j1Tc+yoT4woQWToRP5IXXh4yFsAPP5HtRIpWnjy32JJpsDp
         yINstEaTnaW9eRaAu+BlVa57/KMqMVh2OO9DhtaLKPjVsnEPJppn78BXRXyis+nbl2
         iR2ZquJ3qsxai6E02T1MKDbGlPKbJj2Hydwxl0SlZ5NRlg32yNBbo2T0fuIst1QyMy
         PJbknEsEuC6A9eZZbHsU8FTvmHYz0pb27unaYaz3zLsoYACk6UwIvizBngOBvjaQnM
         kJLwLKJrX5WfecnFcm0jPVr6zD9ij8ysemr5Fjke21BF02zaPxIqGMPnka9qznQTUI
         TIPOCFpB4ygRA==
Date:   Fri, 2 Dec 2022 11:52:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <20221202115213.0055aa4a@kernel.org>
In-Reply-To: <Y4pV6+LxhyDO2Ufz@unreal>
References: <cover.1669547603.git.leonro@nvidia.com>
        <20221202094243.GA704954@gauss3.secunet.de>
        <Y4o+X0bOz0hHh9bL@unreal>
        <20221202101000.0ece5e81@kernel.org>
        <Y4pEknq2Whbw/Z2S@unreal>
        <20221202112607.5c55033a@kernel.org>
        <Y4pV6+LxhyDO2Ufz@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Dec 2022 21:45:47 +0200 Leon Romanovsky wrote:
> > More of a question of whether we can reasonably expect to merge all 
> > the driver code in a single release cycle. If not then piecemeal
> > merging is indeed inevitable. But if Steffen is happy with the core
> > changes whether they are in tree for 6.2 or not should not matter.
> > An upstream user can't access them anyway, it'd only matter to an
> > out-of-tree consumer.
> > 
> > That's just my 2 cents, whatever Steffen prefers matters most.  
> 
> There are no out-of-tree users, just ton of mlx5 refactoring to natively
> support packet offload.

30 patches is just two series, that's mergeable in a week.
You know, if it builds cleanly.. :S  Dunno.
