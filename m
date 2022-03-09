Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A004D3176
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 16:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiCIPJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 10:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiCIPJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 10:09:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5E05522C;
        Wed,  9 Mar 2022 07:08:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65117B82200;
        Wed,  9 Mar 2022 15:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6F2C340E8;
        Wed,  9 Mar 2022 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646838510;
        bh=NY/yMXJdJMhG+YVGyL7wkfSuv/bZvZ1vnUmRWsJjlsE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WSrVE1AV3R7PCc1H3RC0W32yYPfpK+fgskWBLzx8XfxWLic7JmehEpBune+3XW720
         mgxcDbfiEpC6hy8CIElTI7j0qtmzoEdxhKH2RUkN1xx05oG0nGD0welWBI7AG8In59
         qAVvW7PQ72KGlNFmy5WHUmXhW5AZQC0VDAY8oADhQ7x3Z65Y4zeg7FXYViZ9VmZMIL
         iyu4mRJThA6CXi4fxCjlVAR1jTftNcduOi7V1hNh+XkAzlmFL80TwmARGCHkE6Sh9x
         aUCfwTC5BFSt0LLs4fQpQaWGHyyypp4RWiuI8WjiMbloJ8B+kywGOkQ5PqxODkcIxG
         NQfiX+BRjXJSQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_begin_scan_cmd
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1ef801ea24475501fa0f296cb5435a440135206e.1645736204.git.gustavoars@kernel.org>
References: <1ef801ea24475501fa0f296cb5435a440135206e.1645736204.git.gustavoars@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164683850431.5166.5608147363884870335.kvalo@kernel.org>
Date:   Wed,  9 Mar 2022 15:08:27 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Replace one-element array with flexible-array member in struct
> wmi_begin_scan_cmd. Also, make use of the struct_size() helper.
> 
> This issue was found with the help of Coccinelle and audited and fixed,
> manually.
> 
> Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> Link: https://github.com/KSPP/linux/issues/79
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

6 patches applied to ath-next branch of ath.git, thanks.

324edddf2505 ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_begin_scan_cmd
56f1257fdcc0 ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_start_scan_cmd
3c5e6994eea3 ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_channel_list_reply
dfb0203939b1 ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_connect_event
5140df50e655 ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_disconnect_event
0dff6f05a9dc ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_aplist_event

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1ef801ea24475501fa0f296cb5435a440135206e.1645736204.git.gustavoars@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

