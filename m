Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E90162CE90
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiKPXO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKPXO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:14:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67EEB7E6;
        Wed, 16 Nov 2022 15:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 532BD62045;
        Wed, 16 Nov 2022 23:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3FCC433D7;
        Wed, 16 Nov 2022 23:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668640494;
        bh=yLcT1KcUwGU+Y/O4btlWG+gdhwTDR25WaBalkRsSGeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b4GVJsXiWA6pipNf105iRM7AihNntnrvoR0FM7mvpU0LKaKDhJ4i+7/H0CmpjJK7x
         q8WcGZp92WU8ILfTT/YlhtuBbzoKPJPzfoFHNUIdWX46AIwvilgQZFghLK+1XoV5y8
         VoiqyPoTmVUUZ0sBPYcmOmyp8Kj9HV2GmzYmcnKNkdJbdVvX4ymmfaxtLmy6RW7tVm
         tW3Ti2voFL/E+YzpCAhJCrkot77wlwpDCg+att4qnNBRTCwJumYJ+vrq8AtSjHi/Rt
         Lt92/bkfEDwc+QKnXZPCz+ZXE7oSwe0VFqqVAaERNKvxRyLRKnqPxwFF0Pv29Y5AFN
         rN7ndMQbY60Vw==
Date:   Wed, 16 Nov 2022 15:14:53 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Message-ID: <Y3Vu7fOrqhHKT5hQ@x130.lan>
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16 Nov 08:55, Yoshihiro Shimoda wrote:
>Smatch detected the following warning.
>
>    drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
>    '%pM' cannot be followed by 'n'
>
>The 'n' should be '\n'.
>
>Reported-by: Dan Carpenter <error27@gmail.com>
>Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
>Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")

I would drop the Fixes tag, this shoiuldn't go to net and -stable. 
and please tag either [PATCH net] or [PATCH net-next], this one should be
net-next.

Thanks,
you can add:
Reviewed-by: Saeed Mahameed <saeed@kernel.org>

