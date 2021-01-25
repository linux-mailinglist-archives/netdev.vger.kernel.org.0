Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA91303451
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732440AbhAZFXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729736AbhAYQvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:51:44 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A0AC061788
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 08:50:23 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id h192so15473402oib.1
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 08:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L8VysMoy/6ZWM4Z2wTjc5OGMC8yffqUrNtZJ4X5dnRw=;
        b=tDzKmLPQUE5oIMMKoZ0mw+5AeeWNupUMiync+sK0FHg/OhX4YjezK6kift/ymiQgTb
         mDcovFCErehzhoTkos6pvlyby1UaqmdgHo87zz7FFKBcuKEQybFsIwdFqfDIRXvwlEux
         tEXg+zS1RBOeLFavfR7U5Q4IxQLhzcLzhQhSeoqJqPJ4Ur3rK7nPEKBXBC1RjTF0Q9H6
         vtVtgRmxSl77Hln9zrAuEanJiru5JF+EK5jrdgcM61Ywm6eDCwgxvxYElqzHPQcowIef
         I3qkisu/jo25vj598DPXPPTDbwRl3JRCthsw3sHFq7p6zvzCsdZDcYYVjM1akXkEFfkg
         Wqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L8VysMoy/6ZWM4Z2wTjc5OGMC8yffqUrNtZJ4X5dnRw=;
        b=VzVu0MShWbOBeQzwyUze4buVCaEsmSVkl2NqlCi/I/Pv9yknl3cPXrWN8nkoh8Mh/6
         0zf7pucBUm30Ceqvb8pBTOQLt5c5ptnYXARKBddrfSlUHOeOjd+RQ36mUkng7lAKQ0hI
         UpaUaNh7jt0xAvAk40cYXf6uCVlNok6SzMVJZAH6tLc8zHyiDLYv1DNit3l3tLFPwYDr
         4HxUyl4ViWWZxC7cLcRQuWMKPJeDaqLRWFnSd3RxY/666/qRDz/NT809yNc/mniojGqm
         5G04Mw11lFO/mFgqOaIkGpFWWQiOmArxJqnHlZLP0IpFUexDpdb2pkmAm1tze7sKt4vM
         9zPw==
X-Gm-Message-State: AOAM5319ZkX9+gYZB1Iv1AcN0T24LoE1fP/YheGIiUjuBqPNh2YWNh3O
        KBrm9Xp9TTP1g5jCG4+rEpewczZGPUQ=
X-Google-Smtp-Source: ABdhPJz+3AKQxNjTpqOLlFhSAQ0nQuuADZ521xeOyFykoreBQ6AveYvBEMg2X3dilYRSEu+P7by2cg==
X-Received: by 2002:aca:df57:: with SMTP id w84mr680263oig.16.1611593422744;
        Mon, 25 Jan 2021 08:50:22 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:59b3:c1d3:7fbc:c577])
        by smtp.googlemail.com with ESMTPSA id c2sm3135489ooo.17.2021.01.25.08.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 08:50:22 -0800 (PST)
Subject: Re: [PATCH iproute2-next] Add description section to rdma man page
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Alan Perry <alanp@snowmoose.com>, netdev@vger.kernel.org
References: <20210124200026.75071-1-alanp@snowmoose.com>
 <20210125062515.GD579511@unreal>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3d1df9a0-b4f8-8d11-17a5-bd5e5f0d2bad@gmail.com>
Date:   Mon, 25 Jan 2021 09:50:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125062515.GD579511@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/21 11:25 PM, Leon Romanovsky wrote:
> On Sun, Jan 24, 2021 at 12:00:27PM -0800, Alan Perry wrote:
>> Add a description section with basic info about the rdma command for users
>> unfamiliar with it.
>>
>> Signed-off-by: Alan Perry <alanp@snowmoose.com>
>> Acked-by: Leon Romanovsky <leonro@nvidia.com>
>>
>> ---
>>  man/man8/rdma.8 | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> David, can you please pick it up?
> 
> Thanks
> 

changes to man pages for existing features go through main branch.
redirecting to Stephen
