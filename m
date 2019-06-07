Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD5C392E0
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbfFGROq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:14:46 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43948 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbfFGROp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 13:14:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so1477157pgv.10;
        Fri, 07 Jun 2019 10:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dhu7ls2KxQ8QU/rN48Qc+UuKg6SARArc79RMxUBdLhg=;
        b=gJvoYzeZoCPM/XqMnfJFv1IalZWCl8N+pxJ9sKCjMIsTbd4AXAvdEa6K4magaXu/Yu
         8AuletlbFiZNPsomLDaf/yr1UmBffYRpFAjT3RcEUHR6bT2FmNsSGt45m2IOAWyXZEjU
         UB9WtFUWaztxuNP4AU9QkJdgbCqKeXRLK7WKRguMRAqw4bYfd3BfKNmk9TjmrcHEvbY6
         fi9dIdtpbMLkhldXnVw/fF+zy4QEe6EmW5Jx7UiLhctOd7j9iLucyR3zNoW+6ZAzCPUg
         oL/fCorGNksWg+8u4nzO1X3DbPJdfdAzAqk0kN4/XpYs6W9wClf3rz7HWj9ylnbpDmRg
         Dk1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dhu7ls2KxQ8QU/rN48Qc+UuKg6SARArc79RMxUBdLhg=;
        b=nsBpcCveL0o9qvRYAeX67m2xwm+RhIU5QK3wxphSqqz+v43MOX11o0c+yR4HP13KNF
         3FbzCNAQjRlFUCkxzVTqMjmTULf62QRLNZryDEjL7ir89v7CmRnLj2oONu/TszpOBNMD
         pzAEu/abblvvJM5fRifJkboj7y4JGwPsDZ/IWPLWlsEyOp+QXF8R5FcV6yDOWNTcc9hL
         NUsXR+fx9ikbGGvk8cnHkmB7R9arDVIks9S6oluSS+eCIfwee3LNlQ8uFC6vmhzCVvBn
         z9XX/MZqogmveCHKZ4AnGQplvSuURsG9/AVd3Ndy5XRjsEr+eOqu27RJlDLHznvA5BXk
         futQ==
X-Gm-Message-State: APjAAAUb5p/SZyvyL4IEEEYllEjVDTmklv0aBTf6cGQGtkfxsAozom/W
        3ZIf5qmewHlyqm/VgWme1A2no3W2zpo=
X-Google-Smtp-Source: APXvYqxMHSUGdCBGfb1AcstvB0brl/MCNX+/DnEPN4AAQpGYch+7JOv+AxxtFJsDHktR2gf7D2nPiQ==
X-Received: by 2002:a62:304:: with SMTP id 4mr60126177pfd.186.1559927684362;
        Fri, 07 Jun 2019 10:14:44 -0700 (PDT)
Received: from [172.27.227.254] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id p6sm2850294pfp.88.2019.06.07.10.14.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 10:14:42 -0700 (PDT)
Subject: Re: [PATCH linux-next v2] mpls: don't build sysctl related code when
 sysctl is disabled
To:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20190607003646.10411-1-mcroce@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ea97df59-481b-3f05-476c-33e733b5c4ba@gmail.com>
Date:   Fri, 7 Jun 2019 11:14:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190607003646.10411-1-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 6:36 PM, Matteo Croce wrote:
> Some sysctl related code and data structures is never referenced
> when CONFIG_SYSCTL is not set.
> While this is usually harmless, it produces a build failure since sysctl
> shared variables exists, due to missing sysctl_vals symbol:
> 
>     ld: net/mpls/af_mpls.o: in function `mpls_platform_labels':
>     af_mpls.c:(.text+0x162a): undefined reference to `sysctl_vals'
>     ld: net/mpls/af_mpls.o:(.rodata+0x830): undefined reference to `sysctl_vals'
>     ld: net/mpls/af_mpls.o:(.rodata+0x838): undefined reference to `sysctl_vals'
>     ld: net/mpls/af_mpls.o:(.rodata+0x870): undefined reference to `sysctl_vals'
> 
> Fix this by moving all sysctl related code under #ifdef CONFIG_SYSCTL
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
> 
> v1 -> v2: fix a crash on netns destroy
> 
>  net/mpls/af_mpls.c | 393 ++++++++++++++++++++++++---------------------
>  1 file changed, 207 insertions(+), 186 deletions(-)
> 

As I recall you need to set platform_labels for the mpls code to even
work, so building mpls_router without sysctl is pointless.
