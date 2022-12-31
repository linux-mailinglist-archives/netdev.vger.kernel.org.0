Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FBD65A318
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 08:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbiLaHYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Dec 2022 02:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLaHYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Dec 2022 02:24:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F566A45F;
        Fri, 30 Dec 2022 23:24:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19E3F60A4E;
        Sat, 31 Dec 2022 07:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271FFC433D2;
        Sat, 31 Dec 2022 07:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672471474;
        bh=W0A+nhDaTJdpBHbljAA/f8vZK5hDhe3mp9IfpUWV71g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FffWctcpwkG65Yz3WLR1u/fnbk1DPrY2VPoVXb+CyLBM75XPQ2KXiZb2qNyoehLwZ
         kgJOrvVQuZF/C09J22sKTMXzXnEjOqgbfpXnsj0BIhSI1YzfhhQbC7KFNf3lKgsor+
         9YobkLfXzpw05Zf4rK6CFioGR2nTNmCWjp5u3bbsRQg5bFWKuyeY/wbpS3GhluROwX
         I/uQXKRLeYuuZBZTQvYw4H4lVd2ftrWYdQvdu2bqncTHzr/RPRZDdpBvV6jC25G1f8
         qVUga0xeyEpOR9uBKbvuoppCX29ANjia0roSiOb4OEkK0J/wAxrOTTAsWt6OhEdm+y
         rY0HAs9ZNnK+Q==
Date:   Sat, 31 Dec 2022 15:24:25 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     haibo.chen@nxp.com
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] arm64: dts: imx93: add flexcan nodes
Message-ID: <20221231072424.GK6112@T480>
References: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
 <1669116752-4260-3-git-send-email-haibo.chen@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669116752-4260-3-git-send-email-haibo.chen@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 07:32:32PM +0800, haibo.chen@nxp.com wrote:
> From: Haibo Chen <haibo.chen@nxp.com>
> 
> Add flexcan1 and flexcan2 nodes.
> 
> Signed-off-by: Haibo Chen <haibo.chen@nxp.com>

Applied, thanks!
