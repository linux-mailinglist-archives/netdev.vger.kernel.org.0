Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA1C62A11C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 19:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiKOSJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 13:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiKOSJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 13:09:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE3055AA
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:09:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB390B818DC
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 18:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3C9C433C1;
        Tue, 15 Nov 2022 18:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668535793;
        bh=hnqRltByI7W07GxH0NGO8zqZ5s3SEpszb3sAqw9hMpk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ijytHgoeDlYsV/oiPjwkBi6Qtc0WDJlW37xBrgXAS7Pm7635rMhPHufIlIi0CnXEB
         8ds6C/zj1cKHPiTJOzjIP0ORSl1+llVPM5FLuorBykJgGTSl9zr6AazlmaFjPms9F2
         P2ehbC8htcKWC+AyDSkM4XEpmuEnLga+h8jdpyZ2We84puOR7u1fOy5g6IskkOcOIC
         gpXtc4ZzhJlZoJfo4MJZ6x6YErU1/9jB7WaKIkIwna3C+KGUtpFzjdrmW9viZ4l5LJ
         0zb1/1LDiFI7Bre9VvQjOGlgfeTFU51r/4ABupL4blUnnKScmU9G4PpwpOc6MEzotr
         TqY/RHDvJFgIQ==
Date:   Tue, 15 Nov 2022 20:09:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <Y3PV7HM5cDoZogCY@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1667997522.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 02:54:28PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v7: As was discussed in IPsec workshop:

Steffen, can we please merge the series so we won't miss another kernel
release?

Thanks
