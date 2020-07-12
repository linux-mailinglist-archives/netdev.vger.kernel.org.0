Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B6221CBC9
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgGLWT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgGLWTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:19:25 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12C1C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:19:25 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ls15so5161888pjb.1
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r7029CLSUMBvbw/E+1xQ0gHJH5oE4Itb6pE0lOBMwdA=;
        b=hXGbG6RBdPpiL7eULUHb+mhjB+gBcQZLp3R+iCIiSkJEvkfW+9wjjvXryPzYscOF8l
         2K72klE2jGHrgISc+ZgP67BILrzO+b2KjkqaFz5F4MUydKkpGcMH7s7SaMtjNSCk8r6i
         dKcvvEvb2zV8yKCN/C0E/zwGO+fpbLczctmkatJGZJt9Ue+EPgJf6WHut/kI3F5zjsM2
         kDo4g4Tizaa4HlPQj7AjEXicRKQUqv1WWp0fq4dJDq7WnGOfJ4AORLfPaVpkiEkHdFdy
         9OtbQnAf4srx+rpBgjT15g3O0RhTmrMnO/Pp53jRlNoFSn/WSe0aF6wT3Y0ANUQBufPa
         F8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r7029CLSUMBvbw/E+1xQ0gHJH5oE4Itb6pE0lOBMwdA=;
        b=A0RJjVw/by7xcbZeB9d/ZPCTcB1BiHQn7uQIFNBuYwVl5jcyjUiolkhAPKwn5UYWXc
         dv9vQ47XW9YzTq8jhufbfPKkk2vxeG9ElmvQTS317YkaAiNaInF6kYwfKMbdVUaLF3sQ
         jZMnguehfxKAxkwVsZRgOJEfTw4YJUXbnq8maBXk3Df3hvBmMiL3likJDef9DLQjdwHY
         pYGSnAhMsHTSfPPtw3PI2pdekzAzFgRoD3hqUKSe9Ma8roR8Une0koXXtsJN3qjsHpnZ
         zXpwsojU9o9ORbYZa2kUqsoyNfDODPOQKsWkyX4soRJ+Yu05mkTXYQYp9jBJl6jnW4ZZ
         l2HA==
X-Gm-Message-State: AOAM530hqzlXgEFEra1UvoWiyN4BgGL6/d0C7DvltmDurrcxb0fSchpx
        e8xpS8uBXzEvx2uWNcrDFms=
X-Google-Smtp-Source: ABdhPJyNClKVOYtnckI9xqJ4QY2B5AOFfpgDRUjuxmhkT7iLbU56o4a3HshWKahW9UhF/FqwbiBETA==
X-Received: by 2002:a17:90a:39c8:: with SMTP id k8mr17447856pjf.118.1594592365211;
        Sun, 12 Jul 2020 15:19:25 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:1ce9:950e:b133:e5d? ([2001:470:67:5b9:1ce9:950e:b133:e5d])
        by smtp.gmail.com with ESMTPSA id q13sm13176481pjc.21.2020.07.12.15.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 15:19:24 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: treewide: Convert to netdev_ops_equal()
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, mkubecek@suse.cz,
        kuba@kernel.org, davem@davemloft.net
References: <20200712221625.287763-1-f.fainelli@gmail.com>
 <20200712221625.287763-4-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8dfd5aa8-a765-defa-0c20-abdb2e78a3e0@gmail.com>
Date:   Sun, 12 Jul 2020 15:19:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200712221625.287763-4-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/2020 3:16 PM, Florian Fainelli wrote:
> In order to support overloading of netdev_ops which can be done by
> specific subsystems such as DSA, utilize netdev_ops_equal() which allows
> a network driver implementing a ndo_equal operation to still qualify
> whether a net_device::netdev_ops is equal or not to its own.
> 
> Mechanical conversion done by spatch with the following SmPL patch:
> 
>     @@
>     struct net_device *n;
>     const struct net_device_ops o;
>     identifier netdev_ops;
>     @@
> 
>     - n->netdev_ops != &o
>     + !netdev_ops_equal(n, &o)
> 
>     @@
>     struct net_device *n;
>     const struct net_device_ops o;
>     identifier netdev_ops;
>     @@
> 
>     - n->netdev_ops == &o
>     + netdev_ops_equal(n, &o)
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

I will be waiting for feedback before spinning a v2, but the changes to
net/openvswitch are no longer necessary and should instead using
__netdev_ops_equal(), sorry for missing that before sending.
-- 
Florian
