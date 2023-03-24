Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109A06C8817
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjCXWJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjCXWJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:09:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678C99E
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18C6DB82631
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 22:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C58C433EF;
        Fri, 24 Mar 2023 22:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679695742;
        bh=Hjl87o1bHZ+k5PXMUP0gVW+VVbeO4FfyYRjmi3T6HUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UM1WQ5l4DQoFwexGoP87ZNBc/QFtAqOAmimX78otIZ5ucOXnf2UuIpWlbtqIqrfpW
         xahaPsn1fErkBH15zdkEmvGXTcBO3qSoQwltnS8HGHuH0JKftgvtrluJh154tNl1Rc
         8LB86AzWVqpL5XL2Gmdap/xxK3xXMHPRiGYRWze9G6Yzg0K+9zcVGZSB9n9kcS12yf
         JXFX4PbWd59FZ8kmlIYU0VNV55keuso4z4O1xJT8Si4usIWMr+ucWf+/6vfFWYs3cN
         JalF0IdnJShIakiZGoj96yq+2apAwkFpYhZ/mdjbMbhZPCTSvwByR2iXEGtpy4g6LP
         NCUOO4KoxxKOg==
Date:   Fri, 24 Mar 2023 15:09:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>,
        Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: ethernet: mtk_eth_soc: fix flow block
 refcounting logic
Message-ID: <20230324150901.1b1b65e7@kernel.org>
In-Reply-To: <ZB2Vrq3TK8MmK9ah@corigine.com>
References: <20230323130815.7753-1-nbd@nbd.name>
        <ZB2Vrq3TK8MmK9ah@corigine.com>
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

On Fri, 24 Mar 2023 13:21:02 +0100 Simon Horman wrote:
> I'm guessing that this series is for 'net'.
> But it seems that patchwork had a tough time figuring that out
> and gave up. So CI type things haven't run there.

Indeed, a resend with [PATCH net] in the subject would be appreciated.
patchwork does a lot more build testing than we can handle manually.
