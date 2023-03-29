Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DF76CD23F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjC2GoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2GoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:44:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E219A1BC0;
        Tue, 28 Mar 2023 23:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86010B82012;
        Wed, 29 Mar 2023 06:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2128FC433EF;
        Wed, 29 Mar 2023 06:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680072239;
        bh=nh9FiwEaOwTEBrwBZ6zuJlCaeUs/sVh8B7364nNJ4vw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SDvohtFr983sjS5qsaneARzdF22qBbj0NiFIBh7uVWjHUd4L5CK7uRXWy8hMBmfjo
         1sJ98lrgJKJV0kj4b6l5kTzypuRMa6hM3dya/yegS+A2v8BFruiQuKzA3rl/HL0xWo
         z0Q/0qZ7MqIeY5zktC6CNFBpHSo+uB13cmbNRJGd1bFtsy6plXcqFMETxaU51lazwG
         9dEl14BmNUJQkR1R9YqUyjq7UWKsqtriNDE7F/KW0uanhlLgN+zA+ghMvzbBkefZtw
         yeJ4tMyTwQUQ9u9li921WGFThoaCq8A7gAB/TCvnG2ucqwqbHN7cJRvQn3iDE6vUGo
         rRAFPmkXdthUQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1phPXa-0004PO-0A; Wed, 29 Mar 2023 08:44:14 +0200
Date:   Wed, 29 Mar 2023 08:44:13 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
Subject: Re: [PATCH v8 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
Message-ID: <ZCPePe1i64OGS0TP@hovoldconsulting.com>
References: <20230326233812.28058-1-steev@kali.org>
 <20230326233812.28058-5-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326233812.28058-5-steev@kali.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 06:38:12PM -0500, Steev Klimaszewski wrote:
> The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
> add this.
> 
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> ---
> Changes since v7:
>  * Drop regulator now in a different patchset from Johan
>  * Fix alphabetization
> 
> Changes since v6:
>  * Remove allowed-modes as they aren't needed
>  * Remove regulator-allow-set-load
>  * Set regulator-always-on because the wifi chip also uses the regulator
>  * cts pin uses bias-bus-hold
>  * Alphabetize uart2 pins
> 
> Changes since v5:
>  * Update patch subject
>  * Specify initial mode (via guess) for vreg_s1c
>  * Drop uart17 definition
>  * Rename bt_en to bt_default because configuring more than one pin
>  * Correct (maybe) bias configurations
>  * Correct cts gpio
>  * Split rts-tx into two nodes
>  * Drop incorrect link in the commit message
> 
> Changes since v4:
>  * Address Konrad's review comments.
> 
> Changes since v3:
>  * Add vreg_s1c
>  * Add regulators and not dead code
>  * Fix commit message changelog
> 
> Changes since v2:
>  * Remove dead code and add TODO comment
>  * Make dtbs_check happy with the pin definitions

Looks like we're good to go now. Thanks for sticking with it.

Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>

Johan
