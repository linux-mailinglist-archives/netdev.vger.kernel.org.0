Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131C46B85EE
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjCMXPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjCMXPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:15:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E151166F;
        Mon, 13 Mar 2023 16:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D02AA6154C;
        Mon, 13 Mar 2023 23:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F01C433EF;
        Mon, 13 Mar 2023 23:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678749312;
        bh=GNirMZNzwE42rc8bV27DJryZ+n2qiDsEJipahtuktTg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iPpTrfxaIiIljSq+2ssQkQurwUKHlFeKp9G1+IuRWYnkevDVtgkOOycGqGjrIXe5B
         K+heAy4iD5u0/ZtQghl9vfUAJmaT2+W+wK83/BguqE+Goq6GMNaweDSs/1ECqvI0dT
         hQgTDQiGgY2lhbPkocJKtB6mMh+Lhjh9L0S7aH27v+KFCwouyBpS2zIo8mwQAjuLmX
         gWUrQDkxbMvaT42kjmhtOeRy/Fnhcih+AWHRH3k05Q2G32lN45z4OnmEmsOZBuMgiN
         VdFmr7FIaTXPY13+n/QtMHqoraIKnrw567LrFVrXUBOP9KqT6tukIUKeKwm3GJD1jH
         rpDIlt7DX0tDA==
Date:   Mon, 13 Mar 2023 16:15:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <michal.simek@xilinx.com>, <radhey.shyam.pandey@xilinx.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <anirudha.sarangi@amd.com>,
        <harini.katakam@amd.com>, <git@amd.com>
Subject: Re: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet:
 convert bindings document to yaml
Message-ID: <20230313161510.540f6653@kernel.org>
In-Reply-To: <20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com>
References: <20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com>
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

On Wed, 8 Mar 2023 11:42:23 +0530 Sarath Babu Naidu Gaddam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> Convert the bindings document for Xilinx AXI Ethernet Subsystem
> from txt to yaml. No changes to existing binding description.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>

Rob, Krzysztof, looks good?

