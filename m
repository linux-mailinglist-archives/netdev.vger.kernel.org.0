Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478A166E72F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 20:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjAQTl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 14:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbjAQThe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 14:37:34 -0500
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3876F49979
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:42:28 -0800 (PST)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id HquGptzuwnIv0HquHp6GL6; Tue, 17 Jan 2023 19:42:04 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 17 Jan 2023 19:42:04 +0100
X-ME-IP: 86.243.2.178
Message-ID: <345bf5a4-dd58-e906-0236-781ef04bd7e8@wanadoo.fr>
Date:   Tue, 17 Jan 2023 19:42:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: RE: [PATCH linux-next] atm: lanai: Use dma_zalloc_coherent()
Content-Language: fr, en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        "'ye.xingchen@zte.com.cn'" <ye.xingchen@zte.com.cn>,
        "3chas3@gmail.com" <3chas3@gmail.com>
Cc:     "linux-atm-general@lists.sourceforge.net" 
        <linux-atm-general@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <202301171721076625091@zte.com.cn>
 <913000213dd14e3b9da69270134aafa3@AcuMS.aculab.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <913000213dd14e3b9da69270134aafa3@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 17/01/2023 à 16:37, David Laight a écrit :
> From: ye.xingchen@zte.com.cn
>> Sent: 17 January 2023 09:21
>>
>> Instead of using dma_alloc_coherent() and memset() directly use
>> dma_zalloc_coherent().
> 
> I'm sure I've a brain cell that remembers that dma_alloc_coherent()
> always zeros the buffer.
> So the 'zalloc' variant isn't needed and the memset() can just
> be deleted.
> OTOH is it really worth the churn.

More-over, dma_zalloc_coherent() has been removed at the very beginning 
of 2019 in commit dfd32cad146e.

It is not existing since v5.0-rc2.

\o/


CJ

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

