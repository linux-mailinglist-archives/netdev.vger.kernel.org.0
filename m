Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B956693BE
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 11:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238573AbjAMKJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 05:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbjAMKJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 05:09:21 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C84482A0
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 02:09:19 -0800 (PST)
Received: from [192.168.0.2] (ip5f5ae98f.dynamic.kabel-deutschland.de [95.90.233.143])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id ADFC260027FC1;
        Fri, 13 Jan 2023 11:09:16 +0100 (CET)
Message-ID: <9f804e8f-6218-47b3-99a8-583cc65ccde7@molgen.mpg.de>
Date:   Fri, 13 Jan 2023 11:09:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Intel-wired-lan] [PATCH 1/1] ice: Add the CEE DCBX support in
 the comments
Content-Language: en-US
To:     Zhu Yanjun <yanjun.zhu@intel.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230113231912.22423-1-yanjun.zhu@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230113231912.22423-1-yanjun.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Zhu,


Thank you for your patch. (Unfortunately your system time is incorrect, 
so the message date is from the future.)

Am 14.01.23 um 00:19 schrieb Zhu Yanjun:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>

Maybe use the following summary/title/subject:

ice: Mention CEE DCBX in code comment

> From the function ice_parse_org_tlv, CEE DCBX TLV is also supported.
> The comments are changed.

…, so update the comment.

> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
>   drivers/net/ethernet/intel/ice/ice_dcb.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

The rest looks good.

[…]


Kind regards,

Paul
