Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4566031F5
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 20:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiJRSEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 14:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiJRSEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 14:04:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA135B7FD;
        Tue, 18 Oct 2022 11:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51706B820DE;
        Tue, 18 Oct 2022 18:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BC3C433C1;
        Tue, 18 Oct 2022 18:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666116287;
        bh=8w4Wdvk5e1XBKkroMgegwI50dlmqyv/btknfSYjQ9Uk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MtsBJe/nJpp+RRu3O852KH0Ysm4MP2Tz1+KjrxXZOf8EJ+XYBPkXZ1Ab34IkEeTPU
         ZRM0tZLa+dIasdlYwnAFOLW4rNeE1Khz4praZ2dzdEcHDR5LlW1dpdvAm7BNWafljW
         yYcJ+3diYld/aquyqsZc4vcqO5wTJsv/mKIJfbr3qmC4gf1uDPWZ2Nj0X8yDGZI9p2
         SpDRf+nJLsBFLwpgUgwIkqNMKn7ZAH9pSkjaKrQjkOTpqkaBxJXhgxNWC6XPgQgdqO
         7UcT8LlaP5VUDrGz0EwewVf45DG2WGM/koR7R1R5ggbrK7n6LgDqnvn5D+P6/BJdyP
         509eex70Qw7lA==
Date:   Tue, 18 Oct 2022 11:04:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Emeel Hakim <ehakim@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Cleanup MACsec uninitialization routine
Message-ID: <20221018110445.404c446d@kernel.org>
In-Reply-To: <Y05/QTz6qEoUINTw@unreal>
References: <b43b1c5aadd5cfdcd2e385ce32693220331700ba.1665645548.git.leonro@nvidia.com>
        <Y05/QTz6qEoUINTw@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 13:26:09 +0300 Leon Romanovsky wrote:
> On Thu, Oct 13, 2022 at 10:21:00AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The mlx5e_macsec_cleanup() routine has pointer dereferencing if mlx5 device
> > doesn't support MACsec (priv->macsec will be NULL) together with useless
> > comment line, assignment and extra blank lines.
> > 
> > Fix everything in one patch.
> > 
> > Fixes: 1f53da676439 ("net/mlx5e: Create advanced steering operation (ASO) object for MACsec")
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>
> Gentle ping.

Just repost. I'm guessing that the maintainer who marked it as Changes
Requested wasn't sure if Tariq was convinced and decided to err on the
side of caution. If you repost and Tariq doesn't disagree again the
case will be clear.
