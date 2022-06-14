Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6223854B87D
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345285AbiFNSXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344158AbiFNSXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:23:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103EB1C117;
        Tue, 14 Jun 2022 11:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B664B8186B;
        Tue, 14 Jun 2022 18:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6A7C3411B;
        Tue, 14 Jun 2022 18:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655230986;
        bh=Rc+ikQn5iyEXO8TfC5w85RTpq4loBD+imTSYxEWK3vo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kPnelKaCvp3BHqmVV338+7I+iGZZMPRJ9/r2Wl+JEWkf+JAY2G0f06rmy3pxJwL6D
         JHg/3CXyNfm/EOc8erYCABGuS8zmUrV0CdsQ7Pqi9LxuYNkS+tEg3KLVYX+1mabPsG
         gja6HHPJ3d0v72RTb9m/rh77ylqVrISL3ILIXUILtHCnoDfakQm2i3IsuPqMH6rFZX
         DBpydSBunVmMMhjByo4Wd/j0A3EPKdkFc0aUOyScqeKK7eoqj0OvXasZApcnXn6jSr
         JuYfosi77cEA1it9qelIIwewl9tNDhEzDkKYmDWtWM1Gz+xCWK7l+InL+lMLJ/pJI1
         Qy9vU9/vctN9Q==
Date:   Tue, 14 Jun 2022 11:23:05 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/6] mlx5-next HW bits and definitions updates
 2022-06-08
Message-ID: <20220614182305.wq27k5ggxhkv5inl@sx1>
References: <20220608200452.43880-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220608200452.43880-1-saeed@kernel.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Jun 13:04, Saeed Mahameed wrote:
>From: Saeed Mahameed <saeedm@nvidia.com>
>
>Updates to mlx5 HW bits and definitions for upcoming rdma and netdev
>features.
>
>Jianbo Liu (2):
>  net/mlx5: Add IFC bits and enums for flow meter
>  net/mlx5: Add support EXECUTE_ASO action for flow entry
>
>Ofer Levi (1):
>  net/mlx5: Add bits and fields to support enhanced CQE compression
>
>Saeed Mahameed (1):
>  net/mlx5: Add HW definitions of vport debug counters
>
>Shay Drory (2):
>  net/mlx5: group fdb cleanup to single function
>  net/mlx5: Remove not used MLX5_CAP_BITS_RW_MASK
>

Series applied to mlx5-next
