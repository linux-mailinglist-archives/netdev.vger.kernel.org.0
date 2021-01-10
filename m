Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BC82F08B9
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbhAJRXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbhAJRXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 12:23:49 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F87CC061794;
        Sun, 10 Jan 2021 09:23:09 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id j20so14743747otq.5;
        Sun, 10 Jan 2021 09:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=44c63VzJZUoE1XYcWg7SZWIsmhW5D9dlRHxD0H5iWdw=;
        b=qaalwv32A6b0wF6G7TUi56EXYkal1fZnGJ12Kp4I1u+CFsVhXG+L3mP/787NopoMBF
         rGN++mCTr/sy5L8i9GkBM1VyhYyeyuYNtWSiGYWCfv2dv/ntos/89yh+ven4jh2eWIh1
         aPA7PlFlOyIBvFJGd+mTdjlH5zKQFZj5TnHk+mYMhKbIkFcWSYPWFoDny9WB44Y5cPug
         WGclWCfLh+QmOex/LC3SBKj/p9rBnsuGQ0+qtArM3Z2iF1pz6LCFPOQsMU+OttjvSGyJ
         BCcXFGV57NOVAaXbW1wVw85YN5dsqYptwdsgu8+d9/eOLIuxMd1jR55nEN5fvk9YqU71
         HvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=44c63VzJZUoE1XYcWg7SZWIsmhW5D9dlRHxD0H5iWdw=;
        b=ZtgYQjoyD0LktoiBEIawJP+Tm3u72P5pcgLezM9kwmeFx6a4ef5BhfARGla1XEuws/
         o1BUhmLYjgLXTkZwcx8zl9Eaoeh2QOIfnyImaHV9o//DMK6PGx5IKeb1H6EV17Q4CR6Y
         QDtXoZc5MGXOkcZfYB40nV7Ing6+om3pVRGY+CurlJFvLMJZI9uqCDQ9hQQfMHRSPBSx
         Vc4VBKgmrjBs9+bl0Quxc6xz4cUjqVqzuiMFfedpCyYJg+XyLFsE0T5n3Ox1Gwkq8/Om
         EEYGLvo29JmUDJELseeEj7cD+erg69D5Ef0n9htZCi0114TBK7fOeTropdNkJccb1iLN
         B9pw==
X-Gm-Message-State: AOAM532ejvtjTLNHiieXAyF3QqEAHR8Nh3OfR5qnU+HejJ6j5DrRVZ3K
        KmgULfdbwQz/zTr/6aJcSgxVW6N7an0=
X-Google-Smtp-Source: ABdhPJz90xzr3TVfJk+CjdpkYm5jnH4n7HFq38Q25TO8Ppr9CRyKN6wnL5+2wNbTuchrvuIq4WvaoQ==
X-Received: by 2002:a05:6830:2144:: with SMTP id r4mr8471791otd.180.1610299388567;
        Sun, 10 Jan 2021 09:23:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id b8sm1336318oia.39.2021.01.10.09.23.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 09:23:07 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2] rdma: Add support for the netlink extack
To:     Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20210103061706.18313-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f2ad7596-b976-aef7-56b7-edfba3a77ba0@gmail.com>
Date:   Sun, 10 Jan 2021 10:23:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210103061706.18313-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/2/21 11:17 PM, Leon Romanovsky wrote:
> From: Patrisious Haddad <phaddad@nvidia.com>
> 
> Add support in rdma for extack errors to be received
> in userspace when sent from kernel, so now netlink extack
> error messages sent from kernel would be printed for the
> user.
> 
> Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> David,
> 
> Just as a note, rdmatool is heavily influenced by the devlink and
> general code should probably be applicable for both tools. Most likely
> that any core refactoring/fix in the devlink is needed for rdmatool too.
> 

understood and it was not the best model to start with but here we are.

Petr did a good job of refactoring when he added dcb, but rdma was
slightly different so the refactoring did not update it.

