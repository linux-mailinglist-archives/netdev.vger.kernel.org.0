Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6556C5331
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjCVSCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjCVSCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:02:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2993864208;
        Wed, 22 Mar 2023 11:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC8F462252;
        Wed, 22 Mar 2023 18:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0253DC433D2;
        Wed, 22 Mar 2023 18:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679508122;
        bh=SsBUNvNZyeRaoCWN4RaJgPixIarcjbF9yPajy6mQbKI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=J9cNF04VmhB8+3MyQHojA+QuoRh06JP9Kr1CskII7CqIkB7neoOpAtz4obF2pT7YD
         /dcxpCqoUqcWTK1nEXQ+Kgx18cuvM2q9cJhUV2DLZovsKN9dsF2i15VHfF9pP7kU7b
         ODN3FdIpcvjFZoQY2OdA5EihfC3pJqQG0RUfiS/hfW0MOVWArFWLA8pgalu1ueyYCr
         nJwlufUYx2JGzg4PAFEHyMr6x0ujGeoOIrvcOlCdIz1MFgR/zscJx25pt6o5hy6f05
         XLO0DN24p5dDJTc7CkHMmmv1V1epJY9z5oxijkP4AcgebFOAJkPkR73QXVjJ4fplag
         adB9DegPrjY3A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: mt76: mt7921: add Netgear AXE3000 (A8000) support
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230123090555.21415-1-git@qrsnap.io>
References: <20230123090555.21415-1-git@qrsnap.io>
To:     Reese Russell <git@qrsnap.io>
Cc:     git@qrsnap.io, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Deren Wu <deren.wu@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167950811348.23855.15517111358348733076.kvalo@kernel.org>
Date:   Wed, 22 Mar 2023 18:01:57 +0000 (UTC)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reese Russell <git@qrsnap.io> wrote:

> Add support for the Netgear AXE3000 (A8000) based on the Mediatek
> mt7921au chipset. A retail sample of the Netgear AXE3000 (A8000) yeilds
> the following from lsusb D 0846:9060 NetGear, Inc. Wireless_Device. This
> has been reported by other users on Github.
> 
> Signed-off-by: Reese Russell <git@qrsnap.io>

There was a conflict, please rebase over wireless and resubmit as v2:

Recorded preimage for 'drivers/net/wireless/mediatek/mt76/mt7921/usb.c'
error: Failed to merge in the changes.
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Applying: wifi: mt76: mt7921: add Netgear AXE3000 (A8000) support
Using index info to reconstruct a base tree...
M	drivers/net/wireless/mediatek/mt76/mt7921/usb.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/mediatek/mt76/mt7921/usb.c
CONFLICT (content): Merge conflict in drivers/net/wireless/mediatek/mt76/mt7921/usb.c
Patch failed at 0001 wifi: mt76: mt7921: add Netgear AXE3000 (A8000) support

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230123090555.21415-1-git@qrsnap.io/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

