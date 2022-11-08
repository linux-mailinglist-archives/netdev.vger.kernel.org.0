Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE15620A6B
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 08:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiKHHkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 02:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbiKHHkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 02:40:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75DDFAD6;
        Mon,  7 Nov 2022 23:39:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A4316134B;
        Tue,  8 Nov 2022 07:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8171FC433C1;
        Tue,  8 Nov 2022 07:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667893164;
        bh=bTfnB6EcwsGLzj9IXfp53wlX77b240UHcHwLQ+HQpZU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Y/DFi/DD/MSlII3DS9DdtUs52h1KXDBl3hug/F1aJrgh6RR+ouBCB5KD8u8QHXBKV
         YSbOdDNj3IFCiHQHbcYLg+Ce/TTl/KaVNcQQjDWcxAVvPiJm7DLRveI6LbwYyXykdc
         mu308Xxsms2jv+BFJnuLHLZIf7j9nuJDRC5vZ/9pcj6JirIeegKYxsskRIKI4ux/Cy
         7a2Zqeqi2xyj00KwPCP5MJAgFmwrbR6z/9UDf2x2o1pkRD9jIjturKidQCQ0rcL0Mo
         SZrTOkEZTGkvdr2MoqzZqYuw4nRde0bAX1e6htCqUAAKDLrcVR32Nm6xV5W+tw03GS
         iojyJSrF104lA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/30] wifi: Use kstrtobool() instead of strtobool()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1ff34549af5ad6f7c80d5b9e11872b5499065fc1.1667336095.git.christophe.jaillet@wanadoo.fr>
References: <1ff34549af5ad6f7c80d5b9e11872b5499065fc1.1667336095.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166789315924.4985.15656557899615153469.kvalo@kernel.org>
Date:   Tue,  8 Nov 2022 07:39:21 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> strtobool() is the same as kstrtobool().
> However, the latter is more used within the kernel.
> 
> In order to remove strtobool() and slightly simplify kstrtox.h, switch to
> the other function name.
> 
> While at it, include the corresponding header file (<linux/kstrtox.h>)
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied to wireless-next.git, thanks.

417f173532cc wifi: Use kstrtobool() instead of strtobool()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1ff34549af5ad6f7c80d5b9e11872b5499065fc1.1667336095.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

