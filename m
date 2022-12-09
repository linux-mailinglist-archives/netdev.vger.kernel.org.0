Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E852E647B1E
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 02:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLIBFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 20:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLIBFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 20:05:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDC794192
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 17:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EC7A620FA
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F697C433EF;
        Fri,  9 Dec 2022 01:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670547900;
        bh=NqmWHPpGgRiO1QV4CwhkoYCcNsYdvQfXI9mgH5cge30=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GoDimUQKK/Tka3G7V+oL7bl82tzjXIebUrUc/Vpb22mYEXds2bGEw0TqO9bBVDzKy
         hNoSmOaP94cv8ih3ItuVtUCn4vrQehl8iXFbvY8XyeAzVMdLWnctY5rlHy3akYPW2l
         6eb7fHmtH0B3Fd8jlPfCLu4jQykAeJcnY7cjUhQGNaMUhculeNPsxP7JHAX9CprOrh
         HLS+ClnfOvLzeqpPfWGY+giCeuKqnTGh22rfICvRh2abedvr99caGI1CMGzMuBDknk
         3/Vclu28ux3pptxwzBIqxRDocA6UT4Rlbtv2Jz8uki8NkNF4jFP3qVeLSiTjkX25E1
         nf8PKBMzmh2JQ==
Date:   Thu, 8 Dec 2022 17:04:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: SRIOV, Add 802.1ad VST support
Message-ID: <20221208170459.538917da@kernel.org>
In-Reply-To: <Y5GgNlYbZOiH3H6t@x130>
References: <20221203221337.29267-1-saeed@kernel.org>
        <20221203221337.29267-15-saeed@kernel.org>
        <20221206203414.1eaf417b@kernel.org>
        <Y5AitsGhZdOdc/Fm@x130>
        <20221207092517.3320f4b4@kernel.org>
        <Y5GgNlYbZOiH3H6t@x130>
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

On Thu, 8 Dec 2022 00:28:38 -0800 Saeed Mahameed wrote:
> So if the part in this series of adding support for 802.1ad, falls under that
> policy, then i must agree with you. I will drop it.

Part of me was hoping there's a silver bullet or a compromise,
and I was not seeing it.. :)

> But another part in this series is fixing a critical bug were we drop VF tagged
> packets when vst in ON, we will strip that part out and send it as a
> bug fix, it is really critical, mlx5 vst basically doesn't work upstream for
> tagged traffic.

What's the setup in that case?  My immediate thought is why would 
VST be on if it's only needed for .1ad and that's not used?
