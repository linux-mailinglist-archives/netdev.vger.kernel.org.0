Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6149B673E60
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjASQQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjASQQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:16:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F1C8A0D5;
        Thu, 19 Jan 2023 08:16:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A715C61CB4;
        Thu, 19 Jan 2023 16:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686F4C433EF;
        Thu, 19 Jan 2023 16:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674144986;
        bh=KCGVBnDEkLnMEQSY6tEtqfJoXRhHiOT2it8+U/KUeXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lQN1IErrIxsvnYoPHEmxSkukWKLHZ3L47Hbth5LpwxT0XDzjNG/7ifs0mrs9eWHao
         Z/Sbz9+QD7hKDtYKIhXCEUOd4Uly0xBTnQvq14xkIKs3Hw2PgvzdHWdG1OMeCTMpyq
         3FLqL1RmP6wlc67BWzR+fwsUrTrB1dYXclFd1FGW7rF04/t8mVLOg8MxACngsI8Xgd
         6/f2E+xnp8t0x8UVyiDF1+Al5E8QtDNSKpdCN3Ye4ted742TaAiWxpY2Fx+wF1W9Eo
         4KSIOm7CdctBS90En1W3uDmC3lbu+My4tGCJnG5fVOmU0o+jyPPrJbv3Hn47aWGDjp
         1pBKB7xImPWUA==
Date:   Thu, 19 Jan 2023 16:16:17 +0000
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
Subject: Re: [PATCH v4 01/11] leds: add missing includes and forward
 declarations in leds.h
Message-ID: <Y8ls0ZQiY/dcTdAE@google.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
 <20230103131256.33894-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230103131256.33894-2-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Jan 2023, Andy Shevchenko wrote:

> Add missing includes and forward declarations to leds.h. While at it,
> replace headers by forward declarations and vise versa.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/linux/leds.h | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

Applied, thanks

-- 
Lee Jones [李琼斯]
