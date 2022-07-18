Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38225781CE
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiGRMM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbiGRMMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:12:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6769F24955;
        Mon, 18 Jul 2022 05:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3AA261477;
        Mon, 18 Jul 2022 12:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63089C341D5;
        Mon, 18 Jul 2022 12:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146336;
        bh=KU5XG89/tyFz/Oo7SvzDbI2yUM/Xgd+xaHy715tmcZ0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DWUG4Y6uQvGk746GZMk+lGC9BgD6G/iN0LkDOLjoAagJWBlq/hFgsgLacl2AGtHLH
         hw3DTcFeXwjUWFGV8wCixktHj2+JUSVBuGwi9acsR+FzXky0H+X9MJraLxNjesq06E
         z54WAXrmGIzint8OtZUOrN6aYuf8NxnimA2ilZYDAZb/GIiSwvD+rKu/rpl73lm9Mz
         loeVNDWuVP17bUCu4+WtkX1LTqvEirPE7XEyOPFbxRY8ogIkBC2RNAMJWKtn4/wPtX
         7Ix4MJH7G7yTwkj1TS0/pAiAhjeJdPii+Pl8iEhLzxOpd7kgll35IxZRcMXJ9dMjHE
         UMH3QogDWvRHA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: wl1251: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220710043405.38304-1-yuanjilin@cdjrlc.com>
References: <20220710043405.38304-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814633252.32602.10124173678960288207.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:12:14 +0000 (UTC)
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

f1cee996f185 wifi: wl1251: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220710043405.38304-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

