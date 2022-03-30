Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19444EBC98
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 10:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240416AbiC3IV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 04:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiC3IVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 04:21:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5840530F57;
        Wed, 30 Mar 2022 01:20:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F7BB60B65;
        Wed, 30 Mar 2022 08:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBBAC340EC;
        Wed, 30 Mar 2022 08:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648628401;
        bh=jlt7IgYw10SWGER4k+S1mS11PUUsamc2YkuHy9CpYeE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HK3te1n3fuyCH5JiyLIu9Z+Uc8u0ZqR5YTqkKOp1zygqVqIQ7IeNSMErumJj5rcAY
         pKwXiselA6marSTubH9Yge1KM10FlS3d1qkMdzy8lsUGoyCAdZUgQxqPAhT55k48yE
         BDHqHCwB5lmTa5JEAMWZcGV0W2X+cQsE9mUOcY3nZH2RyUeTS93UPj1I+az6XQrzOw
         phsw35nsIRHAk1xNKzKt7lRZyL0qiH/iA8AMhKlCRfGFewaFVF/BMYy0H1N9Ajop2N
         Ie8dEXTnUhkn9QOYjLlIpSpkm9avoj3BMyPBJ8xiQZVQXaPk9fMtWt2QCQD1PScn+i
         8D90loBcAPSgQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Benjamin =?utf-8?Q?St=C3=BCrz?= <benni@stuerz.xyz>,
        <loic.poulain@linaro.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/22 v2] wcn36xx: Improve readability of wcn36xx_caps_name
References: <20220326165909.506926-1-benni@stuerz.xyz>
        <20220326165909.506926-19-benni@stuerz.xyz>
        <f0ebc901-051a-c7fe-ca5a-bc798e7c31e7@quicinc.com>
        <720e4d68-683a-f729-f452-4a9e52a3c6fa@stuerz.xyz>
        <ff1ecd47-d42a-fa91-5c5c-e23ac183f525@quicinc.com>
        <87y20rx6mx.fsf@kernel.org>
Date:   Wed, 30 Mar 2022 11:19:53 +0300
In-Reply-To: <87y20rx6mx.fsf@kernel.org> (Kalle Valo's message of "Wed, 30 Mar
        2022 10:05:10 +0300")
Message-ID: <87ee2jx36e.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Jeff Johnson <quic_jjohnson@quicinc.com> writes:
>
>> (apologies for top-posting)
>> When you submit new patches you should not do so as a reply, but
>> instead as a new thread with a new version number.
>>
>> And since multiple folks have suggested that you submit on a
>> per-subsystem basis I suggest that you re-send this as a singleton
>> just to wcn36xx@lists.infradead.org and linux-wireless@vger.kernel.org
>> along with the associated maintainers.
>>
>> So I believe [PATCH v3] wcn36xx:... would be the correct subject, but
>> I'm sure Kalle will let us know otherwise
>
> You are correct. Also I strongly recommend using git send-email instead
> of Mozilla. Patch handling is automated using patchwork and git, so
> submitting patches manually is error prone.

Yeah, our patchwork didn't even detect this patch. But v3 is visible and
is on my queue:

https://patchwork.kernel.org/project/linux-wireless/patch/20220328212912.283393-1-benni@stuerz.xyz/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
