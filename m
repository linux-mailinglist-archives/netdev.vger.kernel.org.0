Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848FF583B9C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 11:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbiG1J67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 05:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiG1J65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 05:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13A96390D;
        Thu, 28 Jul 2022 02:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EBED614A0;
        Thu, 28 Jul 2022 09:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DD5C433D7;
        Thu, 28 Jul 2022 09:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659002335;
        bh=fo7cx7+jR998x+sKT6+q+pmbkV1soLLQX3aSXJvv9OY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=trQaffMXdMhMxovHwhDRg+/L2fNETbnE3A3TNC7nkAT+awdDCkDzWS+OtmE+3DLJC
         WxVIz6duubf65lN96GN+8pLldwbUvTrR7xlWEXKgb7Wp4JAoMZ9pqn1YJ6rsMsS0k9
         aJNVCeZFHzjBpYTKyGd5L+3bWt1R1oq5xFSLA9da3QsI0ozDCRub+YGnysYMrV5xyA
         mfhgZ9RMrsYByv2CQOkV8oV8Wa3w/yIZRj2H/c8emdn00iQif7OWvbySMh3qLaVa2H
         SuZtWFz+bTEeVBeJ7DLws1dWxYtmhf/gOcTs+BJBnKlBNLE+aR0u3JZ37eR5xg5i5R
         ltfgw+wo0Bgfg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] dt-bindings: bcm4329-fmac: add optional
 brcm,ccode-map-trivial
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220711123005.3055300-2-alvin@pqrs.dk>
References: <20220711123005.3055300-2-alvin@pqrs.dk>
To:     =?utf-8?q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        van Spriel <arend@broadcom.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?utf-8?q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165900233004.25113.10282302027538037167.kvalo@kernel.org>
Date:   Thu, 28 Jul 2022 09:58:51 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alvin Šipraga <alvin@pqrs.dk> wrote:

> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> The bindings already offer a brcm,ccode-map property to describe the
> mapping between the kernel's ISO3166 alpha 2 country code string and the
> firmware's country code string and revision number. This is a
> board-specific property and determined by the CLM blob firmware provided
> by the hardware vendor.
> 
> However, in some cases the firmware will also use ISO3166 country codes
> internally, and the revision will always be zero. This implies a trivial
> mapping: cc -> { cc, 0 }.
> 
> For such cases, add an optional property brcm,ccode-map-trivial which
> obviates the need to describe every trivial country code mapping in the
> device tree with the existing brcm,ccode-map property. The new property
> is subordinate to the more explicit brcm,ccode-map property.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Acked-by: Rob Herring <robh@kernel.org>

2 patches applied to wireless-next.git, thanks.

8406993a891f dt-bindings: bcm4329-fmac: add optional brcm,ccode-map-trivial
5c54ab24377b wifi: brcmfmac: support brcm,ccode-map-trivial DT property

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220711123005.3055300-2-alvin@pqrs.dk/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

