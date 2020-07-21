Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5F62278F7
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgGUGnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:43:07 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:59272 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgGUGnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 02:43:07 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id D8097BC1B7;
        Tue, 21 Jul 2020 06:43:01 +0000 (UTC)
Subject: Re: [PATCH for v5.9] RDS: Replace HTTP links with HTTPS ones
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, santosh.shilimkar@oracle.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200719155845.59947-1-grandmaster@al2klimov.de>
 <20200720045626.GF127306@unreal> <20200720075848.26bc3dfe@lwn.net>
 <20200720140716.GB1080481@unreal> <20200720083635.3e7880ce@lwn.net>
 <20200720164827.GC1080481@unreal>
 <c78d0958-c4ef-9754-c189-ffc507ca1340@al2klimov.de>
 <20200721060529.GF1080481@unreal>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <f1df7901-35ef-af8a-b852-e5e89ababf01@al2klimov.de>
Date:   Tue, 21 Jul 2020 08:43:00 +0200
MIME-Version: 1.0
In-Reply-To: <20200721060529.GF1080481@unreal>
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



Am 21.07.20 um 08:05 schrieb Leon Romanovsky:
> On Mon, Jul 20, 2020 at 11:34:00PM +0200, Alexander A. Klimov wrote:
>>
>>
>> Am 20.07.20 um 18:48 schrieb Leon Romanovsky:
>>> On Mon, Jul 20, 2020 at 08:36:35AM -0600, Jonathan Corbet wrote:
>>>> On Mon, 20 Jul 2020 17:07:16 +0300
>>>> Leon Romanovsky <leon@kernel.org> wrote:
>>>>
>>>>>> Do *you* want to review that megapatch?  The number of issues that have
>> This question is... interesting.
>> And no, I would not.
> 
> You are EXPECTED to review your work prior sending to the mailing list.
I meant I wouldn't review *one big* patch.
I didn't mean my actually sent smaller ones.

> 
>>
>>>>>> come up make it clear that these patches do, indeed, need review...
>>>>>
>>>>> Can you point me to the issues?
>>>>> What can go wrong with such a simple replacement?
>>>>
>>>> Some bits of the conversation:
>>>>
>>>>     https://lore.kernel.org/lkml/20200626110219.7ae21265@lwn.net/
>>>>     https://lore.kernel.org/lkml/20200626110706.7b5d4a38@lwn.net/
>>>>     https://lore.kernel.org/lkml/20200705142506.1f26a7e0@lwn.net/
>>>>     https://lore.kernel.org/lkml/20200713114321.783f0ae6@lwn.net/
>>>>     https://lore.kernel.org/lkml/202007081531.085533FC5@keescook/
>>>>
>>>> etc.
>>>
>>> After reading your links and especially this one.
>>> https://lore.kernel.org/lkml/20200713114321.783f0ae6@lwn.net/
>>> I don't understand why are we still seeing these patches?
>>>
>>> I gave to the author comments too, which were ignored.
>>> https://patchwork.kernel.org/patch/11644683/#23466547
>> I've added SPDXing (the automated way of course ;) ) to my todo list.
> 
> OMG, why don't you listen? We don't want your automatic patches.
Wrong.
*Some of you* don't want my automatic patches.
And *some others* already applied them and said thanks.

> 
> Thanks
> 
>>
>>>
>>> Thanks
>>>
>>>>
>>>> jon
