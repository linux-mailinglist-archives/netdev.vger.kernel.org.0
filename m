Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8CF61A041
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiKDSsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKDSso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EA52F00F;
        Fri,  4 Nov 2022 11:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 825616230C;
        Fri,  4 Nov 2022 18:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA7EC4314D;
        Fri,  4 Nov 2022 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667587719;
        bh=YOVWBfQa9OqvYyzMeQsD63kY8dwF5YGLRC4BmattvKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=df2W3F78KU5UBALZZavDtPxzF+vCEteePbZhFvW0Fh1bVzjyBa3PX35mGORzHRDOR
         Sm5i2CWm6nGpKIGJLZTAjg/dnwQVclIOlScOU1l2NLASlJlQ0J8xgV6CoBkXfOMHk9
         en4bza+d9gNDUx7TNYp8KTKUHri/Sj7AK9M2TtrG3+/VfEfcXxxnIwUlyG6+d5HwI+
         wU7EHfn3jZqAT2QswLhmjqaO4nJVpgyEXcWKJqXXsT7fgbUQ88wR7fw461VyXHjpbM
         mgcKXIBy2aR018x5Bn8JcL0h9xAvZhfbrYMW5DlbHUnnaUKxQNOFac8wVGIasusYF+
         ej7hZdc511TBw==
Date:   Fri, 4 Nov 2022 11:48:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     jiawenwu@trustnetic.com, mengyuanlou@net-swift.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: libwx: Remove variable dev to simplify code
Message-ID: <20221104114838.4ca54ea2@kernel.org>
In-Reply-To: <20221103071956.17480-1-tangbin@cmss.chinamobile.com>
References: <20221103071956.17480-1-tangbin@cmss.chinamobile.com>
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

On Thu,  3 Nov 2022 15:19:56 +0800 Tang Bin wrote:
> In the function wx_get_pcie_msix_counts(), the variable dev
> is redundant, so remove it.

This patch doesn't make any difference.
Please consider not sending similar patches to netdev.
