Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB0B535ADE
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbiE0H6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242234AbiE0H6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:58:09 -0400
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr [80.12.242.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9DE64BD0
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 00:58:04 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.191.102])
        by smtp.orange.fr with ESMTPA
        id uUrAnKWhD5ohRuUrAn770b; Fri, 27 May 2022 09:58:03 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 27 May 2022 09:58:03 +0200
X-ME-IP: 90.11.191.102
Message-ID: <9930ff36-90fe-d072-c1f1-5abf753feff4@wanadoo.fr>
Date:   Fri, 27 May 2022 09:58:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] mac80211: Directly use ida_alloc()/free()
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     liuke94@huawei.com, davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
References: <20220527074132.2474867-1-liuke94@huawei.com>
 <a3e0df04-fb94-ef38-c2dc-1c41e6c721d9@wanadoo.fr> <87czfzxvyu.fsf@kernel.org>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <87czfzxvyu.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/05/2022 à 09:42, Kalle Valo a écrit :
> Christophe JAILLET <christophe.jaillet@wanadoo.fr> writes:
> 
>> Le 27/05/2022 à 09:41, keliu a écrit :
>>> Use ida_alloc()/ida_free() instead of deprecated
>>> ida_simple_get()/ida_simple_remove() .
>>>
>>> Signed-off-by: keliu <liuke94-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Heh, this email address got me confused :) I guess you (Christophe) use
> gmane and it's just some obfuscation done by gmane?
> 

Yes, I use gname and thunderbird as a client. I also think that it is 
some obfuscation done by gname.

This kind of obfuscation is not done on all messages, and not done 
consistently on the message of the same ML. I don't know the rule that 
is applied.

CJ
