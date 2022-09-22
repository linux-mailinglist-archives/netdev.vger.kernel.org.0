Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96DE5E57E7
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiIVBQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiIVBP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:15:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC68EAB045;
        Wed, 21 Sep 2022 18:15:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2827B630E6;
        Thu, 22 Sep 2022 01:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA0FC433D6;
        Thu, 22 Sep 2022 01:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663809314;
        bh=cf0oW7+SPcTyLQU1NtOZyt0padpLvdfWmlv63shS+nU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YntjQaymGgklXlco1oL1/Puh00/l72vy0AAe4G8LzW00FOiV4JbZiFqXSI7m3esFd
         rlQLL/1xbp5bjjqEntnjfMBsTgArHlDTy8cVZiYm5WNHhiSrR3VF/fvefQEmL9ZTo9
         UWxJBMZWBD6d7e54UtcRHAneENVbSqCB+y8djPaBL73qEmzEVu5e732TAZsQSpzLkA
         K+VdqdqQe7eabheQkNneVcZQn5fBN1I6bizVpn7LADIo4fttufkiuDNOXGkfg+g6oq
         6LVwLvoQ5y4XzCogmfL/pgAdPxPgba4W9JvQvOU9SlISRlq6BfQ4o24rJc9KJr2K3w
         K8MztHUbS9EHw==
Date:   Wed, 21 Sep 2022 18:15:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next V1 1/2] net: lan743x: Remove PTP_PF_EXTTS
 support for non-PCI11x1x devices
Message-ID: <20220921181513.5aca2cd1@kernel.org>
In-Reply-To: <20220916115758.73560-2-Raju.Lakkaraju@microchip.com>
References: <20220916115758.73560-1-Raju.Lakkaraju@microchip.com>
        <20220916115758.73560-2-Raju.Lakkaraju@microchip.com>
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

On Fri, 16 Sep 2022 17:27:57 +0530 Raju Lakkaraju wrote:
> Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not
> support the PTP-IO Input event triggered timestamping mechanisms
> added by commit 60942c397af6094c04406b77982314dfe69ef3c4

Accepting configuration which is not in fact supported seems like a bug
which deserves a fix, please repost against net with a Fixes tag.
