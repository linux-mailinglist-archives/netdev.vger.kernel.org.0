Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D8D4E57BC
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343719AbiCWRlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343714AbiCWRlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:41:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2561265D0D;
        Wed, 23 Mar 2022 10:40:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9908560DF5;
        Wed, 23 Mar 2022 17:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77117C340E8;
        Wed, 23 Mar 2022 17:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648057207;
        bh=aGxkOrl4YHeDa3byBAwdvcVuxN7xIPGXQ+Q+9RjcAsM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ca6hDaCTaZvNvOpFrfXJq3z4ahr3/j5DZHxkTaaOxEu4uU4exx7j1xCLXwqhCub6I
         a/I6khBy2crK9TotJ15ULlh97uTkwkJ4gEYpJVd0u1oIyWkEe/x6y51ZstLZIu4A0M
         UuCXS+jCaU1pGDZxDI44tj2fmgb3bPrL+h1Qx6pkH4nNfoxNsZOdf/hLbCRhcOI8b4
         EXW2WhChYk+9LxgjGKgvIev/RE2sZfTDVDEa7K3PVMyic6LgeNHZLz93XVzak/sW3V
         vJrAjM7InYBguosjSMrv7WFRO+fwQlJrV8uEgLDB35WxE9CNrzZmOY1orw6KNjVDX2
         9WTYsvKClsoEA==
Date:   Wed, 23 Mar 2022 10:40:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] ice: avoid sleeping/scheduling in atomic
 contexts
Message-ID: <20220323104005.2a58a57c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220323124353.2762181-1-alexandr.lobakin@intel.com>
References: <20220323124353.2762181-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 13:43:51 +0100 Alexander Lobakin wrote:
> --
> Urgent fix, would like to make it directly through -net.

You may want to use three hyphens, two hyphens mean footer.
Email clients gray those out, it's easy to miss :)
