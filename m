Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B97666518
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbjAKUxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbjAKUw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:52:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A57C3D9D0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:52:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D713B81CEE
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2F8C433EF;
        Wed, 11 Jan 2023 20:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673470371;
        bh=9NyQHt3Fadvy9Tit7gfIiX4YLLWkPqT3DbAgZvXjn64=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AIjp+XT0/1vwlUJiJcM6Kx7xWJTfvDOfCg83ZZ2VQOL5h+25rvjrLBlHQGw8d7va2
         cKOCmi6qeQs4rG6dGEgtkXmrYY8pIIwakz7X+scyrYLg5uR8Vezi3K4pHMXm5WPXt8
         HwkoH+DccdHIhQsUikSTJyidPIKyR24i7OdykEi4lsUe2GoaMBCbf10K4QS0bgRTUv
         HZpvAAmG087xJhns6ULWcRSH8TSucptO29bDc7IVVERUBpWfYKYElG3G6Gs2B/Bdgu
         aewGAkCJSskK37iBbwz1vVRhclv73TFjwRYrCJlR/oRk7QhzJpbF7/CMNsqFxWLNda
         6th7bFz0lMoDQ==
Date:   Wed, 11 Jan 2023 12:52:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 05/15] net/mlx5e: kTLS, Add debugfs
Message-ID: <20230111125250.2b89e28a@kernel.org>
In-Reply-To: <Y78aCH2xZLpFYSYs@x130>
References: <20230111053045.413133-1-saeed@kernel.org>
        <20230111053045.413133-6-saeed@kernel.org>
        <20230111103203.0834b3ce@kernel.org>
        <Y78aCH2xZLpFYSYs@x130>
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

On Wed, 11 Jan 2023 12:20:24 -0800 Saeed Mahameed wrote:
> On 11 Jan 10:32, Jakub Kicinski wrote:
> >On Tue, 10 Jan 2023 21:30:35 -0800 Saeed Mahameed wrote:  
> >> Add TLS debugfs to improve observability by exposing the size of the tls
> >> TX pool.  
> >
> >What is the TLS TX pool?  
> 
> https://lore.kernel.org/netdev/20220727094346.10540-1-tariqt@nvidia.com/
> 
> We recycle HW crypto objects used for tls between old and new connections.

I see, thanks!
