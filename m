Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCB3348755
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 04:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhCYDIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 23:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhCYDHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 23:07:46 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE7EC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 20:07:45 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id d12so666414oiw.12
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 20:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=F6Gq7ub5CHHz5oZQUrfFZDXZwcJC7EfUjmiAYCq2Jfs=;
        b=k4xBY/yExPTqNovfOuiZLHcAwwchB7lFnEZiF9XZTkngVxNKHdyy1T1sz7XWRv+GfL
         bxJBTbjYBZQTxuFbw7g01KhXMvFqtw1sMDrnYp+blls0P8O7oi/L7DqBarwXJlhNOAz1
         m94aeJRNG0BTeXH2lQNOIuUP+yuYpUy9o6RPiInrb0t51+fZ8U2t4g4bBwp9FnNDSxfB
         jHVrnPQiwb6UfAhLzeuHvZFMR4oGJ0+VkbIzqMnQwutHLgvsDzYF1cmMRNdxpTqAt8Qh
         6lHgTIzqXB3PdqkJEzVVJjiA6qq0mMkr8J9Ky8j/Kb9VfZQBMcFIG4kkYyxW93TxdG2Z
         4iqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F6Gq7ub5CHHz5oZQUrfFZDXZwcJC7EfUjmiAYCq2Jfs=;
        b=PvuqaROPWgBSjijIb7fZvKMuUrC2BEiIPl8MrTwf6NAW+e1/DBbUVsXbs/RBMYj4gf
         iTZrxkyzO08UBmLEqDTdn3TA5YxuMfwzYHucwYhL47sF53fV4GGzSSwUARIUt+geo+da
         syVuFTbZSSxCLYojy+lz+e2dVNR+vFYL0mBGvbEFoRHcd0lj8dQS6sesOFGTkncrDlGW
         DDNU4+LDMPVPuoOSa9Dvb374YxYLsRU+ZE74N/RKwag01HZAGdlXP/KpjjAZ/arO0mqM
         LPAKKzsGXxwb3YXi6V+79Mx2Ch2W3jGQ/nBOW4JNhVEayQz8yTJdT09qgbE5mXgGYyg3
         mzRA==
X-Gm-Message-State: AOAM530RpcGtXSSvRBO4tyCIwqBLJ06Uz9qh/UFVBFPHdTLVNwSgw1c3
        tkxvNlBq5IEalElaScg+0og=
X-Google-Smtp-Source: ABdhPJzq7Gro/Nix2s1f9GImjqWGzJN24eSKv0fByyc7wfDuWPD7q4E+ZSfeHxSjpwTcVA9GHtrPbQ==
X-Received: by 2002:a05:6808:b3b:: with SMTP id t27mr4452083oij.131.1616641664581;
        Wed, 24 Mar 2021 20:07:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id a16sm194234otk.62.2021.03.24.20.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 20:07:44 -0700 (PDT)
Subject: Re: [iproute2-next] tipc: add support for the netlink extack
To:     Hoang Le <hoang.h.le@dektech.com.au>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com,
        maloy@donjonn.com, ying.xue@windriver.com,
        tuan.a.vo@dektech.com.au, tung.q.nguyen@dektech.com.au
References: <20210325015653.7112-1-hoang.h.le@dektech.com.au>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ec0824c4-1809-b934-e1ec-abe08e5b4f6e@gmail.com>
Date:   Wed, 24 Mar 2021 21:07:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325015653.7112-1-hoang.h.le@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/21 7:56 PM, Hoang Le wrote:
> Add support extack in tipc to dump the netlink extack error messages
> (i.e -EINVAL) sent from kernel.
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> ---
>  tipc/msg.c | 29 ++++++++++++++++++++++-------
>  1 file changed, 22 insertions(+), 7 deletions(-)
> 

tipc should be converted to use the library functions in lib/mnl_utils.c.

