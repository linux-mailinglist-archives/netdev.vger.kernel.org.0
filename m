Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14055159BD
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 04:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382059AbiD3CLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 22:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240229AbiD3CLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 22:11:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A168C1C8E;
        Fri, 29 Apr 2022 19:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 05391CE3564;
        Sat, 30 Apr 2022 02:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909FAC385A4;
        Sat, 30 Apr 2022 02:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651284474;
        bh=nHShToVT/QHjSqamH2C8iOcXNP+HMyX8SCWsqa38xn4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pjTg9KZTk4KvBeQXLWI8kX33ncNG9tMfY0b2L54xlCm4kBQeNyYysXJKQdpOSbRWj
         5a0zi4Li6QXPxtt3N12qT5DHWK3kBRwed2LTH1ZYSymnknxmIu1JN52LpMrcSu3pdg
         b8ksjbUDlJ3DLBKHIMvh6AlUkgf24v2E0C33oZPzusf1wfri+nQ++T1j/9mCRPwbxg
         zRlejWCHFuvoweskhQzIQkB1umTi8FKRpztN/ttvVhLXfbJRO3jBCp5Il5ncyLavvX
         Y/oKfeNR8LdN7jKhntiVVspU1mdPkfjfuI0Gojf+e+Udd1sB3erg/spodS/BH5PZLP
         8/vIP+2A9CLkw==
Date:   Fri, 29 Apr 2022 19:07:52 -0700
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
Subject: Re: [PATCH v1 net 1/2] net: ethernet: ocelot: rename vcap_props to
 clearly be an ocelot member
Message-ID: <20220429190752.36a8f4dd@kernel.org>
In-Reply-To: <20220429233049.3726791-2-colin.foster@in-advantage.com>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
        <20220429233049.3726791-2-colin.foster@in-advantage.com>
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

On Fri, 29 Apr 2022 16:30:48 -0700 Colin Foster wrote:
> The vcap_props structure is part of the ocelot driver. It is in the process
> of being exported to a wider scope, so renaming it to match other structure
> definitions in the include/soc/mscc/ocelot.h makes sense.
> 
> I'm splitting the rename operation into this separate commit, since it
> should make the actual bug fix (next commit) easier to review.

Sure, but is it really necessary to do it now, or can we do it later 
in net-next? There's only one struct vcap_props in the tree AFAICT.
