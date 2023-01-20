Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10604675A79
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 17:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjATQvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 11:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjATQva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 11:51:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0A6C63B3;
        Fri, 20 Jan 2023 08:51:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BD7D61FE5;
        Fri, 20 Jan 2023 16:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF0BC433EF;
        Fri, 20 Jan 2023 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674233476;
        bh=mrUxIeP7SO+7wYdmQot6zlFHtouNGVAJdoQoC1FsGW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ivh4hJvLdbM8eltHRLfgswDLjFWc9gQQ3tpaWtCgC9SDKdm+QtIlrCqg3PEpme7gu
         ptMy+FRMOm3bA4j/00CxscLQnudk0yi4Uy0qcvopksiirQCXJN/iZfZpj1vtHuLdDZ
         CNFI5oUxSpEYGYQmozZqE9hFBmW9qj8NJ2DzNKDkq95gKmyyIyl2zDU/MlvT5mGCes
         cTkSdNG510yFkdAbS7P6IcXhPw5koR7Uf10XycyhYGbJGb728z6UysskLHdAuvfVIX
         AKuB85Cm+SSqaZL+TZyn2c9tgHPGBxB+3jAqylJI5mkNdFQDM4j213Xp+dv7TIlE9n
         Y8mFryHUquXSg==
Date:   Fri, 20 Jan 2023 08:51:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PULL] Networking for v6.2-rc5
Message-ID: <20230120085114.6c30d514@kernel.org>
In-Reply-To: <20230119185300.517048-1-kuba@kernel.org>
References: <20230119185300.517048-1-kuba@kernel.org>
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

On Thu, 19 Jan 2023 10:53:00 -0800 Jakub Kicinski wrote:
> Hi Linus!
> 
> The WiFi fixes here were likely the most eagerly awaited.

v2 coming, in case you haven't pulled yet. Extra stuff went into the
tree overnight, insufficient communication between netdev maintainers,
IDK..
