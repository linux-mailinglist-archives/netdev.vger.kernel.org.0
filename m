Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0924D6ACFE6
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCFVLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCFVLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:11:24 -0500
Received: from out-47.mta1.migadu.com (out-47.mta1.migadu.com [IPv6:2001:41d0:203:375::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A21A69CF1
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:10:44 -0800 (PST)
Message-ID: <2c9e80b1-3afc-9b78-755b-222da349212f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678137042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GEJoV7V5QonPGTVvNoShe6rhFk+1Zhdbj5B0zFKRiQ=;
        b=lnVOZBeAC5XcEiT3cu543HqamPVOYmnTaka2gOjISvujyDTNj6p2K1pTCIm6Ti2eA/SHSK
        7ITiq0P8F89wTyd+Ycwvc9NpAPyp2DNMe1e9UjwxpHTrL/lt4uhDLcV7WscBrD7X7mNMBD
        11eN6jWDaX4W8Qag86avJkfNulhmLSw=
Date:   Mon, 6 Mar 2023 21:10:40 +0000
MIME-Version: 1.0
Subject: Re: [net-next] ptp_ocp: add force_irq to xilinx_spi configuration
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
References: <20230306155726.4035925-1-vadfed@meta.com>
 <20230306124952.1b86d165@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20230306124952.1b86d165@kernel.org>
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

On 06.03.2023 20:49, Jakub Kicinski wrote:
> On Mon, 6 Mar 2023 07:57:26 -0800 Vadim Fedorenko wrote:
>> Flashing firmware via devlink flash was failing on PTP OCP devices
>> because it is using Quad SPI mode, but the driver was not properly
>> behaving. With force_irq flag landed it now can be fixed.
>>
>> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> 
> Give it until Friday, the patch needs to be in the networking trees
> (our PR cadence during the merge window is less regular than outside
> it).

Looks like "1dd46599f83a spi: xilinx: add force_irq for QSPI mode" is in net and 
net-next trees already? Or which patch are you talking about?
