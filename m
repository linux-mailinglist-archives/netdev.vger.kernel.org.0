Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8138673E66
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjASQRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjASQRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:17:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E01382D44;
        Thu, 19 Jan 2023 08:17:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3000161CBC;
        Thu, 19 Jan 2023 16:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C94C433D2;
        Thu, 19 Jan 2023 16:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674145041;
        bh=I4UV/ZFa5sN0ljDlr5qmIib/5HOXj3xcEjz22nxpESs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XmRWLBZ9Sj2J4wnmS0yEkR6ZwBpbie8Dl7OfyRAyWr19jxqPveXzvG/qGacYmhp9B
         WAAqTSQWDP47CvRtTR5BaOl5voYJGf15mCGETDFTzANIhNahQd1Q/R78a1/mEDm/2M
         n/gUsYXBB+7XK6/EZ0xd+TJ1rvFC1nw1Cb21BJawArxTQCx6G0jB67XL4NO0xfnt9G
         NkzEA8AFQglFea4Pvd3b4V1wHS8Om6pjcBix6SWifXdy2hqIXG60LkK4boXb9H5M5I
         QceoS8og/cRl3dePeUzBvnmAvye0RQp4dTBvl45geyCwVFMFrs+GgI0uPGXZT8USHN
         qWX/oE53Z2IvQ==
Date:   Thu, 19 Jan 2023 16:17:13 +0000
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
Subject: Re: [PATCH v4 02/11] leds: Move led_init_default_state_get() to the
 global header
Message-ID: <Y8ltCUMwZdpnNRTD@google.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
 <20230103131256.33894-3-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230103131256.33894-3-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Jan 2023, Andy Shevchenko wrote:

> There are users inside and outside LED framework that have implemented
> a local copy of led_init_default_state_get(). In order to deduplicate
> that, as the first step move the declaration from LED header to the
> global one.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/leds/leds.h  | 1 -
>  include/linux/leds.h | 2 ++
>  2 files changed, 2 insertions(+), 1 deletion(-)

Applied, thanks

-- 
Lee Jones [李琼斯]
