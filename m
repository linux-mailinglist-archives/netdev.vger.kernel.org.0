Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8FB60537E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiJSWyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiJSWyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:54:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88BE2CDC2;
        Wed, 19 Oct 2022 15:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB675B8260A;
        Wed, 19 Oct 2022 22:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A595C433D6;
        Wed, 19 Oct 2022 22:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666220046;
        bh=DyFOQhu736H2a7dirW99JvLxPw6b1dMEeUZ0sC3xDBM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CST4PZmHQZloaeDap9TAfyPcpqSn6IGYPbwatKmhRoaJq4RjjciHlOGcF4elm+oTi
         OwNYKPlzkNcA9ATgqsBm/Kosq/eDoW8bdrdHUHuwj47/bVByZtFeOXcqt2jCHJL92I
         FR/eU4LCkocJ6F8Lo5BLmZfjfrPof5Y9FKDguHsoJoZa/Tn4FtoJKyLKE52nJef9MS
         asjTTqfiF5Q9qKNmWcMC/ZdHGN51lREshCJIKBNmPNuLYE3dmhkIJahdkPIkaBtKhB
         RVByx8tKdmcCHu2nCAxAXGDMHEc/Pwq26upCnhNDx+sgTzZP7zY47qQkHV7D62yL6N
         3vXCO8RLA8sFQ==
Date:   Wed, 19 Oct 2022 15:54:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        bjorn@kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/12] net: dpaa2-eth: AF_XDP zero-copy
 support
Message-ID: <20221019155405.5d570b98@kernel.org>
In-Reply-To: <20221018141901.147965-1-ioana.ciornei@nxp.com>
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 17:18:49 +0300 Ioana Ciornei wrote:
> This patch set adds support for AF_XDP zero-copy in the dpaa2-eth
> driver. The support is available on the LX2160A SoC and its variants and
> only on interfaces (DPNIs) with a maximum of 8 queues (HW limitations
> are the root cause).

AF_XDP folks, could you take a look? 
