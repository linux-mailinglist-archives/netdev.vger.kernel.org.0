Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8611B227066
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 23:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgGTVeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 17:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGTVeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 17:34:07 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268FFC061794;
        Mon, 20 Jul 2020 14:34:07 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 15524BC17C;
        Mon, 20 Jul 2020 21:34:00 +0000 (UTC)
Subject: Re: [PATCH for v5.9] RDS: Replace HTTP links with HTTPS ones
To:     Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200719155845.59947-1-grandmaster@al2klimov.de>
 <20200720045626.GF127306@unreal> <20200720075848.26bc3dfe@lwn.net>
 <20200720140716.GB1080481@unreal> <20200720083635.3e7880ce@lwn.net>
 <20200720164827.GC1080481@unreal>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <c78d0958-c4ef-9754-c189-ffc507ca1340@al2klimov.de>
Date:   Mon, 20 Jul 2020 23:34:00 +0200
MIME-Version: 1.0
In-Reply-To: <20200720164827.GC1080481@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spamd-Bar: /
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 20.07.20 um 18:48 schrieb Leon Romanovsky:
> On Mon, Jul 20, 2020 at 08:36:35AM -0600, Jonathan Corbet wrote:
>> On Mon, 20 Jul 2020 17:07:16 +0300
>> Leon Romanovsky <leon@kernel.org> wrote:
>>
>>>> Do *you* want to review that megapatch?  The number of issues that have
This question is... interesting.
And no, I would not.

>>>> come up make it clear that these patches do, indeed, need review...
>>>
>>> Can you point me to the issues?
>>> What can go wrong with such a simple replacement?
>>
>> Some bits of the conversation:
>>
>>    https://lore.kernel.org/lkml/20200626110219.7ae21265@lwn.net/
>>    https://lore.kernel.org/lkml/20200626110706.7b5d4a38@lwn.net/
>>    https://lore.kernel.org/lkml/20200705142506.1f26a7e0@lwn.net/
>>    https://lore.kernel.org/lkml/20200713114321.783f0ae6@lwn.net/
>>    https://lore.kernel.org/lkml/202007081531.085533FC5@keescook/
>>
>> etc.
> 
> After reading your links and especially this one.
> https://lore.kernel.org/lkml/20200713114321.783f0ae6@lwn.net/
> I don't understand why are we still seeing these patches?
> 
> I gave to the author comments too, which were ignored.
> https://patchwork.kernel.org/patch/11644683/#23466547
I've added SPDXing (the automated way of course ;) ) to my todo list.

> 
> Thanks
> 
>>
>> jon
