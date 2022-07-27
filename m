Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3F15824F3
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiG0K5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiG0K5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:57:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77E248C90;
        Wed, 27 Jul 2022 03:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DB57618A3;
        Wed, 27 Jul 2022 10:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04918C433C1;
        Wed, 27 Jul 2022 10:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919459;
        bh=DOenbGEyKMzResO93nM7wzY+tBq3PUkFVWvhmEeO7po=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eqXe+tdNi7QaPsX3X5JWVVw5za33fa/vo0brylhzEJBfitd1aYYw1G54KkIWWnBSm
         gnuRJ0245MbKGbbYRBpKyMHi857l0kC4A2kiRf4S9KxYHYvrz8mLcoCw+dlGLzgaOr
         XoMlD5yeI/RhG2pJ2CWzyBvgLThz3YT0MHTgrE+W0o/KAhTBidc+szyBQNq5ORhg8z
         p2qxS4RZdR4ROUbU82EOs3vkZO71eHp9EMZmBavvDQDUoXEZVD/iMCkULupTBUKjIP
         QiREVfutCQ02PKhhYbxt+WqIySvj2TXFta3uDOIps7aASu0644xIraaEoUZRCyQM9r
         XzVhNmBNbNckw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [2/2] wifi: mwl8k: use time_after to replace "jiffies > a"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220606135449.23256-1-liqiong@nfschina.com>
References: <20220606135449.23256-1-liqiong@nfschina.com>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Li Qiong <liqiong@nfschina.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuzhe@nfschina.com,
        renyu@nfschina.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891945515.17998.4739659529760673769.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:57:36 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li Qiong <liqiong@nfschina.com> wrote:

> time_after deals with timer wrapping correctly.
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>

Patch applied to wireless-next.git, thanks.

8006bb53ca0f wifi: mwl8k: use time_after to replace "jiffies > a"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220606135449.23256-1-liqiong@nfschina.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

