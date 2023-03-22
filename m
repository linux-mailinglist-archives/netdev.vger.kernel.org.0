Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F03F6C5A0E
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCVXKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjCVXKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:10:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE84F967;
        Wed, 22 Mar 2023 16:10:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0392AB81D84;
        Wed, 22 Mar 2023 23:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C730C433D2;
        Wed, 22 Mar 2023 23:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679526627;
        bh=M/2LLUnt2dlXMupxvFeyY3NxcJdCoVaTN30cC1Tx37g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iN+D214mahCPukmca7357vGYdOAocA8+k8F0EcNEC0WTDbsJ5tcERfTYRKqA8FhGf
         ypwFwHmixy34ChlEFolR5XyEdY482YBg1F7WaK/Nv+R/Em0cRIyQA/78/WiK1RgzzA
         YZ3wz2PcFXnQUTUDWr1dMHny4o4wk4IlHXMcSef87vJt+sTwq5O+wKRbn7RpwmnAhV
         J3lsnYk1xOKUF/EiwKRvcVQgL6Xf/LLinRhjYeAXItw64nYBBT/I6bhYBdTxD46qX7
         RXOX8vl3JDVetzCrUNzdLL/9KvnIfhYC4dX8Nc+waAW9w5MYljnUfaobF7kk6NVROj
         VtkZ3dkRdnIJA==
Date:   Wed, 22 Mar 2023 16:10:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2] net: dpaa2-mac: Get serdes only for backplane
 links
Message-ID: <20230322161026.5633f8d4@kernel.org>
In-Reply-To: <e17fd247-181f-ab33-d1d7-aafd18e87684@seco.com>
References: <20230304003159.1389573-1-sean.anderson@seco.com>
        <20230306080953.3wbprojol4gs5bel@LXL00007.wbi.nxp.com>
        <4cf5fd5b-cf89-4968-d2ff-f828ca51dd31@seco.com>
        <e17fd247-181f-ab33-d1d7-aafd18e87684@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 15:52:23 -0400 Sean Anderson wrote:
> I see this is marked as "changes requested" on patchwork. However, as explained
> above, I do not think that the requested changes are necessary. Please review the
> patch status.

Let me document this, it keeps coming up. Patch incoming..
