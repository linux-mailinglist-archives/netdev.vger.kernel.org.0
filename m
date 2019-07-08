Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B4D62C46
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbfGHW5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:57:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43998 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbfGHW5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:57:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so8402733pgv.10
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 15:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=7S1vDqGd7591lkFEFB7OW5jJmpakVNdWy7knvF0FJNw=;
        b=kyMVTRsRx8jujqxPN9o5T17ijCne31EA9FEel7vAlxEpczyh+rfo/9mHCk23d/c1d1
         QPwDCF6oa5yVi/c9GUMcYJZ+xYc9vm4Rfdcwg+Od4uSe0Bgu1x4CNg4wh1JCh/bkDzwR
         aQdqNs6Z46Cz/Bq3qTfoRrrQIeNzaaE8RY24kbwfyH2W3MvvCCZY+ww6bXEBce2Vz1dF
         427x0+T6syLA6H9Hs/EjOQdCHrvvG6af94adQflWp+4le28gmz1thSFIX5L4kuMCDQLX
         hK5kknmXz6JuYyX0/yJcBmdLw8GWqWQiWcg1oaGxRNTYd1HA/6BKYWH9kExG/ZyLVCOH
         PsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7S1vDqGd7591lkFEFB7OW5jJmpakVNdWy7knvF0FJNw=;
        b=t94q9AsT4zHjKEib4ly2MzbsGqQfjp6TF5L26mRNFu9DYGkpf4D0kdt7doI75VlaOg
         fhRT4Yu4o7i5lVKIQnSc28167f6ZrHby2VSZOp5IAljBBdmyIiCT4vvrOhn4541qNBYI
         9XpohTFYFs1bWw+F46jskQOEZAb0Xm/p1oG9IsNX/qjs889v4ZdfO+/0Aonl0BGRcJ17
         Y+oEoJP4qp/ubAQEq/3weAG/ImX06xrCmX7zusy5CLwVVSSxZiKOJrh173m2qG53tU8z
         RDgMQ61XDlAJMpypqkX8S50+TVZwdfb+C/k7D/asWf29a0NQyfF4Q8CY5O0i44YIOOue
         IHdw==
X-Gm-Message-State: APjAAAXmivIyoXoiytYG4lA6Qv9XI3xhsvJ2LsGbH9O0L1qjsxVo4+uH
        4e492DA4VhOEUGTOEFh+TF6gTf7FYWY=
X-Google-Smtp-Source: APXvYqz5vQxL6aR448lGSy+TpPgZDPmdnzIUWBROLeA1SNlhkX76eXo/mpM5Qg05sC7BVIV28oQ57A==
X-Received: by 2002:a65:5344:: with SMTP id w4mr26929407pgr.326.1562626624674;
        Mon, 08 Jul 2019 15:57:04 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id g9sm15367276pgs.78.2019.07.08.15.57.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 15:57:04 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 19/19] ionic: Add basic devlink interface
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-20-snelson@pensando.io>
 <20190708193454.GF2282@nanopsycho.orion>
 <af206309-514d-9619-1455-efc93af8431e@pensando.io>
 <20190708200350.GG2282@nanopsycho.orion>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <6f9ebbca-4f13-b046-477c-678489e6ffbf@pensando.io>
Date:   Mon, 8 Jul 2019 15:58:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190708200350.GG2282@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 1:03 PM, Jiri Pirko wrote:
> Mon, Jul 08, 2019 at 09:58:09PM CEST, snelson@pensando.io wrote:
>> On 7/8/19 12:34 PM, Jiri Pirko wrote:
>>> Mon, Jul 08, 2019 at 09:25:32PM CEST, snelson@pensando.io wrote:
>>>>
>>>> +
>>>> +static const struct devlink_ops ionic_dl_ops = {
>>>> +	.info_get	= ionic_dl_info_get,
>>>> +};
>>>> +
>>>> +int ionic_devlink_register(struct ionic *ionic)
>>>> +{
>>>> +	struct devlink *dl;
>>>> +	struct ionic **ip;
>>>> +	int err;
>>>> +
>>>> +	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic *));
>>> Oups. Something is wrong with your flow. The devlink alloc is allocating
>>> the structure that holds private data (per-device data) for you. This is
>>> misuse :/
>>>
>>> You are missing one parent device struct apparently.
>>>
>>> Oh, I think I see something like it. The unused "struct ionic_devlink".
>> If I'm not mistaken, the alloc is only allocating enough for a pointer, not
>> the whole per device struct, and a few lines down from here the pointer to
>> the new devlink struct is assigned to ionic->dl.  This was based on what I
>> found in the qed driver's qed_devlink_register(), and it all seems to work.
> I'm not saying your code won't work. What I say is that you should have
> a struct for device that would be allocated by devlink_alloc()

Is there a particular reason why?  I appreciate that devlink_alloc() can 
give you this device specific space, just as alloc_etherdev_mq() can, 
but is there a specific reason why this should be used instead of 
setting up simply a pointer to a space that has already been allocated?  
There are several drivers that are using it the way I've setup here, 
which happened to be the first examples I followed - are they doing 
something different that makes this valid for them?

>
> The ionic struct should be associated with devlink_port. That you are
> missing too.

We don't support any of devlink_port features at this point, just the 
simple device information.

sln

>
>
>> That unused struct ionic_devlink does need to go away, it was superfluous
>> after working out a better typecast off of devlink_priv().
>>
>> I'll remove the unused struct ionic_devlink, but I think the rest is okay.
>>
>> sln
>>
>>>
>>>> +	if (!dl) {
>>>> +		dev_warn(ionic->dev, "devlink_alloc failed");
>>>> +		return -ENOMEM;
>>>> +	}
>>>> +
>>>> +	ip = (struct ionic **)devlink_priv(dl);
>>>> +	*ip = ionic;
>>>> +	ionic->dl = dl;
>>>> +
>>>> +	err = devlink_register(dl, ionic->dev);
>>>> +	if (err) {
>>>> +		dev_warn(ionic->dev, "devlink_register failed: %d\n", err);
>>>> +		goto err_dl_free;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +
>>>> +err_dl_free:
>>>> +	ionic->dl = NULL;
>>>> +	devlink_free(dl);
>>>> +	return err;
>>>> +}
>>>> +
>>>> +void ionic_devlink_unregister(struct ionic *ionic)
>>>> +{
>>>> +	if (!ionic->dl)
>>>> +		return;
>>>> +
>>>> +	devlink_unregister(ionic->dl);
>>>> +	devlink_free(ionic->dl);
>>>> +}
>>>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
>>>> new file mode 100644
>>>> index 000000000000..35528884e29f
>>>> --- /dev/null
>>>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
>>>> @@ -0,0 +1,12 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>>>> +
>>>> +#ifndef _IONIC_DEVLINK_H_
>>>> +#define _IONIC_DEVLINK_H_
>>>> +
>>>> +#include <net/devlink.h>
>>>> +
>>>> +int ionic_devlink_register(struct ionic *ionic);
>>>> +void ionic_devlink_unregister(struct ionic *ionic);
>>>> +
>>>> +#endif /* _IONIC_DEVLINK_H_ */
>>>> -- 
>>>> 2.17.1
>>>>

