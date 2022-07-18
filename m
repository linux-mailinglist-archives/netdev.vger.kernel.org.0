Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003035788CB
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiGRRvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiGRRvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:51:11 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB1A2D1CA
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:51:10 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id t13so345233ilq.12
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jw17XQb4lRD6mBPISIOkt7xhN2aj5+Hz5/GH6VsR7YI=;
        b=SOpQLTl99sO2gPr3W0OTlaktqKXy+EZpmRJdYXHdo2k2WDjsBMST0YPWHw48L1pPLN
         96dDftn55K0BWSCQ+i40O++KpifQc99ZEjdhgKm4Vnub76Bq/YGNsSM84AN5B0nXv3Ff
         JeKwDSowCE770nEeF+ISF3PCedCmrq5c2kg9MliIyf4ZoyjY9VGFrHPJ/OuuPS4W4a4c
         xmLfMUPm1rcp3v01ShZdZBpM/KDSdjK8T1iP+XFcKQ2B/+h9UFlyU0Xjur4xS22LeA7L
         1/HHHswYMfsoXbqXccpJjuaAczUQWHbag+Qekh0LMStQ5r1jWe2YJ99AU6R9/QxedLxN
         +lJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jw17XQb4lRD6mBPISIOkt7xhN2aj5+Hz5/GH6VsR7YI=;
        b=tez25/KqF6HLjPy71BJWg15bdPq3v4Y/Xh7QokO/rwiE7NUbG07BZNqUQM/1Pvxn4o
         8doKnOEWX03n48m22RA7+SEOrgBguQPoPRq2a9nWCclA69NwhTTvOMS8Ma9vZ2IEk2bH
         QaR/BIl6AQ4qN5zGA3CZkUQIN9yLWd8qD8r8qg+Tqzs8/kM0CY+WXrYkSQHXVyt+37kP
         XiRy6SvIACJCTOW7YrYqKad6LL8SQpjHrWplCSgZ+F+fWnPBStvzOIbMv4vhLjMf64Vv
         oNdfgTD+RyngMzGlZAJE3Nf0xEujAaUrpGoyE+58a7NTQ9kKBfaqvg3XoBOTw6rXRH/+
         L6tw==
X-Gm-Message-State: AJIora//2uEUEZ/Y7FOzqh+D3cBOwULYPiiTy3v2Mgjdt34iiKGU18df
        zoNoQpUpzV3vHwnVVJqdpR95zpv74NQ=
X-Google-Smtp-Source: AGRyM1t/hls5uM3NFG/DAr3IETvVQ100SsFVipqdXN79N3gSMCX8lFYdrOAn9n2o142PNxh7hnr76Q==
X-Received: by 2002:a05:6e02:1a25:b0:2dc:743c:864a with SMTP id g5-20020a056e021a2500b002dc743c864amr14291812ile.248.1658166670010;
        Mon, 18 Jul 2022 10:51:10 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:a884:659b:a795:3b16? ([2601:282:800:dc80:a884:659b:a795:3b16])
        by smtp.googlemail.com with ESMTPSA id m26-20020a6bea1a000000b0067b75781af9sm6367823ioc.37.2022.07.18.10.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 10:51:09 -0700 (PDT)
Message-ID: <97faec92-f2d0-ab5e-4fdd-bfd2e2e911e8@gmail.com>
Date:   Mon, 18 Jul 2022 11:51:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH iproute2] uapi: add vdpa.h
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Parav Pandit <parav@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220718163112.11023-1-stephen@networkplumber.org>
 <PH0PR12MB5481AAD7096EA95956ED6801DC8C9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220718095515.0bdb8586@hermes.local>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220718095515.0bdb8586@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/22 10:55 AM, Stephen Hemminger wrote:
> On Mon, 18 Jul 2022 16:40:30 +0000
> Parav Pandit <parav@nvidia.com> wrote:
> 
>> We kept this in vdpa/include/uapi/linux/vdpa.h after inputs from David.
>> This is because vdpa was following rdma style sync with the kernel headers.
>> Rdma subsystem kernel header is in rdma/include/uapi/rdma/rdma_netlink.h.
>>
>> Any reason to take different route for vdpa?
>> If so, duplicate file from vdpa/include/uapi/linux/vdpa.h should be removed.
>> So that there is only one vdpa.h file.
>>
>> If so, should we move rdma files also similarly?
>>
>> Similar discussion came up in the past. (don't have ready reference to the discussion).
>> And David's input was to keep the way it is like rdma.
> 
> RDMA is different and contained to one directory.
> VDPA is picking up things from linux/.
> And the current version is not kept up to date with kernel headers.
> Fixing that now.

Updates to vdpa.h do not go through net-next so moving it to
include/uapi/linux can cause problems when trying to sync headers to
net-next commits. That's why it was put under vpda, similar to the rdma
model.
