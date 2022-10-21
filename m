Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0B76070A1
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 09:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJUHAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 03:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJUHAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 03:00:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D541F96222;
        Fri, 21 Oct 2022 00:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 924ACB80B3C;
        Fri, 21 Oct 2022 07:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9DCC433C1;
        Fri, 21 Oct 2022 07:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666335639;
        bh=EmSAQ2/Kn6SeX4zoucILX3L8Z9heMrfHbWNEHW6Q2l4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=e4+Sq01BCa8YRnrios+qESSSuSqKTOcGxqrwWxeMJaRt1ROo5Ty4gYnvGXmsNiea1
         ju9/hoH+UswIh1q4sAHPVG9n7felNKOc4zwBfrJkGV4UqHiIqkOjc62uEsMdQbL88O
         z+RavP3ybXkp9+jJ4OPRoZiY62Qwu/eEe+dyGzYd0VzlP9kuovrI3rep+HUACxo+Ip
         d12dFkpvzpWSw6m+4aKd8aBZTyb8040iY2ZYVYfjJpkSWAitcjD8/uRT3s90H+DbyU
         JpsaiLJrn2VFetrgjpTmBdMPsxY1iBjrrMeEOrQveGxDzVrrsYEBFqWC+WG1XGAnnP
         apwFXSCjZvYsw==
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
Message-ID: <166633563389.6242.13987912613257140089.kvalo@kernel.org>
Date:   Fri, 21 Oct 2022 07:00:37 +0000 (UTC)
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

66063033f77e wifi: rt2x00: use explicitly signed or unsigned types

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221019155541.3410813-1-Jason@zx2c4.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

