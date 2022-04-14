Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A70D500CAE
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbiDNMDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243145AbiDNMCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:02:54 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C376BF4;
        Thu, 14 Apr 2022 05:00:21 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id 503611F479AA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1649937620;
        bh=SIfLgdnnm8Mr1pbjdeSXLKHkft4Qo/podTgV9ZDU6oA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Zg5ZpRBctAbEWetGACqu7m5ZTuMBIP5UM9CW0mHjzxWc9yf6zxgri36QFRVRjFe8r
         q1k0qUq5I9KDxSWMh70FuxJ/Z7zG2Hfa7/zale0fdLVS7CAyUbwObk8mNvDyot53uP
         +IQOXs3VLcYC+43iXuXMkYMgW+NzpNj9pjZUgui/WWFR6F5aVi8cgDenBSd/G4lKAf
         8Tr1vm9ZVoqDRVNWvBXgv1KWwwVnHUPH+hXPS+mMC8X0/57TecA6wAfRmGCa+0jOrG
         CaTqlo5j2ZcT8SOi18q3e72PURRomPvUN+U+Jl3d+TpmmrHRmYk9M75ytNGAzxHgL/
         KJzCU9Xf5zMUA==
Message-ID: <98a1d6fa-c5d0-f1f2-ad85-f5246b368fb3@collabora.com>
Date:   Thu, 14 Apr 2022 14:00:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] mt76: mt7921: make read-only array ppet16_ppet8_ru3_ru0
 static const
Content-Language: en-US
To:     Colin Ian King <colin.i.king@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220414095438.294980-1-colin.i.king@gmail.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220414095438.294980-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 14/04/22 11:54, Colin Ian King ha scritto:
> Don't populate the read-only array ppet16_ppet8_ru3_ru0 on the stack but
> instead make it static const. Also makes the object code a little smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Tested OK (mt7921 on PCIe), and....

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

