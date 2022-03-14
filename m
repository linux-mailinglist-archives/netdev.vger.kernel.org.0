Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8074D83F9
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbiCNMW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243950AbiCNMVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:21:25 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE32C13D3A;
        Mon, 14 Mar 2022 05:19:22 -0700 (PDT)
Received: from [192.168.1.214] (dynamic-077-183-023-142.77.183.pool.telefonica.de [77.183.23.142])
        by linux.microsoft.com (Postfix) with ESMTPSA id 37FE020C3630;
        Mon, 14 Mar 2022 05:19:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 37FE020C3630
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1647260362;
        bh=mbgd05mcnMN1mk5v2XgVxjCg3+OTPb+7RgVuSIPwnfY=;
        h=Subject:Cc:References:To:From:Date:In-Reply-To:From;
        b=NBziw6AP9EdxXmxeAKezhWLSqRWpiknv/LWlcydJb9yU7Wrr0JwmcKkkfSdJjxwCA
         /pR0joCvehVapRjS9oiFZbrvu7RWjYOHoajuAwjsKfS6v690gC4nm7ZJmt9NuvfOAj
         tWkfWKCrh9QCG1dx8BgSqOhac9nYuOG+PXbv0p5U=
Subject: Re: [PATCH] Revert "xfrm: state and policy should fail if XFRMA_IF_ID
 0"
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paul Chaignon <paul@cilium.io>,
        Eyal Birger <eyal.birger@gmail.com>
References: <20220303145510.324-1-kailueke@linux.microsoft.com>
 <20220307082245.GA1791239@gauss3.secunet.de>
To:     stable@vger.kernel.org
From:   Kai Lueke <kailueke@linux.microsoft.com>
Message-ID: <076e8c72-b842-64a8-7a4b-9a3b30715b5d@linux.microsoft.com>
Date:   Mon, 14 Mar 2022 13:19:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20220307082245.GA1791239@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I forgot to CC stable@ when submitting, doing it now:
Can this be picked for the next round of stable kernels (down to 5.10)?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a3d9001b4e287fc043e5539d03d71a32ab114bcb

Thanks,
Kai

On 07.03.2022 09:22, Steffen Klassert wrote:
> On Thu, Mar 03, 2022 at 03:55:10PM +0100, kailueke@linux.microsoft.com wrote:
>> From: Kai Lueke <kailueke@linux.microsoft.com>
>>
>> This reverts commit 68ac0f3810e76a853b5f7b90601a05c3048b8b54 because ID
>> 0 was meant to be used for configuring the policy/state without
>> matching for a specific interface (e.g., Cilium is affected, see
>> https://github.com/cilium/cilium/pull/18789 and
>> https://github.com/cilium/cilium/pull/19019).
>>
>> Signed-off-by: Kai Lueke <kailueke@linux.microsoft.com>
> Applied, thanks Kai!
