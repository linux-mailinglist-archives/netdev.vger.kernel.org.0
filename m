Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21BC54E249F
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346455AbiCUKuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240532AbiCUKug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:50:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D779F1C920;
        Mon, 21 Mar 2022 03:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C74AB811BE;
        Mon, 21 Mar 2022 10:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A74AC340E8;
        Mon, 21 Mar 2022 10:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647859748;
        bh=1XzuE1mkXqD0j+4Q6vb5nPgTLU+T40IwB7OS0cmE41E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jxohsmgScROjOx85jDEqGMztdXQq8/DLeu3aFQfwptRnRgeFtQH1YWGM3yTWDBx9K
         zMxGlD0vYnAyF4Vwg3lTgTSwpTh1Kyd2BG6VgxwU0Pvbhfg9XYfVziESgLMPHb9mOn
         cxzq7eKGhdzz1qZr7xs349r+WX4BMRtSSmI5VT793T+bNZ7zyuFSv4NZ4wkUyoVM+T
         22bawrFISzckuS7OBrH8H/5Th0ss1sgNh63kfwyKVetlOfZ5C+jHtShIkkI6Vpv0L2
         pCzpbzOWumN5Ed37EtWk9U5S+ZEj7lKQ+hOCcjdWQvKU80W06aUjKYc1zQTVrwYtOl
         w86Nlt22iHEpg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] net: wireless: ath10k: Use of_device_get_match_data()
 helper
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220318025331.23030-1-tangmeng@uniontech.com>
References: <20220318025331.23030-1-tangmeng@uniontech.com>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164785974519.19083.15212520438409516614.kvalo@kernel.org>
Date:   Mon, 21 Mar 2022 10:49:07 +0000 (UTC)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Meng Tang <tangmeng@uniontech.com> wrote:

> Only the device data is needed, not the entire struct of_device_id.
> Use of_device_get_match_data() instead of of_match_device().
> 
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

c4e9705c5012 ath10k: Use of_device_get_match_data() helper

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220318025331.23030-1-tangmeng@uniontech.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

