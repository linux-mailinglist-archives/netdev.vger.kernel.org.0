Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E09500CB6
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242923AbiDNMEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235513AbiDNMEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:04:16 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EEEF07;
        Thu, 14 Apr 2022 05:01:51 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id 857641F46212
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1649937710;
        bh=hntinxdWLlrL2MROk7epPzvGxJX7H67N4tzPW+gYQl0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mv0MYWvdjdLKrGD1VZV7IR6HjKrbyOTQjAt2fyhRmkjFEAihBrH53L0WqwFARMOon
         U4cdhfFqIsJmCgLnACP+wozzR0bECnxuNso1XMJEFq1L3dhfD+T6AVKG+2cz4RkyT3
         jWy+oNWdkm1qC346EitXku2BiVXzsv2qoqfT/jOsiawieP4UitS2LXarPWgL76IZhV
         ObYiKHTQMhmn4gmCfCNqNXPth2+Sd7rht3dtaTVW7hnuiXNXiIdRjAMcmmBSkTSruI
         +842o5Vu+Kuk7oJxacUQ7ujRbWSuRzij13Dvy3i65x5PTN8nrjLs2nfkxO+8YrysKg
         Rh5tV5bVN4nmg==
Message-ID: <264463b6-c8cd-f106-7e53-b5b0ded07110@collabora.com>
Date:   Thu, 14 Apr 2022 14:01:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] mt76: mt7915: make read-only array ppet16_ppet8_ru3_ru0
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
References: <20220414095007.294746-1-colin.i.king@gmail.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220414095007.294746-1-colin.i.king@gmail.com>
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

Il 14/04/22 11:50, Colin Ian King ha scritto:
> Don't populate the read-only array ppet16_ppet8_ru3_ru0 on the stack but
> instead make it static const. Also makes the object code a little smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

