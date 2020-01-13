Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF0C1396E2
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 17:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgAMQ7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 11:59:02 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32953 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgAMQ7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 11:59:02 -0500
Received: by mail-wm1-f66.google.com with SMTP id d139so330375wmd.0
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 08:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QBIRJCKw2v/N53rmU/rEEYSzvmZ9/yqtGE4CkG8bJxU=;
        b=u2NiOEj1bxqhdSQXcEr4NNuF0n25QgDr3+05MygsVI2kVnApX4pzaM7l2dNXRdANdJ
         6f2171iX9+tAqAzktef0Ld+mmQImMrbLsLae0hbGm1LSanCHvFcjwSm3zZVWM7gf7ne3
         BuF6SrFASLWx01qWgu6h0XCd44/6XB8uJrlq8Wi/vfEVtvsHWdJFy+/f70te4/FqH5/N
         JafLXo/b85aOCpVYbuNO8kmj4wPPuaQNN6MTm+dsOnXWG1fNjgkBXhe829iNrpcdax86
         /Ccowq1yuU+No6mYgyx5PWRTLOfU0aom5zlZMg+QE5sfQziOcvEFWtM+ylboQ/9afMb9
         QUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QBIRJCKw2v/N53rmU/rEEYSzvmZ9/yqtGE4CkG8bJxU=;
        b=S+ZdTimU/gkn3wiJSAlC0Q5xu8zhJbBzFHjDQs1O/eB0H26aU6RyXT4lcfptFSOeYt
         It94oIWRbKz0SmH8tHsJeY5buPoB00pbIsIq/hLrXN6IuIoioRqMruroBM6/d7MZ48V9
         EoNsQddIyhl5WgZzYC3I1hpWcT1tkKhMJkRRfxXSL4nvSRAMrj9Ejcf041suaHAWCacu
         a/u8/I7ixWRuFh34tVzYs5K7mdNNtzUyeG9Y7Q1PSGlTmTYa5Xw/aSF1CDVenWfzEiPE
         4W+7HFbM2jYlkVMUwG/QfXzLVIRR3TLwlicp2UIkVOkyxijROOaWR999MurzUhoX7gS4
         TgYQ==
X-Gm-Message-State: APjAAAUABsYGsbOOxJsDJZeWxkvQ2mlgxrmZeNwb20pt7ExIOq1mc79n
        RU3evBmWau2HqvT+5PIhMRvw9Q==
X-Google-Smtp-Source: APXvYqzwLZORPn3fhDBkb7n5sKnoJxe6OpnFTqLd0THToVcMkvK1BhTUUwOoz+nzeYneNna1Yw1vJQ==
X-Received: by 2002:a1c:9c4c:: with SMTP id f73mr22280201wme.125.1578934740069;
        Mon, 13 Jan 2020 08:59:00 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id z123sm15838230wme.18.2020.01.13.08.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 08:58:59 -0800 (PST)
Date:   Mon, 13 Jan 2020 17:58:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        valex@mellanox.com
Subject: Re: [PATCH v2 0/3] devlink region trigger support
Message-ID: <20200113165858.GG2131@nanopsycho>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
 <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
 <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
 <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jan 11, 2020 at 02:51:00AM CET, linyunsheng@huawei.com wrote:
>On 2020/1/11 1:52, Jacob Keller wrote:
>> On 1/9/2020 8:10 PM, Yunsheng Lin wrote:
>>> On 2020/1/10 3:33, Jacob Keller wrote:
>>>> This series consists of patches to enable devlink to request a snapshot via
>>>> a new DEVLINK_CMD_REGION_TRIGGER_SNAPSHOT.
>>>>
>>>> A reviewer might notice that the devlink health API already has such support
>>>> for handling a similar case. However, the health API does not make sense in
>>>> cases where the data is not related to an error condition.
>>>
>>> Maybe we need to specify the usecases for the region trigger as suggested by
>>> Jacob.
>>>
>>> For example, the orginal usecase is to expose some set of flash/NVM contents.
>>> But can it be used to dump the register of the bar space? or some binary
>>> table in the hardware to debug some error that is not detected by hw?
>>>
>> 
>> 
>> regions can essentially be used to dump arbitrary addressable content. I
>> think all of the above are great examples.
>> 
>> I have a series of patches to update and convert the devlink
>> documentation, and I do provide some further detail in the new
>> devlink-region.rst file.
>> 
>> Perhaps you could review that and provide suggestions on what would make
>> sense to add there?
>
>For the case of region for mlx4, I am not sure it worths the effort to
>document it, because Jiri has mention that there was plan to convert mlx4 to
>use "devlink health" api for the above case.

It is on the TODO list, yes. For mlx4 usecase the healh reporters are
more suitable.


>
>Also, there is dpipe, health and region api:
>For health and region, they seems similar to me, and the non-essential
>difference is:
>1. health can be used used to dump content of tlv style, and can be triggered
>   by driver automatically or by user manually.
>
>2. region can be used to dump binary content and can be triggered by driver
>   automatically only.
>
>It would be good to merged the above to the same api(perhaps merge the binary
>content dumping of region api to health api), then we can resue the same dump
>ops for both driver and user triggering case.

I was thinking about that as well. Will check it out.

>
>For dpipe, it does not seems flexible enough to dump a table, yes, it provides

Why? That is the purpose of the dpipe, but make the hw
pipeline visible and show you the content of individual nodes.


>better visibility, but I am not sure it worth the effort, also, it would be better
>to share the same table dump ops for driver and user triggering case.
>For hns3 driver, we may have mac, vlan and flow director table that may need to dump
>in both driver and user triggering case to debug some complex issues.
>
>So It would be better to be able to dump table(maybe including binary table), binary
>content and tlv content for a sinle api, I suppose the health api is the one to do
>that? because health api has already supported driver and user triggering case, and
>only need to add the table and binary content dumpping.
>
>
>> 
>> https://lore.kernel.org/netdev/20200109224625.1470433-13-jacob.e.keller@intel.com/
>> 
>> Thanks,
>> Jake
>> 
>> .
>> 
>
