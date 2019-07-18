Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C70F6D2D6
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfGRRca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:32:30 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40590 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRRc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:32:29 -0400
Received: by mail-io1-f67.google.com with SMTP id h6so52706080iom.7
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8JXoqFTppEs2+CTx6OQY71cp65ktgcez5QM1NfjwySs=;
        b=SqdTUDXconA9aXMDucAlk1OImtLYUtxFAvtlEcpX9rPaZxY1+X45EyuL61RjWDqWlF
         C3hAB4YWziYAnMplG+j06hAxHhpnu3eHpLp9mPjbcHUPg8YUGVV3kB/fiEuKo6MvHCCn
         gR9I/lqYXTIJaAxM/zY6bJrxQeBI4n8uy0hI3c/9vMQupA/w5mMdcjsypZUqedUFjz4B
         c1Pzyk16wOKt4EZfMQ5zYG7/CjEAfpddd3H4PI7a3mh7rHbtzEQetWrfhtqAPIJCB9Xn
         g//0KkCoRNRnLdOkL7RQq97T62dUrBKZ2pWrvJ9Am1EvUvPerKy9VYN7ik/veTY6kUJP
         cqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8JXoqFTppEs2+CTx6OQY71cp65ktgcez5QM1NfjwySs=;
        b=E0lGAxDxpgB++FOKnjgSsULMDcHu1ZtoSWjKH3FR6oadOeZZrOlxnv47jiKMzXFdpm
         LzicrowTHxxTExZPKhEAgF4yH2IvIUTSwGmJThNydPf6WFXJRCy02Dh0uaRyv4FFYaqm
         rp7c38497/4HGNBCoTDtwj4FwrIy3BupnEUpLLofHUYwV+XDXeEELs1ceWMu3kDZaFP/
         ExW/E2A11ymFZ87VxE4o6IQYYORVc3xlTXOr0BZb2+m8mO+yfHrKH431X2esgyxDvQNI
         ZYvbzKeO9APTPzKeWtzwAVrBESlMlsl7WxcmcnW54KbITlfA3W3WslzqAlFpUxQaulp9
         PD7A==
X-Gm-Message-State: APjAAAWRzcBTUQPbTPGlJblooHbRm8SsTeO6DspxF5tFpqsSLbk64EUI
        WadZR+ysydBKs6Hk9wEqMN4=
X-Google-Smtp-Source: APXvYqygTR4izfCUDET4CK2wo1CSBQfASuEXrWRKeWHsZQoo4lvstcIFfyMBZ+iOMh6TXbreX42FPA==
X-Received: by 2002:a6b:8bcb:: with SMTP id n194mr45867891iod.194.1563471148973;
        Thu, 18 Jul 2019 10:32:28 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:d57e:4df9:f3b0:1b7c? ([2601:282:800:fd80:d57e:4df9:f3b0:1b7c])
        by smtp.googlemail.com with ESMTPSA id b3sm22708883iot.23.2019.07.18.10.32.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 10:32:28 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v4 1/6] Update kernel headers
To:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com
References: <1563306789-2908-1-git-send-email-vedang.patel@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f1a94a8c-ca50-f9db-795f-b5077a2d308e@gmail.com>
Date:   Thu, 18 Jul 2019 11:32:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1563306789-2908-1-git-send-email-vedang.patel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/19 1:53 PM, Vedang Patel wrote:
> The type for txtime-delay parameter will change from s32 to u32. So,
> make the corresponding change in the ABI file as well.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>  include/uapi/linux/pkt_sched.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 1f623252abe8..18f185299f47 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -1174,7 +1174,7 @@ enum {
>  	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
>  	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
>  	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
> -	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
> +	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
>  	__TCA_TAPRIO_ATTR_MAX,
>  };
>  
> 

kernel uapi headers are synced from the kernel. You will need to make
this change to the kernel header and it will make its way to iproute2
