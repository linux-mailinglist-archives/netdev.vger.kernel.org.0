Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46485DB12D
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407746AbfJQPe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:34:59 -0400
Received: from mail-vk1-f173.google.com ([209.85.221.173]:44723 "EHLO
        mail-vk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388925AbfJQPe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:34:58 -0400
Received: by mail-vk1-f173.google.com with SMTP id j21so617186vki.11
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 08:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/uWMVj+spbXUZUMop9Ep+QcGUZoe5+DO9KJnNonCv58=;
        b=scpQthtE2XcRwDaoz2tNHSAtZY+jcIG9oZB3b3rm3gTT/6vw9i2VckQnRnMB4YdHV2
         qaItTuPk7YqfQOOY+UTxptVM055ZliEk1CQuccJNEGkmXCzk0PoFdLSSt6m5trt+Renr
         BUUuaUl+K5hHzIjlpLpXR2BX6fdoeBAov+ozXiDY8D0FZzRaPz5BuiY+/YOfNVCyMHGg
         56Hkal9cHUhb5Kks/raaWP86KkbRL62k8pereQL5ky/0OwQvxX8FZTtFE9TcJlxzWSQj
         OLLdw0nZVz7CMXzqKZcZWMKMrxEjFfqF5uOY7/aTymp4dzgNZLaTD2jsS97x8+wmw/WJ
         LYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/uWMVj+spbXUZUMop9Ep+QcGUZoe5+DO9KJnNonCv58=;
        b=p3KsGWA+8JtkGa7WVzo/8DTOGZr33R3dPg4zbzYEg4+8VRTZrY6wooRsmB+SdZ9ZjN
         hGhuE8MNUw7uqIyYDQSKPfzKoC2+RcubvkfnUDYmhKtz7wnOwqGFu+GP9ftMKisV3V7X
         3SQ4AJGxPa2B6I2VUM04b9w8vf7uw4atNDL3jnfFV0g01lZfyVsN1W+Qi1MUCIYGWWMO
         nBDrfF4HLP7gEKtfQghxOzEu2VVkwzLyoVMWU8pwIwZCdSbz804AemV8jnsbLbvrurC5
         MLpmqDKjyLojEW6BmruUnWNzQtB35roSWGOMVXzDXdPyWBt9VGjVeukcTzwXkisorZlA
         deEA==
X-Gm-Message-State: APjAAAUFWY5NvHa1RGu2a+vs/zSTl1+QDLlb0oJGr5Z7RXLrC/6gm9M0
        MvKg0X1TY1XqEts6JiPxa8s=
X-Google-Smtp-Source: APXvYqxzjdtq8o0FGQJHZJGsAZsuL4zIWlRO1+YrcfbLkd6V/lu3c50CzJHerq1ggJtkMxgSh0mlwA==
X-Received: by 2002:a1f:9e04:: with SMTP id h4mr2327652vke.83.1571326497283;
        Thu, 17 Oct 2019 08:34:57 -0700 (PDT)
Received: from dahern-DO-MB.local ([199.231.175.194])
        by smtp.googlemail.com with ESMTPSA id a4sm512214vsp.12.2019.10.17.08.34.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 08:34:55 -0700 (PDT)
Subject: Re: [patch iproute2-next v3 2/2] ip: allow to use alternative names
 as handle
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
References: <20191009124947.27175-1-jiri@resnulli.us>
 <20191009124947.27175-3-jiri@resnulli.us>
 <f0693559-1ba2-ea6c-a36a-ef9146e1ba9b@gmail.com>
 <20191016112858.GA2184@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4ed31257-a1d1-23a3-827e-9dc1ec81ff26@gmail.com>
Date:   Thu, 17 Oct 2019 11:34:54 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016112858.GA2184@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/19 7:28 AM, Jiri Pirko wrote:
> Tue, Oct 15, 2019 at 08:34:56PM CEST, dsahern@gmail.com wrote:
>> On 10/9/19 8:49 AM, Jiri Pirko wrote:
>>> From: Jiri Pirko <jiri@mellanox.com>
>>>
>>> Extend ll_name_to_index() to get the index of a netdevice using
>>> alternative interface name. Allow alternative long names to pass checks
>>> in couple of ip link/addr commands.
>>
>> you don't add altnames to the name_hash, so the lookup can not find a
>> match based on altname.
> 
> you are right, it is always going to fall back to ll_link_get(). I will
> do another patch to add the altnames to name_hash. It can go in
> separatelly or I can add that to this patchset. Up to you.

this patch claims to do the lookup, so it should actually be able to do
a lookup.
