Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E91063CEA1
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiK3FPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiK3FOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:14:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D651810569;
        Tue, 29 Nov 2022 21:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D72DB81A2F;
        Wed, 30 Nov 2022 05:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB158C433D7;
        Wed, 30 Nov 2022 05:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785247;
        bh=UJJOr+1Zu/xCfSQOhz+1aSAA9ArZAZFN/LkVGHPS1g8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QrP1KJDm8cSX4Nr1MGRoNra4yBeYO12+0Hxx0ScPh0XItPm7qHopZA5bX4Z4thtpr
         2ccG6YcIU/3SHkgFOLRiZQGf44+yhER9NOCS0qdhtTJsCSwyCQ/vuHXSY0M89hjvxV
         5JZTcc2J54G+nS6v22szHKl9TbFYiuytYIddFIwWqIJ5Nqtqy7g9zaDE1U6qV17d91
         Owx5ucgHArTPvFPx2U8EoisOrwo/AFcFBooICsB7IOM14p3xxcMSHAM4MmFZ/DIu1P
         6VKtL0eTPcoxqWMsOQ7cVHm5tXfL+AiXs5J9kj06rqgW4quNd0qqrOxWV4uFyTu9P6
         oRssXFUqtpEVQ==
Date:   Tue, 29 Nov 2022 21:14:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Elad Nachman <enachman@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>
Subject: Re: [PATCH v2] MAINTAINERS: Update maintainer for Marvell Prestera
 Ethernet Switch driver
Message-ID: <20221129211405.7d6de0d5@kernel.org>
In-Reply-To: <20221128093934.1631570-1-vadym.kochan@plvision.eu>
References: <20221128093934.1631570-1-vadym.kochan@plvision.eu>
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

On Mon, 28 Nov 2022 11:39:34 +0200 Vadym Kochan wrote:
> Add Elad Nachman as maintainer for Marvell Prestera Ethernet Switch driver.
> 
> Change Taras Chornyi mailbox to plvision.

This is a patch, so the description needs to explain why...
and who these people are. It would seem more natural if you, 
Oleksandr and Yevhen were the maintainers.

Seriously, this is a community project please act the part.
