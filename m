Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B93358B311
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 02:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240503AbiHFAjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 20:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbiHFAi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 20:38:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF61718B3F;
        Fri,  5 Aug 2022 17:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6024EB8298C;
        Sat,  6 Aug 2022 00:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FB5C433D7;
        Sat,  6 Aug 2022 00:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659746336;
        bh=ZIQXYKUnAbp65n7jC8/CLOC3hlptadoVGkFeqroUmTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cLfvgjS5RNNFFN7oJYHi/HA2+F6o7+nQyihjUJoCy8mizhzKNebqMaJNq+GHEgJgo
         0ozUWAsrPb7kAgyFZuo4sQxWOtzzemPOmwxEvF0FA/QjjH1XjqwrdqM/aH81cTyq6H
         vkS1vw5gEBCEou9N+qGnmSrXdzrcQNJa2T7jfZjqeVFgSaGfTFcuWk6ZH/gE9LPol+
         vXJbd+wPa+j7TMs5auoLRO1PpnZUwEsjTioMgfN55sc1Skn+TDO9dPdb/WgHZhYcKY
         nV3HT9dT7N68AGDglnM04H0IqJXu/T4vZuc0dgYXBf/bGUWde9wts4hYVnD+7/OrGe
         aYWJHnw/h1XTw==
Date:   Fri, 5 Aug 2022 17:38:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Lama Kayal <lkayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Fix use after free in mlx5e_fs_init()
Message-ID: <20220805173854.0fff609f@kernel.org>
In-Reply-To: <20220805062606.GL3460@kadam>
References: <YuvbCRstoxopHi4n@kili>
        <2e33b89a-5387-e68c-a0fb-dec2c54f87e2@gmail.com>
        <20220805062141.GG3438@kadam>
        <20220805062606.GL3460@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Aug 2022 09:26:06 +0300 Dan Carpenter wrote:
> Anyway, it needs to go into net and not net-next.  I've told everyone
> else besides networking who asks for something like that in the subject
> that they can pound dirt.

We appreciate the special treatment! :]
