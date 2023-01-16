Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F9A66BA53
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjAPJ25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbjAPJ2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:28:35 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1D516AC5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:27:51 -0800 (PST)
Received: from [192.168.0.2] (ip5f5ae97d.dynamic.kabel-deutschland.de [95.90.233.125])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id B104961CC457B;
        Mon, 16 Jan 2023 10:27:47 +0100 (CET)
Message-ID: <3fbda4db-2b07-201f-540f-e19069ab3b99@molgen.mpg.de>
Date:   Mon, 16 Jan 2023 10:27:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Intel-wired-lan] [PATCH 1/1] ice: Mention CEE DCBX in code
 comment
To:     Zhu Yanjun <yanjun.zhu@intel.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230116185131.63315-1-yanjun.zhu@intel.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230116185131.63315-1-yanjun.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Zhu,


Am 16.01.23 um 19:51 schrieb Zhu Yanjun:

[…]

Your patch message again has a date from the future, messing up people’s 
inbox sorting/ordering. Could you please fix that?


Kind regards,

Paul
