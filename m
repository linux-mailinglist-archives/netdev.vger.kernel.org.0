Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8903A78C69
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388004AbfG2NNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:13:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51361 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbfG2NNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 09:13:15 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so53825525wma.1
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 06:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ZZ45nxiaVjEk7JgCMUXp24s/n4BbgR7GnfNG+kKh8jg=;
        b=yh8wyI5j4Zz9DQeqsR3B/okT6oP+LG2w0JGkSqbuqyEgLvQ5ro4ZQeW4QZPA5bmdrL
         7vJTEicqCqFySLXiohm1Qk6jRLmoFZyh6baU93FmfykWOWoF25G2FhCP0pEW9v8DINZy
         2koomyD4uAF526yFMlMvNaSO+GfwomgaTmoat2ks5UU4KPtb/NjXqHYfnjc/ch112GC/
         swBZ3cEJ03rd/94ZQ/boyhziPIJi8O2TBZjLuF1f4kD//ODNCFOusTFS8onyt+Ub/ZWF
         Ui9CWAQVRtRUbUPK0Y/o/+jPb9VbpYP9C783SLLUqYceAr33dh/5CYKI6x7eFMTIz00X
         bEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ZZ45nxiaVjEk7JgCMUXp24s/n4BbgR7GnfNG+kKh8jg=;
        b=IYBsJLTlUhHDsRtuom22LVAPo+CbpB+keMvidNMsADfl79iDW5PnrGcapjCq7ocjpO
         qZreEhMMhoyqemLNruMvtxglTfud6C+FAui0uVjx15Mncb7pZsNByYivIpJrYV26w5Jt
         K/gdfz3sl/Lntixl9YTf2cuVeivTO7IZHrji0PauIWFUaDwJymG5FqrMLYQHj/3hLpwW
         f/PYaHn7HWvETtE+SKyJrITakpPJQ+EfH51zfdyc+fE4dEWIsIQLREW2avboHsRc3Oxf
         OjPNAjWn+8gdisq9q/S/ywy4aNHHo402gHGZFZzUyMQahiIdOHqofwCxuT17ou9WMY4z
         5M0w==
X-Gm-Message-State: APjAAAVzRPRddvfESZjzfiF4rLXS7BXZ5clczJNI7O12Wk8GeQ1QFJea
        nDhyBgP8Sg1FHdecOxbW7K0YUk6z
X-Google-Smtp-Source: APXvYqytPWUPV2A76r8vrMseRXby2a4HRYNvlGuPq0rLHiH2LjYopS4kAqpBwTMyQl/al3k6OsXTcw==
X-Received: by 2002:a1c:9813:: with SMTP id a19mr97039712wme.11.1564405993547;
        Mon, 29 Jul 2019 06:13:13 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id j17sm101898502wrb.35.2019.07.29.06.13.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 06:13:13 -0700 (PDT)
Date:   Mon, 29 Jul 2019 15:13:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     wenxu <wenxu@ucloud.cn>
Cc:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/3] flow_offload: move tc indirect block to
 flow offload
Message-ID: <20190729131310.GG2211@nanopsycho>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
 <1564296769-32294-2-git-send-email-wenxu@ucloud.cn>
 <20190729111350.GE2211@nanopsycho>
 <c218d9bb-1da7-2ed6-d5b0-afddbe3d0bd7@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c218d9bb-1da7-2ed6-d5b0-afddbe3d0bd7@ucloud.cn>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 29, 2019 at 02:47:07PM CEST, wenxu@ucloud.cn wrote:
>
>在 2019/7/29 19:13, Jiri Pirko 写道:
>> Sun, Jul 28, 2019 at 08:52:47AM CEST, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> move tc indirect block to flow_offload and rename
>>> it to flow indirect block.The nf_tables can use the
>>> indr block architecture.
>>>
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>> ---
>>> v3: subsys_initcall for init_flow_indr_rhashtable
>>> v4: no change
>>>
>> [...]
>>
>>
>>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>>> index 00b9aab..66f89bc 100644
>>> --- a/include/net/flow_offload.h
>>> +++ b/include/net/flow_offload.h
>>> @@ -4,6 +4,7 @@
>>> #include <linux/kernel.h>
>>> #include <linux/list.h>
>>> #include <net/flow_dissector.h>
>>> +#include <linux/rhashtable.h>
>>>
>>> struct flow_match {
>>> 	struct flow_dissector	*dissector;
>>> @@ -366,4 +367,42 @@ static inline void flow_block_init(struct flow_block *flow_block)
>>> 	INIT_LIST_HEAD(&flow_block->cb_list);
>>> }
>>>
>>> +typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
>>> +				      enum tc_setup_type type, void *type_data);
>>> +
>>> +struct flow_indr_block_cb {
>>> +	struct list_head list;
>>> +	void *cb_priv;
>>> +	flow_indr_block_bind_cb_t *cb;
>>> +	void *cb_ident;
>>> +};
>> I don't understand why are you pushing this struct out of the c file to
>> the header. Please don't.
>>
>>
>>> +
>>> +typedef void flow_indr_block_ing_cmd_t(struct net_device *dev,
>>> +				       struct flow_block *flow_block,
>>> +				       struct flow_indr_block_cb *indr_block_cb,
>>> +				       enum flow_block_command command);
>>> +
>>> +struct flow_indr_block_dev {
>>> +	struct rhash_head ht_node;
>>> +	struct net_device *dev;
>>> +	unsigned int refcnt;
>>> +	struct list_head cb_list;
>>> +	flow_indr_block_ing_cmd_t *ing_cmd_cb;
>>> +	struct flow_block *flow_block;
>> I don't understand why are you pushing this struct out of the c file to
>> the header. Please don't.
>
>the flow_indr_block_dev and indr_block_cb in the h file used for the function

You don't need it, same as before. Please don't expose this struct.


>
>tc_indr_block_ing_cmd in cls_api.c
>
>>> -static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
>>> -				  struct tc_indr_block_cb *indr_block_cb,
>>> +static void tc_indr_block_ing_cmd(struct net_device *dev,
>> I don't understand why you change struct tc_indr_block_dev * to
>> struct net_device * here. If you want to do that, please do that in a
>> separate patch, not it this one where only "the move" should happen.


Did you see the rest of my comments???



>>
