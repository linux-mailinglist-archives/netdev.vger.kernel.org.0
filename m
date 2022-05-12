Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BDE5258D5
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 02:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359700AbiELX75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243920AbiELX74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:59:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C3128B694;
        Thu, 12 May 2022 16:59:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A6C0B8200D;
        Thu, 12 May 2022 23:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CE6C385B8;
        Thu, 12 May 2022 23:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652399993;
        bh=hKkWgtf3NimDoetNbWdTqPVrtruWypXmTG9gJJQYY88=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E96H1p+/N7Ezux/GBP0ZcBzLd2GRuqN75tEaREQq8bRhqxuhMaGZblCuF8KhSf2LO
         5apkcHHLiMvioC6hfzLLwWm/X7khIz3GJoZG4ppWpiYSK7/2hYnw3mHQJblFMpK2MT
         7rn4vhyyF7XSzp2JQZn+GRFOS+N1vGlQunnDkLawhcUo2C+pXqnMDCHZ6IM66D3YsT
         0oqM3GnZtkUo+6849AV6XBxkfHePGrNWd4r2sWBLw1SQs/wA8r19SM2DGtcMm5BOjR
         eW8E7c7Z9X5OiQIFl4MK20fiHeKwASVxfbA5XpfeU0mdteEAsnMcoXiGnHWV2IjrTl
         SrsPoaB0QOvlg==
Date:   Thu, 12 May 2022 16:59:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     <vburru@marvell.com>, <aayarekar@marvell.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gaochao49@huawei.com>
Subject: Re: [PATCH -next] octeon_ep: add missing destroy_workqueue in
 octep_init_module
Message-ID: <20220512165951.1bf6ad41@kernel.org>
In-Reply-To: <20220512093837.1109761-1-zhengbin13@huawei.com>
References: <20220512093837.1109761-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 17:38:37 +0800 Zheng Bin wrote:
> octep_init_module misses destroy_workqueue in error path,
> this patch fixes that.
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Also missing a Fixes tag.
