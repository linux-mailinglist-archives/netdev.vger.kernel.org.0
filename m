Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06FF511060
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 07:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357784AbiD0FHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 01:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiD0FHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 01:07:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A65575226;
        Tue, 26 Apr 2022 22:03:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B70606137D;
        Wed, 27 Apr 2022 05:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF2BC385A7;
        Wed, 27 Apr 2022 05:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651035830;
        bh=DVM44mksHY1qbD7OHzHmnYqk/lP6UoqRj4SKi+lLs7s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LpgzuC8ES6Ny59uKZpq71oF3O2MGmwT6J7yylPETJqzsyMYUcld2yiInvtIvVfUPr
         eFch6XmFj5UPaf4LaVq9K+DaWLCYcNWKj2QIJWVnecigogB5/qFk8bpy29ap63QAja
         +A8DwpALaM40UaSzAH/eiUepZAegNrqNHsBD3XjO6mYifyKQ5HzqylhnApU/VsLMAW
         rNQTMQsMWo49vJ94RCe2YA5k4WUEXNJhrv7F2ot4dODZgdhaL8E1KNHtcBOH3Bcdf8
         RCRaCdx80UM9h4quNgOa3rNVlVw3AnTLxau6SWsv0XmMElXLJbbtuC0XqyhA0LMWps
         VGxcWiCFH7iLg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as fallback
 on
 brcmfmac43602 chips
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220423111237.60892-1-hzamani.cs91@gmail.com>
References: <20220423111237.60892-1-hzamani.cs91@gmail.com>
To:     Hamid Zamani <hzamani.cs91@gmail.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Soeren Moch <smoch@web.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hamid Zamani <hzamani.cs91@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165103582533.18987.15646969582351051016.kvalo@kernel.org>
Date:   Wed, 27 Apr 2022 05:03:47 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hamid Zamani <hzamani.cs91@gmail.com> wrote:

> This uses ISO3166 country code and 0 rev on brcmfmac43602 chips.
> Without this patch 80 MHz width is not selected on 5 GHz channels.
> 
> Commit a21bf90e927f ("brcmfmac: use ISO3166 country code and 0 rev as
> fallback on some devices") provides a way to specify chips for using the
> fallback case.
> 
> Before commit 151a7c12c4fc ("Revert "brcmfmac: use ISO3166 country code
> and 0 rev as fallback"") brcmfmac43602 devices works correctly and for
> this specific case 80 MHz width is selected.
> 
> Signed-off-by: Hamid Zamani <hzamani.cs91@gmail.com>

Patch applied to wireless-next.git, thanks.

21947f3a74d6 brcmfmac: use ISO3166 country code and 0 rev as fallback on brcmfmac43602 chips

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220423111237.60892-1-hzamani.cs91@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

