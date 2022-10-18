Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1CF6027C6
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiJRJB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiJRJBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:01:23 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A9BA9262
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:01:10 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 5909C504ECC;
        Tue, 18 Oct 2022 11:57:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 5909C504ECC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666083424; bh=Ug6hgJev9iJ7Tar7gkXPxcFPnlou76kmgQOLdhwfcsw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=vnism6MFlaXNTe3XuaDKRHcdvtV58+UhHAKTHwV+ArORd7P8SMUSeHv+lV/zQ6j6j
         8HN7jBbxWiLydEbpWj0OeM2hHfQVU/Ayx+j4er/oglWeK7q+jehgKg7yfqiTqZxWCf
         NASBrYBdrN6q9khXTuLzgN544NJgng7u99r76DGY=
Message-ID: <6ffd89ac-7393-262d-6e48-51b0536cc0f1@novek.ru>
Date:   Tue, 18 Oct 2022 10:00:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 0/5] ptp: ocp: add support for Orolia ART-CARD
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20221018085418.2163-1-vfedorenko@novek.ru>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20221018085418.2163-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.10.2022 09:54, Vadim Fedorenko wrote:
> Orolia company created alternative open source TimeCard. The hardware of
> the card provides similar to OCP's card functions, that's why the support
> is added to current driver.
> 
> The first patch in the series changes the way to store information about
> serial ports and is more like preparation.
> 
> The patches 2 to 4 introduces actual hardware support.
> 
> The last patch removes fallback from devlink flashing interface to protect
> against flashing wrong image. This became actual now as we have 2 different
> boards supported and wrong image can ruin hardware easily.
> 
> v2:
>    Address comments from Jonathan Lemon
> 
> Vadim Fedorenko (5):
>    ptp: ocp: upgrade serial line information
>    ptp: ocp: add Orolia timecard support
>    ptp: ocp: add serial port of mRO50 MAC on ART card
>    ptp: ocp: expose config and temperature for ART card
>    ptp: ocp: remove flash image header check fallback
> 
>   drivers/ptp/ptp_ocp.c | 566 ++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 519 insertions(+), 47 deletions(-)
> 

Please, ignore this one, the next is coming with fixes of what was reported by 
kernel test bot
