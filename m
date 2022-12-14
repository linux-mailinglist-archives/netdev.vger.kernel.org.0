Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8400164CE5C
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbiLNQvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbiLNQvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:51:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BC01649F;
        Wed, 14 Dec 2022 08:51:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9373061B4B;
        Wed, 14 Dec 2022 16:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED2AC433EF;
        Wed, 14 Dec 2022 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671036668;
        bh=nHnR4TkuzOchBDqf1SuiCAx95osqwKJzT394UY/Kto8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iol2eLvjBWZ+W6QY9+1Jx/OqQjcfLN00qRbpc6OOd/aLvBqEz8o6exVl2LR0diXw8
         0/ReEYLvVaAvNTGaZYFVedcI4fmqeUxidcqMt1zzqTI9eAkRDlfCwv3i2Ha6VsoHTr
         AphYVG+PVFvXbQMFgSCX/vO79jx/eQyCMiPo2EEEP+atpeVM7W4CbIzIs0zl912kzH
         ebT4P+cOJvixzId0/Y52KvTgNLtWZ7e8sqX/gEzMoTjeBaNlj2Jig5VWTrf7fXp2vF
         rLFJ3sYcwojy0CuxuCw1jUhIkHPgu82IkPhxLmPpnV84KIw/VauvtlSYGN+tklM3gr
         ptv4hS4SwvP8A==
Date:   Wed, 14 Dec 2022 08:51:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Lixue Liang <lianglixuehao@126.com>, anthony.l.nguyen@intel.com,
        linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, lianglixue@greatwall.com.cn
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in
 case of invalid one
Message-ID: <20221214085106.42a88df1@kernel.org>
In-Reply-To: <Y5l5pUKBW9DvHJAW@unreal>
References: <20221213074726.51756-1-lianglixuehao@126.com>
        <Y5l5pUKBW9DvHJAW@unreal>
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

On Wed, 14 Dec 2022 09:22:13 +0200 Leon Romanovsky wrote:
> NAK to any module driver parameter. If it is applicable to all drivers,
> please find a way to configure it to more user-friendly. If it is not,
> try to do the same as other drivers do.

I think this one may be fine. Configuration which has to be set before
device probing can't really be per-device.
