Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464C55442CE
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbiFIE7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiFIE7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:59:30 -0400
Received: from smtp.smtpout.orange.fr (smtp01.smtpout.orange.fr [80.12.242.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3901E4BE2
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 21:59:27 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id zAGRnsqeNk3ICzAGRnIqe6; Thu, 09 Jun 2022 06:59:25 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 09 Jun 2022 06:59:25 +0200
X-ME-IP: 90.11.190.129
Message-ID: <22584780-a2eb-0a83-daaa-f259aa2adc42@wanadoo.fr>
Date:   Thu, 9 Jun 2022 06:59:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] virtio: Directly use ida_alloc_range()/ida_free()
Content-Language: en-US
To:     =?UTF-8?B?dG9tb3Jyb3cgV2FuZyAo546L5b635piOKQ==?= 
        <wangdeming@inspur.com>, "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <aff7bba2680b49fab6a14694e33fd41d@inspur.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <aff7bba2680b49fab6a14694e33fd41d@inspur.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 09/06/2022 à 02:42, tomorrow Wang (王德明) a écrit :
>>
>> An explanation in the commit log of why the -1 is needed would also help
>> reviewer/maintainer, IMHO.
>>
>> It IS correct, but it is not that obvious without looking at
>> ida_simple_get() and ida_alloc_range().
>>
> 
> can I mention one patch about repair ida_free  for this.
> 
> 

If you manage to find another patch and provide a lore.kernel.org link 
to it, I think it should be okay.

However, after a *quick* look in some mailing list, I've not found yet a 
description for that.

CJ
