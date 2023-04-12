Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54766DF822
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjDLOO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjDLOO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:14:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A7F19C
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 07:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEA4E62CB1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 14:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739BCC433D2;
        Wed, 12 Apr 2023 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681308895;
        bh=Ersfvgx/0c/WHv0eyIj/bfBRqelMiA8LSPtUFVTaXaE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JWa/Hq8h1VjoY0q/zHrzkWh9MTUDb80yPTXWSt+UqDP3ptRsMLYN+A2r52arz6Qvp
         ZIUwOeIXO57etn8Fk5zX/WThFge2JHqyKpi9z3E2Aplir13ph+Q8m6RE/wVaAAyBw/
         jABjSiCqkAhBbD4bgElzZREUVBsjz5lWyvH4HnIgtbpIVeX4lcM4Ml0zp6nGCJmUsg
         et73s+1UKzl7XppkVN5dZNJqawLtjkP4/ZW92UKqqniJ/7kB075LQbhdMcuma3o59n
         Yqzb1rqSBsb1wT6vYR2gVj6oL41wggKIzxFb7nr7mLlLo5bUuEXoJreKCoeoOSPiSQ
         2yTLKEuPY6CfQ==
Message-ID: <c81e98fc-c666-0e7c-c714-cd2fe5ef3629@kernel.org>
Date:   Wed, 12 Apr 2023 16:14:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next RFC v4 3/5] dt-bindings: net: phy: add timestamp
 preferred choice property
Content-Language: en-US
To:     =?UTF-8?Q?K=c3=b6ry_Maincent?= <kory.maincent@bootlin.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
        vladimir.oltean@nxp.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-4-kory.maincent@bootlin.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20230406173308.401924-4-kory.maincent@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2023 19:33, Köry Maincent wrote:
> From: Kory Maincent <kory.maincent@bootlin.com>
> 
> Add property to select the preferred hardware timestamp layer.
> The choice of using devicetree binding has been made as the PTP precision
> and quality depends of external things, like adjustable clock, or the lack
> of a temperature compensated crystal or specific features. Even if the
> preferred timestamp is a configuration it is hardly related to the design
> of the board.

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

Since you skipped some entries, no tests will be executed here. Resend
following Linux kernel process.


Best regards,
Krzysztof

