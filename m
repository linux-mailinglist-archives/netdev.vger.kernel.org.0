Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA84E60240C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 07:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiJRF6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 01:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiJRF6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 01:58:01 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C45A4878
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 22:57:58 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5ae87c.dynamic.kabel-deutschland.de [95.90.232.124])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 212C461EA192A;
        Tue, 18 Oct 2022 07:57:55 +0200 (CEST)
Message-ID: <2d522491-e4f1-9e4a-c713-4adc4990f04f@molgen.mpg.de>
Date:   Tue, 18 Oct 2022 07:57:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [Intel-wired-lan] [PATCH v2 2/5] net-timestamp: Increase the size
 of tsflags
Content-Language: en-US
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc:     leon@kernel.org, netdev@vger.kernel.org, richardcochran@gmail.com,
        saeed@kernel.org, edumazet@google.com, gal@nvidia.com,
        kuba@kernel.org, michael.chan@broadcom.com, davem@davemloft.net,
        andy@greyhouse.net, intel-wired-lan@osuosl.org
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
 <20221018010733.4765-3-muhammad.husaini.zulkifli@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221018010733.4765-3-muhammad.husaini.zulkifli@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Muhammad,


Thank you for the patch. For the summary/title you could be more 
specific with

 > net-timestamp: Double tsflags size to 32-bit for more flags


Kind regards,

Paul
