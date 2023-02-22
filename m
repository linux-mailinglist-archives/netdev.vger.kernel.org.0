Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DDC69F496
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 13:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjBVMb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 07:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBVMb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 07:31:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EE238EBC;
        Wed, 22 Feb 2023 04:31:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D56F96137F;
        Wed, 22 Feb 2023 12:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FDBC433EF;
        Wed, 22 Feb 2023 12:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677069114;
        bh=HCmOsOxt26Wa+AFF0vKBEXqL+cNQCZii1Rg0SeNSogk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Df6thve2yEw+mR1gV7NZV5QW+nZ1CBPuGcR3+LaHbQNBRVjq6bt2e3D7zmBIOY1I/
         0oY3tsllAtjYGw2RByZ7g6D2s8l+S0iSP9eU/QYoDdTD+LofdRJWXpw2//n7m6pV19
         nixyjgd8JMN7M9OY6kdTkSJyOAFgxeuiimZo6NPjLUnFXeXvdNwgQqnf60PdRTjrSu
         Bq7Y0D/HpnSZT2FnUr7Bqn1/Yud3Rm5Dm487NKAeAWI05pEuY8stbRymowTp123i2J
         wQthyyvK3FHRgZ3tvjiNqrHjZ45NQFRcFMDybyXIoCOTG1Wk+jWB2nKNbxO3jmEkSq
         +u4CEjdxOTiaw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/5] wifi: rtw88: mac: Add support for the SDIO HCI in
 rtw_pwr_seq_parser()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230218152944.48842-2-martin.blumenstingl@googlemail.com>
References: <20230218152944.48842-2-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167706911064.20055.5000257740633760442.kvalo@kernel.org>
Date:   Wed, 22 Feb 2023 12:31:52 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:

> rtw_pwr_seq_parser() needs to know about the HCI bus interface mask for
> the SDIO bus so it can parse the chip state change sequences.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

5 patches applied to wireless-next.git, thanks.

96c79da2e4d1 wifi: rtw88: mac: Add support for the SDIO HCI in rtw_pwr_seq_parser()
8599ea40582d wifi: rtw88: mac: Add SDIO HCI support in the TX/page table setup
64e9d5646535 wifi: rtw88: rtw8821c: Implement RTL8821CS (SDIO) efuse parsing
9e688784b8a1 wifi: rtw88: rtw8822b: Implement RTL8822BS (SDIO) efuse parsing
ad0a677bce20 wifi: rtw88: rtw8822c: Implement RTL8822CS (SDIO) efuse parsing

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230218152944.48842-2-martin.blumenstingl@googlemail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

