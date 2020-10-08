Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E7B2872AE
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgJHKor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:44:47 -0400
Received: from z5.mailgun.us ([104.130.96.5]:44800 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgJHKon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 06:44:43 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602153881; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=a/t2L4jF7mvgT6kUkGV7vP95J4L8otVQ9EHjcjSlyWk=;
 b=oO6MZ3mCyffV4WUpIfhPPqVee/hoIAjlXj+2Xed4Zetqr/PjXtcWZRT2ZPLrfstAe2Vts3og
 rmAAH6N3VE4k7sf+uqyeNX9Pj2BsKUa8giRpuU5xzN/qTskQ64NibdEp6IdW2j5JSzM3ZcVu
 R4lRr5RydWZAWOrx4ipAD7BPOpQ=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f7eed9783370fa1c1d650fd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 08 Oct 2020 10:44:39
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 16D99C433CA; Thu,  8 Oct 2020 10:44:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 73C90C433CA;
        Thu,  8 Oct 2020 10:44:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 73C90C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/29] iwlwifi: dvm: Demote non-compliant kernel-doc
 headers
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200910065431.657636-2-lee.jones@linaro.org>
References: <20200910065431.657636-2-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201008104439.16D99C433CA@smtp.codeaurora.org>
Date:   Thu,  8 Oct 2020 10:44:38 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> None of these headers attempt to document any function parameters.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:388: warning: Function parameter or member 't' not described in 'iwl_bg_statistics_periodic'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:545: warning: Function parameter or member 't' not described in 'iwl_bg_ucode_trace'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:771: warning: Function parameter or member 'priv' not described in 'iwl_alive_start'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'priv' not described in 'iwl_print_event_log'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'start_idx' not described in 'iwl_print_event_log'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'num_events' not described in 'iwl_print_event_log'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'mode' not described in 'iwl_print_event_log'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'pos' not described in 'iwl_print_event_log'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'buf' not described in 'iwl_print_event_log'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'bufsz' not described in 'iwl_print_event_log'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'priv' not described in 'iwl_print_last_event_logs'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'capacity' not described in 'iwl_print_last_event_logs'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'num_wraps' not described in 'iwl_print_last_event_logs'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'next_entry' not described in 'iwl_print_last_event_logs'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'size' not described in 'iwl_print_last_event_logs'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'mode' not described in 'iwl_print_last_event_logs'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'pos' not described in 'iwl_print_last_event_logs'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'buf' not described in 'iwl_print_last_event_logs'
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'bufsz' not described in 'iwl_print_last_event_logs'
> 
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Intel Linux Wireless <linuxwifi@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

14 patches applied to wireless-drivers-next.git, thanks.

7cb391ffdf3c iwlwifi: dvm: Demote non-compliant kernel-doc headers
b392eabc6abe iwlwifi: rs: Demote non-compliant kernel-doc headers
229b5582deb5 iwlwifi: dvm: tx: Demote non-compliant kernel-doc headers
c8a11a84671e iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
7619ccceae49 iwlwifi: calib: Demote seemingly unintentional kerneldoc header
8f7ed7bf1384 iwlwifi: dvm: sta: Demote a bunch of nonconformant kernel-doc headers
707c528a8d51 iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
108285ec6851 iwlwifi: dvm: Demote a couple of nonconformant kernel-doc headers
7b37b874fce3 iwlwifi: mvm: utils: Fix some doc-rot
de00105cf0dc iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
3a7d806926bb iwlwifi: dvm: rxon: Demote non-conformant kernel-doc headers
91b4780fbae7 iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
6806fc7fcfb2 iwlwifi: dvm: devices: Fix function documentation formatting issues
7d4ced86997f iwlwifi: iwl-drv: Provide descriptions debugfs dentries

-- 
https://patchwork.kernel.org/patch/11766851/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

