Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB4A4DC885
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiCQOQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbiCQOQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B2DA6E1D;
        Thu, 17 Mar 2022 07:15:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31DB3617BE;
        Thu, 17 Mar 2022 14:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E5EC340E9;
        Thu, 17 Mar 2022 14:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647526511;
        bh=Gw06cUiqZUFqaQ47kCBtK/oLuXtFQCo2+/8QuxFZfl8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ttAwNCiZfGksZpSzkyklqcmY6KoXhdZmcnUpZXPNhpZS+flX7riy2hVdfRRcbIp5G
         8IjZQRHDP2l4PJYlo7NOljcIC3pFMApz+fWqWCFhdr66uOApjpzg7uV7OD7FzZYfZa
         6nvl++P+fZ4nWxrlF2vC79amqP4do/zeI0EV4ugJwM2OqXad5UQSnNymM1JuOkQRWz
         CutvRCb7Rs0w1FXBh6+aLKtE3u90bZMCqBEzsTgSEOjj2OlvtGLm/EWV0OLemqGdQn
         0eVVS5iRa1I1MbhBlM7SafO/tTbeR4vVhbq4QM4ixsO4m/+bi5SWh7d0HXnN2K+FZ9
         TpsJBZsQJeEYg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: mei: fix building iwlmei
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220316183617.1470631-1-arnd@kernel.org>
References: <20220316183617.1470631-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ayala Beker <ayala.beker@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164752649601.16149.4589465777164464023.kvalo@kernel.org>
Date:   Thu, 17 Mar 2022 14:15:09 +0000 (UTC)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> Building iwlmei without CONFIG_CFG80211 causes a link-time warning:
> 
> ld.lld: error: undefined symbol: ieee80211_hdrlen
> >>> referenced by net.c
> >>>               net/wireless/intel/iwlwifi/mei/net.o:(iwl_mei_tx_copy_to_csme) in archive drivers/built-in.a
> 
> Add an explicit dependency to avoid this. In theory it should not
> be needed here, but it also seems pointless to allow IWLMEI
> for configurations without CFG80211.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Emmanuel Grumbach <Emmanuel.grumbach@intel.com>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-next.git, thanks.

066291bec0c5 iwlwifi: mei: fix building iwlmei

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220316183617.1470631-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

