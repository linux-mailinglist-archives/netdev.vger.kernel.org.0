Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0BF578149
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbiGRLwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiGRLwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:52:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A8922BCC;
        Mon, 18 Jul 2022 04:52:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62FA661384;
        Mon, 18 Jul 2022 11:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB0AC341C0;
        Mon, 18 Jul 2022 11:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658145123;
        bh=2zN3CeIQ12Ao82yCSuGKsDlV+KttZ2k+uZ3zphsG0R8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IrshlyfLz1RaziiSQDxtq3M6B4nRCbcs9KV4NdeRxK25Hzy1WKkXxmOzHl8Ffz9CS
         LndnwRnqwwABtzyhbWe2tcCHNf5hO/VShVgKD5Ms55S9oQcDKdTS07+d8wqIEpIWgN
         gs0lHv0phaHk9GZv1uNj+S9kiaKO+zeVMoTJWGCO136ncUB0pKdrmS9eUkyOY1FvYZ
         A4qRTbS6tsNTXQL2JlUhmMS9V6R8C03Q5ciossxw2PgNoB+6Ljizx/xO2n337qQZ0n
         c9ghoEGJUF2I8oKcxFDQVX+NysnpUEbg2ehOVJRskiv8vjDyTZVf8X4j2soDPFamXe
         q0Dv5h7X7zokQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: p54: Use the bitmap API to allocate bitmaps
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <2755b8b7d85a2db0663d39ea6df823f94f3401b3.1656939750.git.christophe.jaillet@wanadoo.fr>
References: <2755b8b7d85a2db0663d39ea6df823f94f3401b3.1656939750.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814511953.17539.6544213210547391400.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 11:52:01 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>

Patch applied to wireless-next.git, thanks.

0c574060060a wifi: p54: Use the bitmap API to allocate bitmaps

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/2755b8b7d85a2db0663d39ea6df823f94f3401b3.1656939750.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

