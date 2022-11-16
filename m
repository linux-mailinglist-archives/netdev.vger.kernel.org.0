Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CC162B694
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiKPJdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiKPJdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 04:33:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760C012AA7;
        Wed, 16 Nov 2022 01:33:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29F5CB81C21;
        Wed, 16 Nov 2022 09:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAAEC433C1;
        Wed, 16 Nov 2022 09:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668591198;
        bh=oiqJ939Mq4wKHx4zNsuCeZhl6jCHPbHMVW7rkxEToCQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pbXAsseYlki20xQ6ZltMls18XrTBw8LiOcLd+KzzDn/PBAJLQW65dvy6U3OprBq+x
         /9EQ+WMNmpWVhTF2ny4E2Sz0AtvsaZ2P2DRRrJ7CkX32NrUQQB0VwiJeskLwdqBwaU
         N/wV4YhnPP7UK0g61XTyCSFWD8U1ksbit7NUDeu4pBVUth4n0ihFYTA+/Mp5dt6BSb
         F9WG1jAUHOT5pcVx6kdvH2+0SI9Nn6FwqXAypXbgEBE2z4paQZXBAq0KNRJO7j/iv3
         EBUETmJBPY51X8bXEnLEXa9x7hjajEdaj2RrGktDph97c8hL545pza4sLLgSFpPNJP
         tqI4rn4IsEHwQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw89: Fix some error handling path in
 rtw89_wow_enable()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <32320176eeff1c635baeea25ef0e87d116859e65.1668354083.git.christophe.jaillet@wanadoo.fr>
References: <32320176eeff1c635baeea25ef0e87d116859e65.1668354083.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chin-Yen Lee <timlee@realtek.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166859119398.16887.2462368956174641682.kvalo@kernel.org>
Date:   Wed, 16 Nov 2022 09:33:16 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> 'ret' is not updated after several function calls in rtw89_wow_enable().
> This prevent error handling from working.
> 
> Add the missing assignments.
> 
> Fixes: 19e28c7fcc74 ("wifi: rtw89: add WoWLAN function support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

61ec34dee266 wifi: rtw89: Fix some error handling path in rtw89_wow_enable()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/32320176eeff1c635baeea25ef0e87d116859e65.1668354083.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

