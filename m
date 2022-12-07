Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9E2645808
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiLGKhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiLGKhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:37:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4753A2F02B;
        Wed,  7 Dec 2022 02:37:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D74A461169;
        Wed,  7 Dec 2022 10:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74144C433D6;
        Wed,  7 Dec 2022 10:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670409428;
        bh=KY7YWJF5oa3fs9ZE2wvbBGq5KADvA3wXFexep9vKVxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PU0COV5USvTeV+KLv9v8U8W4ISb34xnl83IuPS1kXhitlUw26rjKWyZWCsSfEmI+5
         QvTH2td0P9UeEXi956u3J0BjpDbpjM7JamzkxZx+ASN4dE/r7igzgvlOSQ3zcV9IKy
         taknTlmuSUCL1oOoCoDDBZH0V2dgaf4abj3J+ZTd0xp8BVYzj2sw0bd+YgOvr+6DJh
         WDD48Ay+JLm5iSQZt8+Ta4eVB9WlQYVPQ1Q7YpPBNVxk1rsBczt9EN8IvmEgQWvoaX
         u1W3VfduIqv53xXEPAwMorMMDl/Q/AW/3ioCnaabIDy+hG4GIhETpwQNs9LvtHbPmP
         PrhIHU3t6iPBw==
Date:   Wed, 7 Dec 2022 12:37:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] xfrm: Fix spelling mistake "tyoe" -> "type"
Message-ID: <Y5Bszxs5Mtaxdf2x@unreal>
References: <20221207091919.2278416-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207091919.2278416-1-colin.i.king@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 09:19:19AM +0000, Colin Ian King wrote:
> There is a spelling mistake in a nn_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/netronome/nfp/crypto/ipsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
