Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331EE607077
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 08:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiJUGu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 02:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiJUGtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 02:49:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F2A244C5A;
        Thu, 20 Oct 2022 23:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9096861D9B;
        Fri, 21 Oct 2022 06:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207A8C433B5;
        Fri, 21 Oct 2022 06:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666334914;
        bh=Pa59gRcCjIAYrcKVcjxJd3h3lUsuJ0LhHiTmoynHNI0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=j+SseHhPdz/f7nueNs3h2lsKj7fwHLqasZ4oQ50lJ6EK9RRVu38ve1M/yk4Tx6uOI
         EPPu8GLSibvwFgSqLwzum3D+1zNsSnGAmaGmDmzWS+1hDY3GEQ9wlG7xaI9qR4V5oy
         xCvup6vfI86MnAFqL76R9oTsdMKb3eIC/0zjKb65nXWn2Go73+BrN7huaptLl5fknS
         LfrNBaRHvaqxA8soiJ4nGkAHHanbPvXQeks6BRKEr3y54F0ctm7lu9wP6cYaxZVRSw
         ciE020/aAuZ5iqhyPEftpdX/Pq6/XvgC76657+eT9o2ctKIdrTzefA8LJpLMpI/t1t
         pscraL57di5zw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] wifi: rt2x00: use explicitly signed or unsigned types
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221019155541.3410813-1-Jason@zx2c4.com>
References: <20221019155541.3410813-1-Jason@zx2c4.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166633490836.19505.7036640684401652888.kvalo@kernel.org>
Date:   Fri, 21 Oct 2022 06:48:31 +0000 (UTC)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> On some platforms, `char` is unsigned, but this driver, for the most
> part, assumed it was signed. In other places, it uses `char` to mean an
> unsigned number, but only in cases when the values are small. And in
> still other places, `char` is used as a boolean. Put an end to this
> confusion by declaring explicit types, depending on the context.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Patch applied to wireless.git, thanks.

3347d22eb90b wifi: rt2x00: use explicitly signed or unsigned types

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221019155541.3410813-1-Jason@zx2c4.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

