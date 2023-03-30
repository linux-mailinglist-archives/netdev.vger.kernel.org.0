Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8776D0CFD
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbjC3RjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjC3Ri7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:38:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E165EE04A
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC4F6213E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE17C433D2;
        Thu, 30 Mar 2023 17:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680197937;
        bh=Hi/Bdw7TdsSDKPWcqCvfNJlDVvOr7bExXEsa2mw/2f4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JS3iVolmOx61jyg4+Eo8+O7D2XfFiUhfBxsq6i+C1GY4LQbfUEo4JnGInR9AYDU30
         0J76dpeIrFK2+/hu51fhBhMtfOOZQfkEpAcZhpHFxIWd4S/H1qywcQGlya2V3UUhvD
         SnT4RpqdLrmr7aiyooahfAazHKiJfT0ioSZvmL/N+t6VJfCAzrZokD680wBCibVnrA
         HOuC8Mp2f50S+TQYIDj+GxMTHF6/bNAjjMdosXljD9ZUT1E/6szD1anmKVwX9xLs18
         uKmxLTrKI8VGu3Xk28MHnb8/JWCFx2tk2DMyznhI/3uQlybB93rYrr+kv/96uSySqI
         Ao1dIXNlM3UdQ==
Date:   Thu, 30 Mar 2023 10:38:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Roulin <aroulin@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: Re: [PATCH net-next] ethtool: reset #lanes when lanes is omitted
Message-ID: <20230330103856.4f725998@kernel.org>
In-Reply-To: <6e02aaab-18fe-692d-52cb-71212db44ade@nvidia.com>
References: <6e02aaab-18fe-692d-52cb-71212db44ade@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 09:56:58 -0700 Andy Roulin wrote:
> Subject: [PATCH net-next] ethtool: reset #lanes when lanes is omitted

This should have been tagged for net, right?

> If the number of lanes was forced and then subsequently the user
> omits this parameter, the ksettings->lanes is reset. The driver
> should then reset the number of lanes to the device's default
> for the specified speed.
> 
> However, although the ksettings->lanes is set to 0, the mod variable
> is not set to true to indicate the driver and userspace should be
> notified of the changes.
> 
> Fixes: 012ce4dd3102 ("ethtool: Extend link modes settings uAPI with lanes")
> Signed-off-by: Andy Roulin <aroulin@nvidia.com>
> Reviewed-by: Danielle Ratson <danieller@nvidia.com>
