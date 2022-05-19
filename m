Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C7752CB42
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiESEoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiESEoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:44:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E40C5E76;
        Wed, 18 May 2022 21:44:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BF396198A;
        Thu, 19 May 2022 04:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE0AC385B8;
        Thu, 19 May 2022 04:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652935455;
        bh=eH+to+NAmvFaFuKN1HgU3OMIDhVg0ITWrmBG7G/EaN0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=naGZcqnrfRNo7yE4CSxGMRVbhVRkUCzkLCDTD8iCBI6OA7BcBntgwqSQlQNglNV33
         ukZkkothPES3QeIjWoEXMgXNojCxJZTTwXpMoUA8t4yyV9wuPFuA19odo7viD84cGt
         V8tQRTRDU8EagsR8jvafe5kSaZgF1+Px/2bWc2WezD0zPgGs1RLhvLpfV08pBPLbjU
         W4uFscvJ7cI9LKzju/gH0tw22pSrxTMRK/5w66EMQYa6qxhSQHT/1qtjDaTyspfk2X
         smPQ+U6Z6FPtW7Eb7AkazN9758kCeZIYflKCbAeDbHBEmNG6bZiO9yq1ibD5KFa1nv
         mTKa4Bf6uVHhg==
Date:   Wed, 18 May 2022 21:44:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Trimarchi <michael@amarulasolutions.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: Avoid allocating rx buffer using ATOMIC in
 ndo_open
Message-ID: <20220518214413.0ade506e@kernel.org>
In-Reply-To: <20220518062007.10056-1-michael@amarulasolutions.com>
References: <20220518062007.10056-1-michael@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 08:20:07 +0200 Michael Trimarchi wrote:
> Make ndo_open less sensitive to memory pressure.
> 
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
