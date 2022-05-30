Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C805376AD
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbiE3IaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiE3IaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:30:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB5A75212;
        Mon, 30 May 2022 01:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46B8B60DD8;
        Mon, 30 May 2022 08:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877D7C385B8;
        Mon, 30 May 2022 08:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653899411;
        bh=/tZ0Vu5aT5OryBX4TVZ47LFjNaoFWQryrceZ5hFB8xc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qSlraGWG9JUGjkvG0CRRTWCgIWF/IiZCaeXEKBKfLxcG/Jqsm5RK0KcYVFmnchGHq
         S9oj/RZOSU6rXy7lp0T0SLivjFJwiqscWDN/LxYtxqdGmjMMZe3GLoomolYJ/+wHlo
         TX5fA/DToXiS4JFCJjNzQkxFKVtZOMI1iHG/Pki8PqWJVCdSuYHGV07x3/IF7Uky89
         gnY4tU7XawTsYc6+Jk42/+Kv65maydbURDWrwOV6jtMhQoeGXqwD7p3R+yxN2ggHeB
         2sZ/y0GcRaeQBh/65n6TLkg99HU0KYItRTGogFenmCWsQwfZk+XAY8LJEnYMBzC82Q
         HYAXuvwYK9GjQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: cw1200: cleanup the code a bit
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220517014136.410450-1-bernard@vivo.com>
References: <20220517014136.410450-1-bernard@vivo.com>
To:     Bernard Zhao <bernard@vivo.com>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhaojunkui2008@126.com,
        Bernard Zhao <bernard@vivo.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165389938026.27266.17563804631194227085.kvalo@kernel.org>
Date:   Mon, 30 May 2022 08:30:09 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bernard Zhao <bernard@vivo.com> wrote:

> Delete if NULL check before dev_kfree_skb call.
> This change is to cleanup the code a bit.
> 
> Signed-off-by: Bernard Zhao <bernard@vivo.com>

Patch applied to wireless-next.git, thanks.

d092de2c28dc wifi: cw1200: cleanup the code a bit

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220517014136.410450-1-bernard@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

