Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6C0511063
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 07:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357795AbiD0FHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 01:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357793AbiD0FHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 01:07:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A345978FD1;
        Tue, 26 Apr 2022 22:04:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C17761483;
        Wed, 27 Apr 2022 05:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E72C385A7;
        Wed, 27 Apr 2022 05:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651035850;
        bh=g+J0i0TxiKiWFZjglFxdDZfwM7Abk9bx3U/hpY/vWBk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ChTjxKG5PtobXhy2/DvAV1k3i8eu30YUBQUBGLA1NReK4SnRdsxbvMIziQWlz5f2u
         m/VotBOM3r/5uwY+MZ2rluzaMyVOKeMdwym/VtJdrIkA73Zl+T/yPhl1Bb5Ut/C2IP
         VLkFY8DilyauGgQhSLVlHGr8v3/ZqXeMDCo9Aiy3Am0Kr23up8qFq35waUdnNRDNSb
         ZJ/1V0ulOMhtRhoBN7Vl77xxqvC9QaZQ/0hcwZM8AW5mgx3r350UnGZxXQ4kZSEbqv
         /OOux+ct8AETiwgfipAFGVLWBxqCCMznko5dGDof9xqTJpkPx9/C5xxs53kXvMYHUc
         v+5+iF/uhpMeQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtlwifi: btcoex: fix if == else warning
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220425031725.5808-1-guozhengkui@vivo.com>
References: <20220425031725.5808-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guo Zhengkui <guozhengkui@vivo.com>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtlwifi family)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        zhengkui_guo@outlook.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165103584603.18987.13591716309765600257.kvalo@kernel.org>
Date:   Wed, 27 Apr 2022 05:04:08 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guo Zhengkui <guozhengkui@vivo.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c:1604:2-4:
> WARNING: possible condition with no effect (if == else).
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

8c783024d6ac rtlwifi: btcoex: fix if == else warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220425031725.5808-1-guozhengkui@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

