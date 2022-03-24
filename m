Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CCF4E670C
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351696AbiCXQdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243623AbiCXQdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:33:40 -0400
Received: from mxout013.mail.hostpoint.ch (mxout013.mail.hostpoint.ch [IPv6:2a00:d70:0:e::313])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686A2AA017;
        Thu, 24 Mar 2022 09:32:07 -0700 (PDT)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout013.mail.hostpoint.ch with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1nXQNX-000Ea7-Qc; Thu, 24 Mar 2022 17:32:03 +0100
Received: from [2a00:a680:2222:ff00:421d:ad7:faa1:5cf9]
        by asmtp013.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1nXQNX-0006cw-L3;
        Thu, 24 Mar 2022 17:32:03 +0100
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
Message-ID: <b764c724-9481-09ed-8dd5-a0ebeb0f8a25@reto-schneider.ch>
Date:   Thu, 24 Mar 2022 17:32:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 0/2] rtl8xxxu: Fill up more TX information
Content-Language: en-US
To:     Chris Chiu <chris.chiu@canonical.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@kernel.org,
        Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org
References: <20220318024216.42204-1-chris.chiu@canonical.com>
From:   Reto Schneider <code@reto-schneider.ch>
In-Reply-To: <20220318024216.42204-1-chris.chiu@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18.03.22 03:42, Chris Chiu wrote:
> The antenna information is missing in rtl8xxxu and txrate is NULL
> in 8188cu and 8192cu. Fill up the missing information for iw
> commands.
> 
> Chris Chiu (2):
>    rtl8xxxu: feed antenna information for cfg80211
>    rtl8xxxu: fill up txrate info for gen1 chips
> 
>   .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 75 +++++++++++++++++++
>   1 file changed, 75 insertions(+)
> 

Those two patches applied to most recent master 
(v5.17-4443-ged4643521e6a) do not compile as rtl8xxxu_legacy_ratetable[] 
and rtl8xxxu_desc_to_mcsrate() are defined twice.

Kind regards,
Reto
