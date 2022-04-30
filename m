Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15AA85159BA
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 04:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbiD3CJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 22:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240255AbiD3CJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 22:09:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF7E9A995;
        Fri, 29 Apr 2022 19:06:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC88562484;
        Sat, 30 Apr 2022 02:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7439C385A7;
        Sat, 30 Apr 2022 02:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651284384;
        bh=SXW+S2HTZFqa7k53eM06jQdKyJ9zaWGvT+IRJEffFQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VBAEFr2tQZMDyQBU6K21bSECYwJw6gN7Ea+/bJ7WJRTapenmE8HEMAsffMSh4+tIW
         YuYiGmwEqcH/2RXfk88sDfhWWWy4lYd0njfMTDBHZkHRmuXwLIIEbjJHZ/1aHiP+/q
         zOK3pDmLlyJvH9T0B0RxYrycTvebiCnYngrXFrxOt85GRmLigvN0mqXfkbKVDi8frj
         MYc1w980iJTM95ktWPsBS3ibxwG26WPFnD8Z6Ogw9JAS/WcOgkHKAcMIr+2+lnxrax
         /7yCs72Wf0m3T6YByOw0PRWxIm15D+H4jD+ln9+B4z2GZuryxXUbq7oOZzsdjwmrUi
         /2k85WEqJbiWA==
Date:   Fri, 29 Apr 2022 19:06:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v1 net 2/2] net: mscc: ocelot: fix possible memory
 conflict for vcap_props
Message-ID: <20220429190622.6f5279b8@kernel.org>
In-Reply-To: <20220429233049.3726791-3-colin.foster@in-advantage.com>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
        <20220429233049.3726791-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 16:30:49 -0700 Colin Foster wrote:
> Fixes: 2096805497e2b ("net: mscc: ocelot: automatically detect VCAP
> constants")
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Please don't line-wrap tags and please don't add empty lines between
them. Let's give Vladimir a day or two to comment on the merits and
please repost with the tags fixed, thanks!
