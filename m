Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61644778D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 03:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfFQBQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 21:16:28 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34318 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbfFQBQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 21:16:28 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so17762328iot.1
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 18:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WLvmVQKW1sv4eimqil+rwNRi2rp38JDZFy6G1av+xN4=;
        b=REhMQz3GqzavB2Js5685xoaXecWs52EbvTKMv5LtmhNBgRQot7ykQs4BYoAXAw14vS
         vLwmTme990w2YYI3iQCltIuvCOZM9DITVdmgDcd60P+LtAfK/7gSqI4SijSeisutrEXu
         a0F277fd1zPdVBqUxATHLdjfb40VkRpoHQQvFKNnWM4h6h97SgaOFAIFeCGhV9ZVOKik
         rgDCnsADlesHE+iXjWFsMXLfgDdVqZeaJgUB4914PgEpqwA59AJ1iGJUw7qvWlcBJbBC
         dW4diZ2LEA1Iidw9AyAt1F1HNX/2h7lkAWhzpo/EmzCkfOXChF5P+6hZKq7w5My+GXwK
         VyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WLvmVQKW1sv4eimqil+rwNRi2rp38JDZFy6G1av+xN4=;
        b=Q9qWh9konVP0r6HVZWigw7XRj/sYB42HOlrh2D2N0dPSgi5zsxjkzSOm8Muzk9JsDO
         7ANRuG+GUxX8BHSshy3+xZrWFNQF4yzaJkRb3ho+k4k/9xFbOI0F3bbhVJgDBylfRU8N
         g8QvUeZFfPb84sL/NK+6spvGsn1Wf4sqZpzbTlb19dEkqxHyVw95BHUO+yvrqU6jCOam
         Jqhoq0TPLtcrtSZelvZtT8lseOk3AX8F1XO92/rTl1Kr/ZEYKvV0bUsM3rfckxxUgkad
         C6xboyPo2DNmLhKs++p4umoJnRi5b+Ra7VL6HPJvZEjpwSUl/OC0sN7nFkhigj9aAa+F
         dDPg==
X-Gm-Message-State: APjAAAVyfQdnHW9MvfDb6kAAUCjXn9OxnzzNNvAuYPsZVoinhVwVFISj
        Aji7zqDSUnyBq695mZ7zgqI=
X-Google-Smtp-Source: APXvYqwxQOBb4FMCDgwFqn6tkWGFq2gko4+r6wcYA/xcKcOxCtZpn2bcjaUDkkgCkjOASnjU1F472Q==
X-Received: by 2002:a6b:f00c:: with SMTP id w12mr10498208ioc.280.1560734187855;
        Sun, 16 Jun 2019 18:16:27 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:e47c:7f99:12d2:ca2e? ([2601:282:800:fd80:e47c:7f99:12d2:ca2e])
        by smtp.googlemail.com with ESMTPSA id l5sm8587741ioq.83.2019.06.16.18.16.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 18:16:26 -0700 (PDT)
Subject: Re: [PATCH net-next 01/17] netlink: Document all fields of 'struct
 nl_info'
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexpe@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190615140751.17661-1-idosch@idosch.org>
 <20190615140751.17661-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a6ec9a20-b057-10f7-cd1d-0a77471c0e2a@gmail.com>
Date:   Sun, 16 Jun 2019 19:16:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190615140751.17661-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/19 8:07 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Some fields were not documented. Add documentation.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/netlink.h | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


