Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E9059B82A
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 05:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiHVDxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 23:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiHVDxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 23:53:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C9312A92;
        Sun, 21 Aug 2022 20:53:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2D19B80B2C;
        Mon, 22 Aug 2022 03:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37E5C433D6;
        Mon, 22 Aug 2022 03:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661140423;
        bh=KnereuJVCdo2L1ZRIGBE+Gv8IEBSjxz1ez2467JsVEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aZSDG5GAKFyRkC9xit/0ss2rSYh47O0/vy2Wwo/8IvRJbDRkJ2hAp1EKljDG5fEUQ
         X9UMvgIvMpji3k0zvjfiyltYIsR0utluOMjmSEzNO+kyKwCDUHPvBQU145k7EorKX2
         PgHZ/4vI1B7GYks78XUKJbkAuu7oBtL3prvErS4Wi4Om6fpxSgREjsqeaOKKnKgxga
         +rX+tw8/q1rfdYzA5d35RoU3JzmMpu0Wh0Wz8NOyeuuxOHDX6q3oDGWu9uwXTRoLWh
         Xi8nmR5H7LG0mbpsEU8Yqr6JDxVU4DsYyhUYxMfZMpowhfbaix5hakFZnlszZl1NEx
         f1Aba9YWqPwVw==
Date:   Mon, 22 Aug 2022 11:53:37 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Leo Li <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH devicetree 2/3] arm64: dts: ls1028a: mark enetc port 3 as
 a DSA master too
Message-ID: <20220822035337.GU149610@dragon>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
 <20220818140519.2767771-3-vladimir.oltean@nxp.com>
 <f646670f8ebc64cf1a3080330d54d733@walle.cc>
 <20220818144521.sctrmqcfzi6e6l3e@skbuf>
 <830a44530ce643aa111e74aa5815babf@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <830a44530ce643aa111e74aa5815babf@walle.cc>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 05:08:57PM +0200, Michael Walle wrote:
> Am 2022-08-18 16:45, schrieb Vladimir Oltean:
> > On Thu, Aug 18, 2022 at 04:44:28PM +0200, Michael Walle wrote:
> > > status should be the last property, no?
> > 
> > idk, should it?
> 
> IIRC Shawn pointed that out. If I'm mistaken, then do it for the
> consistency within fsl-ls1028a.dtsi :)

Yeah, I prefer to have 'status' be the last.

Shawn
