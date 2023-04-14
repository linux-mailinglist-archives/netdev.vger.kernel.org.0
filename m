Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C4D6E234A
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 14:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjDNMbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 08:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDNMbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 08:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91272C5;
        Fri, 14 Apr 2023 05:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DD8A64787;
        Fri, 14 Apr 2023 12:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB015C433EF;
        Fri, 14 Apr 2023 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681475504;
        bh=zvAquklpNIE4RUk5fudyx8UoXFFfj9mLRLBQl7t/jWA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EuelEvIomATR14Vz8mv3psX7Si/UJnqFOHLqQB5hCXfYRj8y3d3JVj9kUdM8KDa5G
         knzDo9D5MufmEriT+sPXgKUG9yUqNf3qiwnv/PwdiI9vPZB83iPfetZb8/TB4htso3
         xIOEwDhRJ3EHjmACLzexNjpSNspE4OzaxqjuQtmz674YHCF1MLDhCHBqoIz1nVdZeG
         Wv/+IoLNBUvs/UWEqZTT1D6eKibHNU6AWMxIfPP0VoFVByWgEnRAlI9fmt1+X0AgG+
         RU+eHdlO2SgQLjLqh7eMDaA8hncMWXzddkt8jNayDhFJdR7xspvL3XYBEVU09EW+qT
         mZxOkoxsDu58w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: brcmfmac: add Cypress 43439 SDIO ids
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230407203752.128539-1-marex@denx.de>
References: <20230407203752.128539-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arend van Spriel <aspriel@gmail.com>,
        Danny van Heumen <danny@dannyvanheumen.nl>,
        Eric Dumazet <edumazet@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Cercueil <paul@crapouillou.net>,
        SHA-cyfmac-dev-list@infineon.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        brcm80211-dev-list.pdl@broadcom.com, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168147549923.16522.10324026964322763958.kvalo@kernel.org>
Date:   Fri, 14 Apr 2023 12:31:40 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> wrote:

> Add SDIO ids for use with the muRata 1YN (Cypress CYW43439).
> The odd thing about this is that the previous 1YN populated
> on M.2 card for evaluation purposes had BRCM SDIO vendor ID,
> while the chip populated on real hardware has a Cypress one.
> The device ID also differs between the two devices. But they
> are both 43439 otherwise, so add the IDs for both.
> 
> On-device 1YN (43439), the new one, chip label reads "1YN":
> ```
> /sys/.../mmc_host/mmc2/mmc2:0001 # cat vendor device
> 0x04b4
> 0xbd3d
> ```
> 
> EA M.2 evaluation board 1YN (43439), the old one, chip label reads "1YN ES1.4":
> ```
> /sys/.../mmc_host/mmc0/mmc0:0001/# cat vendor device
> 0x02d0
> 0xa9a6
> ```
> 
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Marek Vasut <marex@denx.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

cc4cffc3c142 wifi: brcmfmac: add Cypress 43439 SDIO ids

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230407203752.128539-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

