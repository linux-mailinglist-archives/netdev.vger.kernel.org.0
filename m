Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F5669F487
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 13:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjBVM3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 07:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjBVM3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 07:29:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BF0EC52;
        Wed, 22 Feb 2023 04:29:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8FF86142F;
        Wed, 22 Feb 2023 12:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE475C433D2;
        Wed, 22 Feb 2023 12:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677068945;
        bh=H2n9Hhn+qkxGGVkGijtYVg5UEC0Yvol3hKw+sPKeNPk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=UeqgMqEAMAD2zWdvKqa1UsN6BHg94gTt9JWkPuDyj+bckiyyd4GyUoQfSt4zTzNiq
         E/CMq/N8z2D4zw53sZwP8JuTN8a1lcMoDYJb6RuPpJZjPXvhJXp9WD/nJpSnbdWfFQ
         u9KDKdAkfexVO6feWrS9n7Q1jGJd5HAhTtHXyjR3xR7GabnMJ5jt4DQaq0bEvXkKSZ
         2LF1FHew2//fZsJA7Q6kSgk3LdDdEginn0Holfas65oKxeX5nDsx26+K86UHGtCUjE
         QQsWcxMSz6MLj5YnXkdr7xoo/pH9lrJO4aBu/MS/WCvx1ZCrNEjXeoViedwN1BToa6
         joC3z1hXJn9zw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] wifi: wfx: Remove some dead code
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <809c4a645c8d1306c0d256345515865c40ec731c.1676464422.git.christophe.jaillet@wanadoo.fr>
References: <809c4a645c8d1306c0d256345515865c40ec731c.1676464422.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     =?utf-8?b?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167706894098.20055.4595162521483783391.kvalo@kernel.org>
Date:   Wed, 22 Feb 2023 12:29:02 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> wait_for_completion_timeout() can not return a <0 value.
> So simplify the logic and remove dead code.
> 
> -ERESTARTSYS can not be returned by do_wait_for_common() for tasks with
> TASK_UNINTERRUPTIBLE, which is the case for wait_for_completion_timeout()
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>

Patch applied to wireless-next.git, thanks.

015bf4df8ea6 wifi: wfx: Remove some dead code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/809c4a645c8d1306c0d256345515865c40ec731c.1676464422.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

