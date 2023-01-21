Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD42676412
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 06:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjAUFx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 00:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjAUFxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 00:53:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612A670C4F;
        Fri, 20 Jan 2023 21:53:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79139603F5;
        Sat, 21 Jan 2023 05:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C01BC433EF;
        Sat, 21 Jan 2023 05:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674280431;
        bh=451sssQyFebA1Bb1e8WvjsOFQupJ7BkTebLs0yC2lCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AhMSnFsvVZZKHXQqQiOzMzx6uJrq1WjfHQv+WX1BeNBxB71VxB24KpZhHeXG3Tgu8
         /qgnJJabDYt5kpAhnlRKSjC3Aew5phwXaeXxp1KkECuVz70JWQRvNAIiPqYgAbS2Xl
         5SVx81jGLnce8K0FUcfkpvGFYHsZSKjkMjhvMRWGLZ1Pi/RttE44zSnuUNyRxk53pH
         HrVjHTpLwKi2uU7OcmMc3/JvZnGyWUDD7RB9zyhMgyHZM7oSuCg9G8CLxXxvJXzMn8
         BibFjjwUX/gDuIuCvhWMP9CRo3P6vSenW1gJ+vDPE9V73gTsuZJD2WRpOKR73Hlr4g
         NP2kNA3h2XpxQ==
Date:   Fri, 20 Jan 2023 21:53:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v4 net-next 00/12] ethtool support for IEEE 802.3 MAC
 Merge layer
Message-ID: <20230120215350.7a60cec5@kernel.org>
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
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

On Thu, 19 Jan 2023 14:26:52 +0200 Vladimir Oltean wrote:
> TL;DR: a MAC Merge layer as defined by IEEE 802.3-2018, clause 99
> (interspersing of express traffic). This is controlled through ethtool
> netlink (ETHTOOL_MSG_MM_GET, ETHTOOL_MSG_MM_SET). The raw ethtool
> commands are posted here:

ethtool stuff LGTM FWIW.
