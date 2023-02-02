Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB016877BC
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjBBInV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjBBInU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:43:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4386DFE0
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:43:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C5A161A2B
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171A1C433D2;
        Thu,  2 Feb 2023 08:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675327398;
        bh=eq6mWY9YLQeXH7NFY6xZJ2nV1cvuYYtqJiq91vtllmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s8nZvZYn3uYwXj+N7TH2bl/MqiDxls5s9+0QT3A9k/EG34hdpWsux5C8hlK6WHQ9z
         QdTYWl06iDa0NbF3UmO29yUw/iplfR6CzjIku1DwtbdgtsuBLqnnDnmpP6EmRWM8e2
         vYphhy6/JDlVio1tENUo7RHwXlYU4tGx11T0/u1KX6teyHBYNWovglNXWoY/mY/ZSh
         BehZJnw+e8Bv+JJQPOnJDsBt3S7fVY6yU+PKKCmr7qYC5xozysilSy/5nPJCoCRnPG
         azwR8QSRnsSA+dLseAeqv2b2/4eXltpdaY+So51AhcYDdrIYqf2p48DFsyBcTKpkaV
         bTxQlcu6xaBBw==
Date:   Thu, 2 Feb 2023 10:43:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH net 2/6] ionic: remove unnecessary void casts
Message-ID: <Y9t3oih8h9S0J7Wy@unreal>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
 <20230202013002.34358-3-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202013002.34358-3-shannon.nelson@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 05:29:58PM -0800, Shannon Nelson wrote:
> Minor Code cleanup details.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c   | 4 ++--
>  drivers/net/ethernet/pensando/ionic/ionic_main.c      | 4 ++--
>  drivers/net/ethernet/pensando/ionic/ionic_phc.c       | 2 +-
>  drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c | 4 ++--
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 

It is not net material.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
