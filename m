Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C891DD584
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgEUSBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbgEUSBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:01:31 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEB1C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 11:01:31 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id ee19so3465823qvb.11
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 11:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9vZVxJ+cF490WZutM85auBlDXMsXHuCjgVpLB9EXIuM=;
        b=MIHPSPA+XWlTZ9Na6EAORhJoIbaMOHqwIUA+uKdRwkvQiMJ/EtWI4BqYesFh7y9Fjk
         ARV5Tnj9X0QLnN2KCArC68N0zER9qOUZpG8YCjGCfgLFQCy11N3xCwkCPg9Aj9/HrNuW
         pJo1aDpZXwfnVc0/uwEHgCZYql7RLTHbAR3JJbwjPPeVz+rjcVDAzoPnahT79fBVH//+
         nqiYcRL3lXT1PxDZFK+WCCUOIkVRtKMfMtOR+qXKrAKTPlWZaSp12iydCb5fhoO27kU1
         ei/aFSIK6JinJ+lK3oIhprZuGsuv/DskqkbrJ2bm69YQ+VxNKMTo/PdbMrElxhDYwwE5
         /+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9vZVxJ+cF490WZutM85auBlDXMsXHuCjgVpLB9EXIuM=;
        b=qkn1x7qM4bfwWXsMXFUd8wfTs5tIwQxKgS76Hri3CAFSjNyvdBaBd6zwLGm2elsHCm
         ADpffgYWsGrf1374xDYXQWkCL+A0LLwqxYOLVFPGsaMi3bbDp4SguSPKlelQUQcIoUiz
         /pOgxOEzaP13EkBYAMpSxe+MMeX0AuJ5ugJJPNpPQ380t3L1EP7FQLkXVqJdT+6UsWBi
         JR2QfABP9KM/xoghZpnnz8ZExKZeIGM3jOx2EH0ZY5SQjJTn2mUp4WmSJW2M4z82YmWS
         XLvqKgWcLYybidOLBA2ynfBOp6YSEAURYZdIbGodKegGi3UCHAkF9xN+ki/RrW0BGvPI
         vwsA==
X-Gm-Message-State: AOAM531JozXk9HL2IElMqp6z464XKPZfhNIrjkuzQEnOlqU0YhpXKuw7
        8YTXpVbxxC3nvsS/YStjSTw=
X-Google-Smtp-Source: ABdhPJyakYEbt65wpbrtYj3AuxQBVGpzVlYkgOLqCu/i3qnJGUZakYZt2+gyTq0wuP4xFIzu3nOT2g==
X-Received: by 2002:a0c:9ad5:: with SMTP id k21mr11310897qvf.2.1590084090299;
        Thu, 21 May 2020 11:01:30 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5123:b8d3:32f1:177b? ([2601:282:803:7700:5123:b8d3:32f1:177b])
        by smtp.googlemail.com with ESMTPSA id x14sm4267283qkb.67.2020.05.21.11.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 11:01:29 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/2] Implement filter terse dump mode
 support
To:     Vlad Buslov <vladbu@mellanox.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, dcaratti@redhat.com
References: <20200514114026.27047-1-vladbu@mellanox.com>
 <20200514132306.29961-1-vladbu@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <acabad7b-2965-e7f6-b1d8-55f6b6f3f033@gmail.com>
Date:   Thu, 21 May 2020 12:01:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514132306.29961-1-vladbu@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 7:23 AM, Vlad Buslov wrote:
> Implement support for terse dump mode which provides only essential
> classifier/action info (handle, stats, cookie, etc.). Use new
> TCA_DUMP_FLAGS_TERSE flag to prevent copying of unnecessary data from
> kernel.
> 

FYI: I am waiting for the discussion on this feature to settle before
applying.
