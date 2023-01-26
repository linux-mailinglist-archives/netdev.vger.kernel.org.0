Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1077667D9FE
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 00:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjAZXzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 18:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbjAZXzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 18:55:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E404521C;
        Thu, 26 Jan 2023 15:55:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EA2160F27;
        Thu, 26 Jan 2023 23:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B99C433D2;
        Thu, 26 Jan 2023 23:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674777327;
        bh=b4RDpwEILaDiIt/LpUYj6ICO+dPIjXDR8ok9CctcPps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EjNRBD0x7DqI5RWqrQB53Z5Y0dhJERyDmr8qkJ5N0IoJEoVb5kEuCBlXqazqg6NTt
         6R1V2ndj99lVu1sCQxKtDdEvjIFacZKGSz+Lhy8uRjmFYWsORmUCS1u6B8hKs7DvvJ
         j1FgWk9FgznH/mM6ARjb4iGeX/fRGcraMjEx28xzEE+9uopEpF5TN4NUx/rv882+aK
         0qPw/IDwT4whMeGcK+EVs7cfVrMEUVyhvhE8ZLvKc3iXMSWP0zWUKUlOon9CyXo0NJ
         FLHAStWX96PnCHsfv4ZDYqqht1TBsrX82BA4jCSphv+pENkmWr6WVrpyCmT4VPx0nr
         kJTXOhmZm70/Q==
Date:   Thu, 26 Jan 2023 15:55:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Xiubo Li <Xiubo.Lee@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin Ian King <colin.i.king@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH] scripts/spelling.txt: add "exsits" pattern and fix typo
 instances
Message-ID: <20230126155526.3247785a@kernel.org>
In-Reply-To: <20230126152205.959277-1-luca.ceresoli@bootlin.com>
References: <20230126152205.959277-1-luca.ceresoli@bootlin.com>
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

On Thu, 26 Jan 2023 16:22:05 +0100 Luca Ceresoli wrote:
> Fix typos and add the following to the scripts/spelling.txt:
> 
>   exsits||exists
> 
> Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

You need to split this up per subsystem, I reckon :(
