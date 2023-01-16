Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D56F66BEE6
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjAPNMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjAPNMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:12:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136A021A02;
        Mon, 16 Jan 2023 05:09:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 239D2B80D20;
        Mon, 16 Jan 2023 13:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B20C433EF;
        Mon, 16 Jan 2023 13:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874519;
        bh=JyzanIewff9FFjjBb97feVFjkpLjSxsRwNK9A+uPc5g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WjQ4z7ZF8C4ajxaFizSNFat9XQctWZy0N3dTjY5fukfqdcqklZT2X4smXDEJh5R5V
         f2cbMRyFa4GJDy0omur5u/TxKvc3CIaNgT5WxPYbZcUn1lyafB70xRe2YbhlYGqIej
         3Jl/ZgxPZ24+OzkJNV8dHr9zSfUkgs4BKaWPpQ6RqoUZP6aqxzpbebIxewgpA72EKI
         zk1SILn93bCJbCCk4k0/8K8Ppr5wUlkW4CmQO+2EqXFqHj7s6Mm0D2YjiN5xFs+YTs
         jailnWrAR7ehZwrRV8TBeuZK7ydWyaM5mY7XCKXPEZ376vA+VJMIifeFkqsY/rW29o
         uwucAF4KcSDfw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re:
 =?utf-8?q?=5BPATCH_net-next=5D_brcm80211=3A_use_strscpy=28=29_to_in?=
        =?utf-8?q?stead_of_strncpy=28=29?=
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <202212231037210142246@zte.com.cn>
References: <202212231037210142246@zte.com.cn>
To:     <yang.yang29@zte.com.cn>
Cc:     <aspriel@gmail.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <sha-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167387451256.32134.6493247488948126794.kvalo@kernel.org>
Date:   Mon, 16 Jan 2023 13:08:36 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<yang.yang29@zte.com.cn> wrote:

> From: Xu Panda <xu.panda@zte.com.cn>
> 
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL-terminated strings.
> 
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>

Mismatch email in From and Signed-off-by lines:

From: <yang.yang29@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/202212231037210142246@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

