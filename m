Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D137167D223
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjAZQwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAZQwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:52:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606FFE384
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:52:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AA24B81EB4
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A55C433EF;
        Thu, 26 Jan 2023 16:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674751946;
        bh=vmbpOO6aJ0hIR6bNw94b2pW5+9o3yH7b+DODBojl7rw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mW6hmI4yfSqACDp63qEnDg5z/bJAMyGFj8Dy7qiesC9wUL+ygG9C6ExM4W+ZCF4Er
         XMUZN3hSShJcAQvQ8K5aOCxQoTiznUXG5yDdvEYWtawmaCaJChflIKltssI9olZd4N
         bU6kiUZX24vkv22raUgJiybliaKoF76cd0zLgUuK923ssGQJsTH4Ih8M1TG1vMoplJ
         lVhVVRiXexeM5NpG/KcI6yiFGg3wN5IJqaqUef7n/EYu8KJKOVVcS5pTbpdZxHXVXq
         rK0Wm2JDwmSimuqvOD8Nb6XtDR3hiWDu9tWFHevLtyhOV/jfkoPD+VncUT0q+KLXHh
         jAYi3/k3LcQbg==
Date:   Thu, 26 Jan 2023 08:52:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v2 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <20230126085225.56589846@kernel.org>
In-Reply-To: <2d7dfc88-df55-8aec-5d23-5e8bae05fa77@amd.com>
References: <20230124223029.51306-1-alejandro.lucero-palau@amd.com>
        <20230124223029.51306-3-alejandro.lucero-palau@amd.com>
        <2d7dfc88-df55-8aec-5d23-5e8bae05fa77@amd.com>
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

On Thu, 26 Jan 2023 14:32:15 +0000 Lucero Palau, Alejandro wrote:
> After splitting up this function offset variable is not needed/used so 
> patchwork reports this as error.
> 
> Should I send a v3 with this fix or better to wail until some review is 
> done?

I'd post the v3 - it's been over a day and people de-prioritize anything
that got a build bot response.
