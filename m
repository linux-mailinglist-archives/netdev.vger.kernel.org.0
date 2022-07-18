Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C705781C5
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbiGRMMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbiGRMMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:12:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320EA248CC;
        Mon, 18 Jul 2022 05:12:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B701361486;
        Mon, 18 Jul 2022 12:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDAAC341CB;
        Mon, 18 Jul 2022 12:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146321;
        bh=FAzcf2OOCtRHwD6m0rdJUCMjx3z0A4vGlRzMlpeNQ0s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=P6yPWDBI3Mylok8s+VZ7qHwcLWcORhog3CEYIrsge3pQOjB9lkKL0IGjCZCmamcmv
         /54dxd1gAac22bdD7O7m0yme8ESdiRgUfAhMUVrFKToWkk0Cg1uCN/QDun3rRWenyk
         z3cQWl91YcOsncbkoUTEjI0TH4WtFzGl3cy/tmrxkH8AKGzetMjjLBhG9hmz0HZGT6
         Hrw2XOWmFtzrEbY9UL9dZKQGoZrnmjSNNGpzKyP9nG0n7ZMI2FB02INfUudJ01rpIp
         MRYTsdrAgWhhguB58Xp1tIeBbI1fWRvCi5WbaBP8zRQfgLk2LhyKw8SAnLBruiUteN
         0ognhDoiN9ctQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rsi: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220710043007.33288-1-yuanjilin@cdjrlc.com>
References: <20220710043007.33288-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814631703.32602.8193469714335769695.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:11:58 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'the'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

9a46c7d8d6f8 wifi: rsi: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220710043007.33288-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

