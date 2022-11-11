Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027316264C5
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbiKKWtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiKKWty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:49:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E251391EB;
        Fri, 11 Nov 2022 14:49:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23CE762122;
        Fri, 11 Nov 2022 22:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9BFC433C1;
        Fri, 11 Nov 2022 22:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668206992;
        bh=DDLxGHdEgOEXaPY8AdKbdN/ekL77SXoM7Q0SCIi4X8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tq9ZfsVQMiaN5Y3eHrzsTIYDqLV0XQTW26FMZndtxtlI/2UmEC14xICkmgoxYUuj0
         uaEb2stn+3xWIPveST0rKYyJ9eboZQ3E23FoBjpp7HVpPVZHBa+vElo+Kp3lJ024GP
         RRXPmlR+9pxrllme1d4UQ/YmfrxV6e9bfafm8arcZzGjpKUkk6LM10jguAScAcqI+O
         xWXwaWHeC1/kDhxV+89EnoxBIG8W56ICky4Gv7ZZikWsW/DS+WppU7A8OBjFeK17IH
         tmILJSP5ZI1qGkY1g25FHQ7irEKILIMfWukDwppVrDcaz7itDx5SEN/LtezUHM02Si
         JTOcZHovIgf7g==
Date:   Fri, 11 Nov 2022 14:49:51 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Fix spelling mistake "destoy" -> "destroy"
Message-ID: <Y27Rjy0Y5VgRrBak@x130.lan>
References: <20221031080104.773325-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221031080104.773325-1-colin.i.king@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31 Oct 08:01, Colin Ian King wrote:
>There is a spelling mistake in an error message. Fix it.
>

applied to net-next-mlx5. Thanks 

