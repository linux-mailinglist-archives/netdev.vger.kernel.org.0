Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B71B618F44
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiKDDuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKDDui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:50:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F225D13DE2;
        Thu,  3 Nov 2022 20:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 872A8B82B60;
        Fri,  4 Nov 2022 03:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B019FC433C1;
        Fri,  4 Nov 2022 03:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667533834;
        bh=FyzXENV7WIn5Uu5Adesc2hv84yU5ZUifhCcXpjv7AxY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rRUafkPmNamHHAzrr9ZpHYSQa0E9OV1llpGUVJYgC5gMPCmEqmkIznEaAC4rCxtHl
         d43Curjpua5SgxtS2MEc1dj4orWiAWSucQU8WJ2wM8agLFcHrLm2cBVLP1DBch7vtQ
         36l7OJnobeVu7AhEGByHzS3i+tb2hBxzPBz0GiWQdCVZQioqOZfWqLmNOEDcrE83nO
         rhs3gZslZGNFaOgSBPf/KN/0HGM2Zhw7Qpdaws8AJrLf3X5B+Vgz5EogM1DJBF/QO/
         nIHTZAikqPzVVNJFpDRWSKgtCry1WDnCYERwx1HkATQHOUmAMATsRtGY8ZofMddYCO
         DoAcyqlyzTXMQ==
Date:   Thu, 3 Nov 2022 20:50:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhang.songyi@zte.com.cn
Cc:     Shannon Nelson <shnelson@amd.com>, snelson@pensando.io,
        drivers@pensando.io, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, brett@pensando.io, mohamed@pensando.io,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiang.xuexin@zte.com.cn, xue.zhihong@zte.com.cn
Subject: Re: [PATCH linux-next] ionic: remove redundant ret variable
Message-ID: <20221103205032.4fe32f58@kernel.org>
In-Reply-To: <17ef4641-7cb3-fea8-4b1a-30b90c1719a1@amd.com>
References: <202211022148203360503@zte.com.cn>
        <17ef4641-7cb3-fea8-4b1a-30b90c1719a1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 09:07:34 -0700 Shannon Nelson wrote:
> On 11/2/22 6:48 AM, zhang.songyi@zte.com.cn wrote:
> >  From 06579895d9e3f6441fa30d52e3b585b2015c7e2e Mon Sep 17 00:00:00 2001
> > From: zhang songyi <zhang.songyi@zte.com.cn>
> > Date: Wed, 2 Nov 2022 20:57:40 +0800
> > Subject: [PATCH linux-next] ionic: remove redundant ret variable
> > 
> > Return value from ionic_set_features() directly instead of taking this in
> > another redundant variable.
> > 
> > Reported-by: Zeal Robot <zealci@zte.com.cn>
> > Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>  
> 
> Acked-by: Shannon Nelson <snelson@pensando.io>
> 
> ... although these changes usually go through the net or net-next trees.

net-next in this case, but it doesn't apply, please rebase and repost.
