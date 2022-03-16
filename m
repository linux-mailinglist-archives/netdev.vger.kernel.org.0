Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9674DB77C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 18:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347612AbiCPRlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 13:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343619AbiCPRlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 13:41:35 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEAF6BDE6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 10:40:20 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nUXdC-0007y5-Fh; Wed, 16 Mar 2022 18:40:18 +0100
Message-ID: <0238dcae-ee6f-2140-1895-4153c441d333@leemhuis.info>
Date:   Wed, 16 Mar 2022 18:40:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Manish Chopra <manishc@marvell.com>
Cc:     buczek@molgen.mpg.de, kuba@kernel.org, netdev@vger.kernel.org,
        aelior@marvell.com, it+netdev@molgen.mpg.de,
        regressions@lists.linux.dev
References: <20220316111842.28628-1-manishc@marvell.com>
 <5f136c0c-2e16-d176-3d4a-caed6c3420a7@molgen.mpg.de>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [RFC net] bnx2x: fix built-in kernel driver load failure
In-Reply-To: <5f136c0c-2e16-d176-3d4a-caed6c3420a7@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1647452421;ff6fdb67;
X-HE-SMSGID: 1nUXdC-0007y5-Fh
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.03.22 18:09, Paul Menzel wrote:
> Am 16.03.22 um 12:18 schrieb Manish Chopra:
>> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
>> Fixes: b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
> 
> The regzbot also asks to add the tag below [1].
> 
> Link:
> https://lore.kernel.org/r/46f2d9d9-ae7f-b332-ddeb-b59802be2bab@molgen.mpg.de

For the record: yes, regzbot needs them, but it something old. IOW:
developers should be setting them for years now and quite a few do so,
but some do not. The docs recently got changed to make this aspect
clearer. See 'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst' for details:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html
https://www.kernel.org/doc/html/latest/process/5.Posting.html

Ciao, Thorsten
