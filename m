Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF6C4DB924
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350422AbiCPUFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241944AbiCPUFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:05:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2EA2AC59
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49D11B81CFA
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82102C340E9;
        Wed, 16 Mar 2022 20:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647461065;
        bh=N1YxD33qkDQvkNv+0YEOBpGJl3ztI8zraYvfy8BzxcU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tQQLu2fLES3g+k5621r9XDa7z59aAnSwA0mZwVlKPJNVHfdPnE8QyPPHjV075vt1+
         W1AAe2NK/cgvRjTlIw/7n1VKE9gL9rlTIAKzt8yZq4R2LR4wseZw2Dcx/Gr7GLMxnd
         zDnnxkCKb8Zqa7LZRe9c0PFn8y9GkXmgzUPey/tRGAuSOWQY6ehtEYbfvxULSfJ7zt
         ltaurmELfXoba4KyM49zcxNlpk4boOzcLHFqQjbQpNtE36kD1JndyG7Hg0wVyKjNEF
         GJd3zz85l6TE+hyQo9SWU69qpCSYiN2nvN5nO13krxhJSsItznK/Ef71s5zkSIFckN
         aPCKXk/Gl1PqA==
Date:   Wed, 16 Mar 2022 13:04:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, michal.simek@xilinx.com,
        linux@armlinux.org.uk, robert.hancock@calian.com, andrew@lunn.ch,
        netdev@vger.kernel.org, Greentime Hu <greentime.hu@sifive.com>
Subject: Re: [PATCH] net: axiemac: use a phandle to reference pcs_phy
Message-ID: <20220316130424.40acc503@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316075953.61398-1-andy.chiu@sifive.com>
References: <20220316075953.61398-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 15:59:53 +0800 Andy Chiu wrote:
> Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)

Please make sure to CC the maintainer of the driver. You also ate an
"m" at the end of Robert's address.
