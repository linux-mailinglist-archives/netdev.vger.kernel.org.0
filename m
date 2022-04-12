Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533844FE242
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351137AbiDLNXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355890AbiDLNWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:22:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9495A1D5;
        Tue, 12 Apr 2022 06:12:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 563F2B81D73;
        Tue, 12 Apr 2022 13:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDA3C385A5;
        Tue, 12 Apr 2022 13:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649769126;
        bh=Vjf2NUJ0r3TuE5xc4+Hp8QmfcB3mSW+H79wux/B71iI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ITUjjTq5ZfdZKbUpeejHuGw9Q+wTG/2urSi1i8MawI+vTllnOHCh3HrGaKVfl0Hvc
         DSP3gGFqarQ4CnBPEeC7wFW+HOT115HmcCOg+j0QQ7cOvuqjfZWI7lYLIHcSmhqqik
         L5fjW6ajdlCG4vmfHk0r52kykUoPsziqxxeoMZTSodh8Mr/9rzwY4kwSlCrkjlKopf
         Qyz4l23zeu/ddJbhmw8b+31Y3xB9L4I+SWo82x2zDsCxbxKqzzLlYauWWReU3Y6kkE
         iELxxCbnLevO4YA0Ji2UUgOApjrynFy+jG9W156fdZjiF/mGXGAp87rmVIFdcSFFue
         RIxnyHD9ZkOZA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 1/2] ath9k: fix ath_get_rate_txpower() to respect the
 rate
 list end tag
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220402153014.31332-1-ps.report@gmx.net>
References: <20220402153014.31332-1-ps.report@gmx.net>
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     linux-wireless@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164976912116.15500.15111811576897907064.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 13:12:03 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Seiderer <ps.report@gmx.net> wrote:

> Stop reading (and copying) from ieee80211_tx_rate to ath_tx_info.rates
> after list end tag (count == 0, idx < 0), prevents copying of garbage
> to card registers.
> 
> Note: no need to write to the remaining ath_tx_info.rates entries
> as the complete ath_tx_info struct is already initialized to zero from
> both call sites.
> 
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

24584d4f0afc ath9k: fix ath_get_rate_txpower() to respect the rate list end tag

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220402153014.31332-1-ps.report@gmx.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

