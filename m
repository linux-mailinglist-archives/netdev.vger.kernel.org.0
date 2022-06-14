Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0930D54B92C
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357262AbiFNSpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357432AbiFNSpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:45:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7442239F;
        Tue, 14 Jun 2022 11:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 287E3B81A49;
        Tue, 14 Jun 2022 18:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2022C3411D;
        Tue, 14 Jun 2022 18:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655232219;
        bh=hNqwY4aL0jMkV10U2AlTRcrrtZltd2gbKOkCrbIAQbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Op9dc0f+GKqkHiQMzF4w+6853Q3Xztejp6lsLVlKeetPIZ1CZWxmF4q3LjHI//VeC
         Z1tZPSH/E10koTgcEcUEHwutOY31ntEJ3bt7vVHy4cjBmG/FnFYYDDoLZbRWfUT6iE
         PGySPtEjWbRft1leDM8NILlQ0dhCVAesxzKE6XtwHsLqnSigBw/hLi6GKYM9RDby1h
         uaVZj1sEvoOhj/jEDOlVR0/53e+ORCvTZHS3NmtF8ulVKbJYHUurbDQtZaav4osRD4
         Iv+d5HFab6QOhHJpWDFf9PDCz6MyA0brFwBfmJO2L0NeaUTKA1iMGcJVUNi43g9aEa
         JV+h/PwcycrDQ==
Date:   Tue, 14 Jun 2022 11:43:39 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [GIT PULL][next-next][rdma-next] mlx5-next: updates 2022-06-14
Message-ID: <20220614184339.ywrfx6zgxs6bo4mg@sx1>
References: <20220614184028.51548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220614184028.51548-1-saeed@kernel.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/next-next/net-next

net-next patchwork bots won't see this one :/ .. should I re-post ? 

On 14 Jun 11:40, Saeed Mahameed wrote:
>From: Saeed Mahameed <saeedm@nvidia.com>
>
>The following changes since commit f2906aa863381afb0015a9eb7fefad885d4e5a56:
>
>  Linux 5.19-rc1 (2022-06-05 17:18:54 -0700)
>
>are available in the Git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next
>
>for you to fetch changes up to cdcdce948d64139aea1c6dfea4b04f5c8ad2784e:
>
>  net/mlx5: Add bits and fields to support enhanced CQE compression (2022-06-13 14:59:06 -0700)
>

