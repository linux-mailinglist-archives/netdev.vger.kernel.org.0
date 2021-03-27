Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07E834B913
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 20:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhC0TPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 15:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhC0TPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 15:15:04 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29117C0613B1
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 12:15:03 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so8447398otk.5
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 12:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jc4z1qo4iWP85fvzvmeqDdmKX7W0PYbUW5Yb0p33gpc=;
        b=mJZzTVXUs8MJlGAjWCHqe0nmgVe1GSrjTQLeBBUqgTbWixuXzRm5Nj5PCbpxPPieGd
         DooXggWESsBcGUIdRkV6MrthrE+lINdE71wtGU4AVF2+fb2a85ex8F1xUMHXItJKEJq0
         TU96Un4rCJqP477ssH1Y1iUr2kKOrGwPql2wMYwR1fpBhyIcvM7bgcUSnDphBjk9mHIU
         cCvKnA0PCrAFaHig1f9ryZmCSJnP44++F2tyyiBK5hNCj21XP6V7KUVoArkiGhd/vcP2
         zpNBJaGoyCoqk6YsXzZ8e50pwUuUe3Kk/K5CXXmLCWft79ZqlvsEAnbZXZxonHaHTtPk
         C6Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jc4z1qo4iWP85fvzvmeqDdmKX7W0PYbUW5Yb0p33gpc=;
        b=du1VhOfdSDOZSQEzhMPR0lmoAeXC/5dHf6oKAEJVANdihTw+zc5KEla9n4V7tGTThs
         hxKmAFujIJH+RuuWSkbciSuiGvh15JsUaCOx/ExdBLE2Gam6nF5uooGTiOYrkADaB+ds
         SJqoE/YFnf4DUaPyrbZ1OQOyh4KfgTBw72Xge41I3wTcPjcXGywnDlvPSPAKhoJQj6y6
         FOgignEnyeqqXXdWbvlkliRblFP8MJBUG1tRTDQzE5KhV023VFQUzVSZOmncpzG03SW4
         W6SKbu8eO9YlGqsdi99vVOiplpflOdfRuyNzgusITVgqHZpTyh1K8bR8Do4j6/gCBS4i
         2Jrg==
X-Gm-Message-State: AOAM531qUrFGwbTz0Yxc0SU0RkZghiyXSdax6uI/+kr2Y6EeUYjxccs2
        yDd+0KpgQ2qnBwwhjKsQlHQ0nFB1YHo=
X-Google-Smtp-Source: ABdhPJy3KdeNAca3OTwC3xPZePMFQDXeJD1HwWM9j/mjaXqUsEusDaFZoLdSZcblEntSTHW7CN6q1w==
X-Received: by 2002:a05:6830:1ad1:: with SMTP id r17mr16729789otc.171.1616872502541;
        Sat, 27 Mar 2021 12:15:02 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id c7sm2692663oot.42.2021.03.27.12.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Mar 2021 12:15:02 -0700 (PDT)
Subject: Re: [PATCH 1/9] l3mdev: Correct function names in the kerneldoc
 comments
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>, dsahern@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
References: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
 <20210327081556.113140-2-wangxiongfeng2@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1e4e2292-ba8c-c179-ebc3-5965ca1ff5f6@gmail.com>
Date:   Sat, 27 Mar 2021 13:15:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210327081556.113140-2-wangxiongfeng2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/21 2:15 AM, Xiongfeng Wang wrote:
> Fix the following W=1 kernel build warning(s):
> 
>  net/l3mdev/l3mdev.c:111: warning: expecting prototype for l3mdev_master_ifindex(). Prototype was for l3mdev_master_ifindex_rcu() instead
>  net/l3mdev/l3mdev.c:145: warning: expecting prototype for l3mdev_master_upper_ifindex_by_index(). Prototype was for l3mdev_master_upper_ifindex_by_index_rcu() instead
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> ---
>  net/l3mdev/l3mdev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

