Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E58F6AD1F1
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 23:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCFWrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 17:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCFWrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 17:47:52 -0500
Received: from out-34.mta0.migadu.com (out-34.mta0.migadu.com [IPv6:2001:41d0:1004:224b::22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2420C3BDBF
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 14:47:23 -0800 (PST)
Message-ID: <8d7c2cd4-3a79-d10a-4939-2aee152221b2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678142839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R90w6K1ezpzcRNHWyOrsObkn9vgNyxoA/OohBf3x8QA=;
        b=hj9RorlvB4ve6WsG+nSMca5Al+gZWJLZd5v2gE1rJ2mx2WSNBMnRhGOEGCimFE3y2upqR5
        6+bkg6GxyAE3Ampnq6kerrWwwMNY9mD/XJo3RiltZpjXlRvXWzdQgpHlE9wsJ7kwhyuUrF
        r2IVqiBGYiyoxo5Q3ReXDLFI6wbIhmQ=
Date:   Mon, 6 Mar 2023 22:47:17 +0000
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.03.2023 21:22, Jakub Kicinski wrote:
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

Very interesting side effect of renaming!
Thanks!
