Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF624DCB67
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbiCQQ3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiCQQ3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:29:30 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77385F61F5;
        Thu, 17 Mar 2022 09:28:12 -0700 (PDT)
Received: from [192.168.0.3] (ip5f5aef3c.dynamic.kabel-deutschland.de [95.90.239.60])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7E29261EA1923;
        Thu, 17 Mar 2022 17:28:09 +0100 (CET)
Message-ID: <d0955a71-4b29-d915-f2ff-c90e8776eb41@molgen.mpg.de>
Date:   Thu, 17 Mar 2022 17:28:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [EXT] Re: [PATCH net] bnx2x: fix built-in kernel driver load
 failure
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        Ariel Elior <aelior@marvell.com>, regressions@lists.linux.dev,
        stable@vger.kernel.org, it+netdev@molgen.mpg.de
References: <20220316214613.6884-1-manishc@marvell.com>
 <35d305f5-aa84-2c47-7efd-66fffb91c398@molgen.mpg.de>
 <BY3PR18MB46129020BC8C93377CA16FB8AB129@BY3PR18MB4612.namprd18.prod.outlook.com>
 <1986e70f-9e3b-cc64-4c15-dbc2abd1dc8d@molgen.mpg.de>
 <20220317083314.54f360b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220317083314.54f360b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub,


Am 17.03.22 um 16:33 schrieb Jakub Kicinski:
> On Thu, 17 Mar 2022 14:31:45 +0100 Paul Menzel wrote:
>>>> I think it’s important to document, that the firmware was not present in the
>>>> initrd.
>>>
>>> I believe this problem has nothing to do with initrd module/FW but
>>> rather a module built in the kernel/vmlinuz (CONFIG_BNX2X=y) itself,
>>> A module load from initrd works fine and can access the initrd FW
>>> files present in initrd file system even during the probe. For
>>> example, when I had CONFIG_BNX2X=m, it loads the module fine from
>>> initrd with FW files present in initrd file system. When I had
>>> CONFIG_BNX2X=y, which I believe doesn't install/load module in/from
>>> initrd but in kernel (vmlinuz) itself, that's where it can't access
>>> the firmware file and cause the load failure.
>>
>> I can only say, that adding the firmware to the initrd worked around the
>> problem on our side with `CONFIG_BNX2X=y`.
> 
> I'd like to ship this one to Linus today. It sounds like it's
> okay from functional perspective, can I improve the commit message as
> you were suggesting and leave the comment / print improvements to a
> later patch?

Sure, fine by me.


Kind regards,

Paul
