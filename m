Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C606A7AA7
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 05:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCBEwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 23:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBEwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 23:52:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22323B3DA;
        Wed,  1 Mar 2023 20:52:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3E50B811A1;
        Thu,  2 Mar 2023 04:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEA3C433D2;
        Thu,  2 Mar 2023 04:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677732724;
        bh=wxYb0rqfnXEfjAQEZ8pFHQETlDfakQOYBQULusm6EoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UIwZEk+tzcVC8dHiiW4zZHFjyLMOATJ83rKAkNZOZRUOpn+QkWKORgfV5hUNOZAPj
         06gXX/izG/LWrsFZDSOXJ6amqfe6RZpdZ5KE6YrzralNu5Ii3bXhjut1yklc5JMYqy
         D4Y7eYiEq+KFOmF6LlZeGFQ8PA6DUKV3+gR9DM1LYqR2k61dN3bEvLe8pU/OBfhS6n
         ywe5hYs4kvUGLuBcvzf53qZHQFrNhbbaQ5A/wP1m0ekFFsYh9xL5cHnm0NUvgX7DHF
         si+KYn5Ec1vjCdWsZD9VvrDOe4ZNibqJd1kccQ79jFu16I9cvh0puOdn5WNkQ766Jk
         0i52Um5QWNiGg==
Date:   Wed, 1 Mar 2023 20:51:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>
Subject: Re: [net PATCH v1] octeontx2-af: Fix start and end bit for scan
 config
Message-ID: <20230301205158.4108dfc8@kernel.org>
In-Reply-To: <20230302041018.885758-1-rkannoth@marvell.com>
References: <20230302041018.885758-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Mar 2023 09:40:18 +0530 Ratheesh Kannoth wrote:
> for_each_set_bit_from() needs start bit as one bit prior
> and end bit as one bit post position in the bit map
> 
> Fixes: 812103edf670 (octeontx2-af: Exact match scan from kex profile)

You're still missing quotation marks. Preferred form is:

Fixes: 812103edf670 ("octeontx2-af: Exact match scan from kex profile")

You're also missing a change log.

More importantly please read the rules:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

Take a couple of days to think about checking your patches before
posting them, and how spamming patches hurts the project.

Repost this next week.
