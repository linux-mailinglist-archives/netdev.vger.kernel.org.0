Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C61673E97
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjASQXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjASQXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:23:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6784F34A;
        Thu, 19 Jan 2023 08:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C3A861C7B;
        Thu, 19 Jan 2023 16:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558AEC433EF;
        Thu, 19 Jan 2023 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674145391;
        bh=9XkQ6Kh5SPmyhSqvvmawvoCpf0X2h3RYxZuu4mVuKj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mhVxmzglOWJSu89yWeFQi6iQ5tTnKejNhTohxAlP+wgZWWjM29G7zrCkBpmPBc8hm
         t+kySzbzVLCvJ5kkGT3YxqEXkxC+a7eQq5xJKGAyO1aNBiqSYihrnHNYmWuDbk0HtA
         CPAtuqp1S7rnTFF2raM6K4HfHIXup7y9yIhwCIVGaJ/2AuCbrUjkAwpt/vslWKEV1J
         sul8kKbsaxbWkmUobWivgLht9x+KCisv9emImjSoLmelyofUcNQ3fQYR6AUKOss1nT
         YTPKEoGDHYX2TG12KCWF7kUq8CAClqAfD8WCGp5X2wm+2v6FlBrLj46P8gQMLnG+Zo
         9NfnxNn3tvmRw==
Date:   Thu, 19 Jan 2023 16:23:02 +0000
From:   Lee Jones <lee@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Gene Chen <gene_chen@richtek.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v4 08/11] leds: pca955x: Get rid of custom
 led_init_default_state_get()
Message-ID: <Y8luZjY4LJ3RM4Ds@google.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
 <20230103131256.33894-9-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230103131256.33894-9-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Jan 2023, Andy Shevchenko wrote:

> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/leds/leds-pca955x.c | 26 ++++++--------------------
>  1 file changed, 6 insertions(+), 20 deletions(-)

Applied, thanks

-- 
Lee Jones [李琼斯]
