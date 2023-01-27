Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3439467DF0D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 09:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjA0I1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 03:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjA0I1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 03:27:15 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D8838026;
        Fri, 27 Jan 2023 00:27:14 -0800 (PST)
Received: from booty (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 35C3440012;
        Fri, 27 Jan 2023 08:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674808033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lv7ewrCAvVErHpI7gEVltoemr6ftqALjKTyaA7BAA5M=;
        b=kz/9gVbMcBfzuF5NuB1JYn52NbhQxvOpuk40tZWkVTEp4NsySfuSzWFlpCej5onQD8DtzC
        TSvDRXO2FoUtFg58DJ+T4Kp1A05artpCbwJyzPxAMu6aT5J42TUKlP2Ahl3F2bbzOLAFfT
        yq/L+/a1ISoDaJ5c7t87knlCgdcMZlbaeXYZsBy4HfnltPkZbHI7O7j5PTxWBOC6Tb3pgT
        WhR7dR81Hy0quUooSXLcpK65PjfzBuPzCmkykN6yAFeCf29yx85clMRykicEWo7UhPBsoY
        EIGWH9Zi7KpFFM9Uhti1pxW/C65tfZpOf0z/mu++BuZh75AMGo3iDewPiLBsUA==
Date:   Fri, 27 Jan 2023 09:27:08 +0100
From:   Luca Ceresoli <luca.ceresoli@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <20230127092708.43247f7e@booty>
In-Reply-To: <20230126155526.3247785a@kernel.org>
References: <20230126152205.959277-1-luca.ceresoli@bootlin.com>
        <20230126155526.3247785a@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

thanks for our review.

On Thu, 26 Jan 2023 15:55:26 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 26 Jan 2023 16:22:05 +0100 Luca Ceresoli wrote:
> > Fix typos and add the following to the scripts/spelling.txt:
> > 
> >   exsits||exists
> > 
> > Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>  
> 
> You need to split this up per subsystem, I reckon :(

Ironically, it was the case initially but I have squashed my commits
based on several prior commits that do it together. Now I rechecked
and it seems like this happened only until July 2019, so apparently the
policy has changed. Will split.

-- 
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
