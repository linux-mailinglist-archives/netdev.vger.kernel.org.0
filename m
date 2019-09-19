Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774D7B78C5
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390071AbfISL6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:58:45 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:43654 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388639AbfISL6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 07:58:44 -0400
Received: from [91.156.6.193] (helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iAv53-0000co-2M; Thu, 19 Sep 2019 14:58:38 +0300
Message-ID: <a008903b8fe4f687c75c7d864582888b74fb1709.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 19 Sep 2019 14:58:35 +0300
In-Reply-To: <20190919115612.1924937-1-arnd@arndb.de>
References: <20190919115612.1924937-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH] iwlwifi: fix building without CONFIG_THERMAL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-19 at 13:55 +0200, Arnd Bergmann wrote:
> The iwl_mvm_send_temp_report_ths_cmd() function is now called without
> CONFIG_THERMAL, but not defined:
> 
> ERROR: "iwl_mvm_send_temp_report_ths_cmd" [drivers/net/wireless/intel/iwlwifi/mvm/iwlmvm.ko] undefined!
> 
> Move that function out of the #ifdef as well and change it so
> that empty data gets sent even if no thermal device was
> registered.
> 
> Fixes: 242d9c8b9a93 ("iwlwifi: mvm: use FW thermal monitoring regardless of CONFIG_THERMAL")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> No idea if this does what was intended in the commit that introduced
> the link failure, please see for youself.

Thanks for the fix, Arnd! We already sent a fix for this though[1] and
Kalle has already queued it for v5.3.

[1] https://patchwork.kernel.org/patch/11150431/

--
Cheers,
Luca.

