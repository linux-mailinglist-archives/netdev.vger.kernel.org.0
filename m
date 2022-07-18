Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8757A5781A2
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbiGRMIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbiGRMIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:08:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D56240B6;
        Mon, 18 Jul 2022 05:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1BF2B81249;
        Mon, 18 Jul 2022 12:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CACDC341C0;
        Mon, 18 Jul 2022 12:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146086;
        bh=Vpn7gJURGNZch2cUCQuCXRnKo089jwF4fQ60LQTWMmM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jGawyoqkbI9p4e7ZL+pPv0O+awV80yxlJJ4AenHmMQ/M/4/zvgWY17MEKjWM7aLsl
         YnYtMO2Gclf8H52mVjM02B7353RPQbCeBNeHUcugZHn18KszYMzSg9XSpF5n7GRwqF
         uA52L/NwLeOpvXTdz2uMWAVTWvaFXWFlXrXd6IcYaotWp37EpqV4WLMtv6azD08Myd
         0954kIkdMwJ54PULdRckWmOoViJAi2DQZ19OOGjCaTsSPP16RRx+MU/OPu8aiqQyCK
         Y5Rx/Y6hJMkJkFNpat5l145X+DBXZxXqB4ACpKISOzqFMEqpzkXs1JwWgw4Zt2eboR
         UhjKFDaZxKlZg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: brcmsmac: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709134207.30856-1-yuanjilin@cdjrlc.com>
References: <20220709134207.30856-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814608171.32602.12526986230947277855.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:08:03 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'the'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

505d6105b6fd wifi: brcmsmac: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709134207.30856-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

