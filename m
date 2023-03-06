Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1916ACDA5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 20:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjCFTNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 14:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjCFTNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 14:13:51 -0500
Received: from out-34.mta0.migadu.com (out-34.mta0.migadu.com [IPv6:2001:41d0:1004:224b::22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277C33B0E3
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 11:13:50 -0800 (PST)
Message-ID: <d779bdc9-26af-810a-ca24-86a5b97cfc72@linux.dev>
Date:   Mon, 6 Mar 2023 19:13:43 +0000
MIME-Version: 1.0
Subject: Re: [PATCH net] bnxt_en: reset PHC frequency in free-running mode
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
References: <20230306165344.350387-1-vadfed@meta.com>
 <20230306100616.6ece1694@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20230306100616.6ece1694@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/03/2023 18:06, Jakub Kicinski wrote:
> On Mon, 6 Mar 2023 08:53:44 -0800 Vadim Fedorenko wrote:
>> +#define BNXT_PTP_RTC(bp)	(!BNXT_MH(bp) && \
>> +				 ((bp)->fw_cap & BNXT_FW_CAP_PTP_RTC))
> 
> nit: maybe BNXT_PTP_USE_RTC() ?

That's fair point. I'll change it in v2.
Thanks.
