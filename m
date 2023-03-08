Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF9E6B1198
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCHTBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCHTB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:01:29 -0500
Received: from out-3.mta0.migadu.com (out-3.mta0.migadu.com [IPv6:2001:41d0:1004:224b::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E565E8C0E3
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 11:01:27 -0800 (PST)
Message-ID: <520eb192-8b56-dde1-1b37-494a0d4d14b6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678302086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+Jx7B9/wVfYSZtUreehVZ7HluDBmRVTFQWbWdYxVZc=;
        b=XQberEoXBCtKr8PtlqWRQcA7PgIRXtODuVF/ne3agGoqSyfxnymLFmDXo+LDyJgLx4MO2s
        ewF83gMyZ+IDFqLLwTSXWX8tLJs70/yNYXXxh+sybLVtf3tp01ZqC67WosP05oL1oDDzxj
        K/sbyTB82uER4EiFzMLxt0Td/njUZeY=
Date:   Wed, 8 Mar 2023 19:01:22 +0000
MIME-Version: 1.0
Subject: Re: [net-next] ptp_ocp: add force_irq to xilinx_spi configuration
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
References: <20230306155726.4035925-1-vadfed@meta.com>
 <20230306124952.1b86d165@kernel.org>
 <2c9e80b1-3afc-9b78-755b-222da349212f@linux.dev>
 <20230306132013.6b05411e@kernel.org> <20230306132200.15d2dbfb@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20230306132200.15d2dbfb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/03/2023 21:22, Jakub Kicinski wrote:
> On Mon, 6 Mar 2023 13:20:13 -0800 Jakub Kicinski wrote:
>> On Mon, 6 Mar 2023 21:10:40 +0000 Vadim Fedorenko wrote:
>>> On 06.03.2023 20:49, Jakub Kicinski wrote:
>>>> Give it until Friday, the patch needs to be in the networking trees
>>>> (our PR cadence during the merge window is less regular than outside
>>>> it).
>>>
>>> Looks like "1dd46599f83a spi: xilinx: add force_irq for QSPI mode" is in net and
>>> net-next trees already? Or which patch are you talking about?
>>
>> Hm, you're right. Any idea why both kbuild bot and our own CI think
>> this doesn't build, then?
> 
> Probably because they both use master :S
> 
> kernel test robot folks, could you please switch from master to main
> as the base for networking patches?

Should I re-send it? It's marked as Deffered and is not going forward...
