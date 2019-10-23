Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA5E1BAC
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 15:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405550AbfJWNDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 09:03:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33951 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732149AbfJWNDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 09:03:02 -0400
Received: by mail-io1-f65.google.com with SMTP id q1so24839174ion.1
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 06:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yIG57v5PzkLvwfJfOB4/wIMBj1bzzHVdhCd3VHTosI0=;
        b=gQlrlJraI6bWVhA34LTAa0ibKUyhpf0wHi2jz9U8qSWoZ7hRtNNQogf9BHmcEsg2BP
         ZJBDA+JuEXoaXlqK9Vu8FCzvVfCiMT4UZbv9RGJP/TgQvjtyqGDljFBUCrZivAOlpKeT
         zMmFt6vgv+Yyqtste1V7J6drZDC89CtMYYITiQriyitXBsYhkg2ZNM4s4L5N/rR0X70i
         8Xm343UoktpZ6PtuAYNb9pbRc7EU+6S9khqI9jbPrqWaeC1P7Rq6lRmYxferJsE/Gl2G
         FrMSE1/S4iYvBbdudBeTeEjRW4qgxNfb7woCbglJjTTES3DF+an+ZkZpdoZdne7z2VDB
         v+fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yIG57v5PzkLvwfJfOB4/wIMBj1bzzHVdhCd3VHTosI0=;
        b=pWMd6oiQ8psPBmdnq9tFx4UIZonV0ia2bnG4NG7PVj7XD478iSShPzh4942ZqExZJp
         tNWMgE/w35vYwPDfIKCPXGWl8Poq6txI0S/N/vmZt/uqUIcL4Br0PeYjQDcxE7cAMqWG
         0U/3zXdHKVunOt6ygtdzObFP8XsUDVC3N4d8yLVAl8ryAi+8Ao9OZx18JKn+RaTYm8D4
         eJYOJVRSVNYmIin8FsSYW+fEvmqDBQTfLKDIgKju3pzUS3lFlEXMDtFezeKQR8H8dbnK
         RbjXibR9/D916rIFsW7WHEuG1goTCr2rP/q8EAvP2LNvvcvscBeyJ9e5nN2CWjj865vk
         4NuA==
X-Gm-Message-State: APjAAAWm//IrJo0EmDwiEnAZNJ93uwG4aOtKj0R0aU4SRXzhqgYAHihT
        7P7miJRRFNXVNbsJ7TbWOmSLAQ==
X-Google-Smtp-Source: APXvYqwr42UTqpSNSi5PJeo8wK/+3BbLLinGdhEUuo3WpNwBWTi0mMfKPRdhTU+/oEqBVaksFyCrmw==
X-Received: by 2002:a5d:8d8f:: with SMTP id b15mr3179460ioj.296.1571835781786;
        Wed, 23 Oct 2019 06:03:01 -0700 (PDT)
Received: from [192.168.0.124] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id t68sm3841507ilb.66.2019.10.23.06.02.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 06:03:00 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>, Roman Mashak <mrv@mojatatu.com>
Cc:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191022143539.GY4321@localhost.localdomain> <vbfmudsx26l.fsf@mellanox.com>
 <85imog63xb.fsf@mojatatu.com> <vbfk18wvued.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <1cd8ce66-cb27-b9e8-c8a6-da63c8226aae@mojatatu.com>
Date:   Wed, 23 Oct 2019 09:02:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbfk18wvued.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I shouldve read the thread backward. My earlier email was asking
similar question to Roman.

On 2019-10-23 2:38 a.m., Vlad Buslov wrote:
> 
> On Tue 22 Oct 2019 at 21:17, Roman Mashak <mrv@mojatatu.com> wrote:

> Hi Roman,
> 
> I considered it, but didn't find good way to implement my change with
> TCA_ROOT_FLAGS. I needed some flags to be per-action for following
> reasons:
> 
> 1. Not all actions support the flag (only implemented for hw offloaded
>     actions).
> 
 >
> 2. TCA_ROOT_FLAGS is act API specific and I need this to work when
>     actions are created when actions are created with filters through cls
>     API. I guess I could have changed tcf_action_init_1() to require
>     having TCA_ROOT_FLAGS before actions attribute and then pass obtained
>     value to act_ops->init() as additional argument, but it sounds more
>     complex and ugly.

I really shouldve read the thread backwards;->
The question is if this uglier than introducing a new TLV for every
action.

cheers,
jamal
