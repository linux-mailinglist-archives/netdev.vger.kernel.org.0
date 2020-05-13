Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F47D1D1B0C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389579AbgEMQ3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730731AbgEMQ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:29:18 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0418EC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:29:18 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id q10so303103ile.0
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u51Ie3hxAKPu1qbArRB4HGjjejkk5lYjufdOHA0vJws=;
        b=sl4294rl0ziF7iRGRKbjVmcmV1+TL81FMJU0HJhYAceWuVWN/1Hu8BAgasC1Pzlyze
         iDauye8ghZYuPf+/EWuUqpKS9FPtqsf+SZ3cGvRZJdb/zMt88x2k+HNWrWLCZsj/IZeE
         NVPPZwa/hBCizPDkAI5yBqWjhkwz7U9wN6pRZ8znJ94wsPrNdb5NMBM5h9jy+XoqaKcu
         KV7Ar7k6dvQws5rPgmELah4pLWggy4d6PO9U4v0I9dZzx3CoXuJs2D/Z+RCX7kJrw0Dp
         Z76FbuZYx0wvNOI5CnkMRvjuupbm1En1F8e9FnIGW0AWcSeUI/tYo16rT8sf1ESxMOq9
         j0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u51Ie3hxAKPu1qbArRB4HGjjejkk5lYjufdOHA0vJws=;
        b=VSPDM88eGRen8gBV4eWLBfU98UfsKdKg9ONT5x+rGhsy92l1uJSu51xnQVC0YnpnxQ
         mrN0pUF0FGNzbWm/PDNsJtRVsTUovc2oPN6WpSlZ9Q13qoAJcZVhfufy/+6Dk1ag5tEK
         IoltY90yVssKOtYK6z1quZSHy3HYN7KzwNHM5+mA1YtK8sWr+nJqpQzbBa012XC33LPq
         MpLoNNdQPGufvgV4f+71ubVWhluguqwDpsNtDSIv3GNtK3LHviNWPpf61E+SPRdIk/Qn
         zfzxE3emxkVLXt8aQbbP3+/eZ7o7nySG+rZiovu6qw4se30VN9MnJ64E927oYefnOEMh
         JLMw==
X-Gm-Message-State: AOAM531ZyUJWsDIjw/zxZ5y8mbO9i4Ba3ERBTXw9jrGHmY6tZQJPdeg3
        RZgdtcJ8Q9XO0HxvGJfQ7aPIuXzmAogNf4YXfy6HSNXI
X-Google-Smtp-Source: ABdhPJzYLxVVXf+n6CL/Szt7SA0ZEqYbJBye1HUm+xogk/LS1J1ffGLd9GGxHIyu2SuVzCEPELcUXLRTpqyKWxTecls=
X-Received: by 2002:a05:6e02:544:: with SMTP id i4mr259501ils.145.1589387356960;
 Wed, 13 May 2020 09:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGfNH1m=-rFdkAmGUt3vxFqaGmJnW+RKP-faU6WwOKWoZg@mail.gmail.com>
 <20200513093944.9752-1-jengelh@inai.de>
In-Reply-To: <20200513093944.9752-1-jengelh@inai.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 13 May 2020 09:29:05 -0700
Message-ID: <CANP3RGdUALH97LB2jHryrFsGYq=h2xwDTVRWuaG_-H-9squsXg@mail.gmail.com>
Subject: Re: [PATCH v4] doc: document danger of applying REJECT to INVALID CTs
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux NetDev <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apparently no, did you send the wrong patch?
But since you'll have to resend again, 2 more minor stylistic comments.

> +P_2 being succesful in reaching its destination and advancing the connection
successful

> +state normally. It is conceivable that the late-arriving P may be considered to
> +be not associated with any connection tracking entry. Generating a reject
s/be not/not be/ is probably better

> +only DROP these.
would 'those' be better?

> +P_2 being succesful in reaching its destination and advancing the connection
ditto
