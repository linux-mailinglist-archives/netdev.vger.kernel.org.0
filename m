Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2E950FA25
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348750AbiDZKWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348801AbiDZKWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:22:31 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD56B24968;
        Tue, 26 Apr 2022 02:52:23 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 7194C1E80D56;
        Tue, 26 Apr 2022 17:49:09 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Lx14sW9fD0dM; Tue, 26 Apr 2022 17:49:06 +0800 (CST)
Received: from [18.165.124.109] (unknown [101.228.255.56])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 26C751E80CE6;
        Tue, 26 Apr 2022 17:49:06 +0800 (CST)
Message-ID: <e4525347-f3b1-440c-b72b-4b7a6830a0d1@nfschina.com>
Date:   Tue, 26 Apr 2022 17:52:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   yuzhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] batman-adv: remove unnecessary type castings
To:     Sven Eckelmann <sven@narfation.org>, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        kernel-janitors@vger.kernel.org
References: <20220421154829.9775-1-yuzhe@nfschina.com>
 <20220425113635.1609532-1-yuzhe@nfschina.com> <2133162.nbW41nx31j@ripper>
In-Reply-To: <2133162.nbW41nx31j@ripper>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I agree, this patch is better. And I have tested, no sparse warning anymore.

Thank your for your help.

       

在 2022/4/25 20:50, Sven Eckelmann 写道:

     

>        
> On Monday, 25 April 2022 13:36:35 CEST Yu Zhe wrote:
>        
>>          
>> remove unnecessary void* type castings.
>>
>> Signed-off-by: Yu Zhe<yuzhe@nfschina.com>
>> ---
>>   net/batman-adv/translation-table.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>        
>        
> If you send a second version then please use `git format-patch -v2 ...` to
> format the patch. Now it looks in patchworks like you've resent the first
> version again. And please also add a little changelog after "---" which
> explains what you've changed. It is trivial in this little patch but still
> might be useful.
>
> Regarding the patch: Now you've removed bridge_loop_avoidance.c +
> batadv_choose_tt instead of fixing your patch. I would really prefer this
> patch version:
>
> https://git.open-mesh.org/linux-merge.git/commitdiff/8864d2fcf04385cabb8c8bb159f1f2ba5790cf71
>
> Kind regards,
> 	Sven
>      
