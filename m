Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F798588F35
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbiHCPQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbiHCPQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:16:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030EE5FA9
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 08:16:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9424D615FE
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 15:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A38C433C1;
        Wed,  3 Aug 2022 15:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659539784;
        bh=eIZA9s4zL4Hv08q0HmfF/dvsDSZvVkq/Cxg9yIIqnKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NUMXCIInZ8NXCu8SYJ5jMxqksdySJ88zuz9CcEKW5p4bEL9BXjtvH50sSsll120I2
         zTi1mNbxSSD05QiuiDHdaVCBul9TWeH3OWKYEjnwCelZjie3BFZSK0C15GEm3do6ED
         jawiw3wixLkP4+RhWwlVw2eFERlgwqu45CVaxEmiKJQuvB9n2LQcYW9VswSG7N4b38
         Y8SBBW29eMkwwT1Jw5dlEeCz05d8XpUrQ/ok46mn4PCvDgMWQmFOlMjzEDDtNyp2SN
         FgIsA/6/WwBwTLWUhbeNvLbIT8VAUxe/KoMLsHogg7cBDvIriCubU1KRqYfoKAIyA8
         FeSqlPnOIe+Xw==
Date:   Wed, 3 Aug 2022 08:16:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>
Cc:     <netdev@vger.kernel.org>, Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH] fec: Allow changing the PPS channel
Message-ID: <20220803081622.6ceeaecd@kernel.org>
In-Reply-To: <20220803112449.37309-1-csokas.bence@prolan.hu>
References: <20220803112449.37309-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Aug 2022 13:24:49 +0200 Cs=C3=B3k=C3=A1s Bence wrote:
> Makes the PPS channel configurable via the Device Tree (on startup) and s=
ysfs (run-time)

# Form letter - net-next is closed

We have already sent the networking pull request for 6.0
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.0-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
