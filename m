Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E9356CAAF
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiGIQij convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 9 Jul 2022 12:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiGIQii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 12:38:38 -0400
Received: from relay4.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E7EE0E4
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 09:38:36 -0700 (PDT)
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay06.hostedemail.com (Postfix) with ESMTP id 32846353BB;
        Sat,  9 Jul 2022 16:38:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf14.hostedemail.com (Postfix) with ESMTPA id 7B11333;
        Sat,  9 Jul 2022 16:38:33 +0000 (UTC)
Message-ID: <3cbbd8c924c2d8105115535de6b9b35b618a6eb6.camel@perches.com>
Subject: Re: [PATCH] wifi: mvm: fix repeated words in comments
From:   Joe Perches <joe@perches.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, gregory.greenman@intel.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, quic_srirrama@quicinc.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 09 Jul 2022 09:38:32 -0700
In-Reply-To: <20220709141259.60127-1-yuanjilin@cdjrlc.com>
References: <20220709141259.60127-1-yuanjilin@cdjrlc.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Stat-Signature: c71kasigjg54jxiquqf9dabaiu1qytzz
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 7B11333
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX188vpeTFgqpyYLvMefLfVV9ZatXLOnW/XQ=
X-HE-Tag: 1657384713-908630
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-07-09 at 22:12 +0800, Jilin Yuan wrote:
>  Delete the redundant word 'to'.
>  Delete the redundant word 'the'.
[]
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
[]
> @@ -251,7 +251,7 @@ static void iwl_mvm_wowlan_get_rsc_tsc_data(struct ieee80211_hw *hw,
>  
>  		/*
>  		 * For non-QoS this relies on the fact that both the uCode and
> -		 * mac80211 use TID 0 (as they need to to avoid replay attacks)
> +		 * mac80211 use TID 0 (as they need to avoid replay attacks)

Maybe ok as is, could be "as required to" or "as they must to"

