Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D616439C9
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 01:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiLFAJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 19:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiLFAJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 19:09:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03E51834E
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 16:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51411B815A9
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 00:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88283C433D7;
        Tue,  6 Dec 2022 00:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670285355;
        bh=2r93YR1jOiA1Dld4/nkskILZFtlnZ5fBuXCKBUIq9wA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oXSgsy0Zdiwfol4FnM2RcuEdausL5abQQ2cmeEsZfmJuFbIinl3DBttnqoHEqqsya
         bdRey8VFHjjrqNGaIsHCDrZj/Q/QvvWn7jNPa2v7gDcf9gvrAS15ILb11Ad98b8PKk
         a3Z/1/RvZyt4evCSIhLIlkNQNEN8Q/blaqfqhLoKSIGtPXNj5yYD0r5Zd2p1rvfI6d
         s8SmakN9AeX/GwAakQaqA25ZemPmG8RSIy5rsdYH5GB5VnvU2o3uWkSn2aZvY/bzq+
         XGaMO/Euqb64XX8TOvnZtLY/TnFHNHUsXhMQjZstD3jZK5tzJCCOEx6WBJHVnhnV96
         VyDHxOSOJfFPA==
Date:   Mon, 5 Dec 2022 16:09:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <20221205160914.37021a13@kernel.org>
In-Reply-To: <20221205092304.GC704954@gauss3.secunet.de>
References: <cover.1669547603.git.leonro@nvidia.com>
        <20221202094243.GA704954@gauss3.secunet.de>
        <Y4o+X0bOz0hHh9bL@unreal>
        <20221202101000.0ece5e81@kernel.org>
        <Y4pEknq2Whbw/Z2S@unreal>
        <20221202112607.5c55033a@kernel.org>
        <Y4pV6+LxhyDO2Ufz@unreal>
        <20221202115213.0055aa4a@kernel.org>
        <20221205092304.GC704954@gauss3.secunet.de>
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

On Mon, 5 Dec 2022 10:23:04 +0100 Steffen Klassert wrote:
> The two driver series and the core series would be about 40
> patches. If you are ok with taking such a last minute PR
> into net-next, we can go that way.

Fine by me.
