Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480132621E8
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 23:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbgIHVXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 17:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgIHVXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 17:23:35 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F3AC061756
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 14:23:35 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o8so437840ejb.10
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 14:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=br7kqX/EdOL7Dtz4xbsGL/PqgcQRS1tChb51PYcN8dE=;
        b=OynqUYlbUs7iBeqSmkGzesj47qaR8oT14XhnS7OUMJ8ajmWM6PyfFHscblZlW8coxp
         gusIhiL4efHs5JVE1NoJTZVljm3SPUoWS14ie7DFYGj1mb9rZ2nAe36PaSY0JTCZf/No
         Y+awcP6yavDk5i99+yoIn9LGQcWj606RFY3pzc2hlVH6e+m1CsNU7n2ajDLCgcUGwSm2
         5kja8Q74WbHcBLAqdE/RJi/nBeyDwd7eLXb1kJvFb8QR7QSRYft0FNWZmChgQ/hYLWQf
         eA8xAaAx6fkB5F2/o1J2+c+LxWW98Ye0c3ibHpjqrkeCTkZb7P+gXpcL6qQMU7dqN9bm
         UalQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=br7kqX/EdOL7Dtz4xbsGL/PqgcQRS1tChb51PYcN8dE=;
        b=YYbOUQD8Y1cCQC2kApwt6l7o+75jQnvZi6gTAYP+HSVgjN668uZerGjK5DQnYH7I1y
         68phQO8d0MJ0eZ6FOVuuY2UmPqt9/5/CP4J7zaVo3UodxkiZ7Hr4Me0nNJc5L0EyBWhs
         07YEl1fE7IweF2WNibbUliiOkmLOGzMDG2RZ9dKlpysEjhSOxDM286sV6ma+9meE7Nyv
         tCv5ksf31Q9Rczwny+y+x1SkW3BQ86VD+rOCNC4GHg+OZPl1idQ72uzyNl+97FU+7TM5
         OTPfXGjuxvol+Hhe6M/ruFCbGeAyvn3p8EhnIUOUT+XEaVARYOPZKAN42zAYHrHHUBfU
         U+eQ==
X-Gm-Message-State: AOAM533IO2oBHkBcR17Ero6AM2FoHNmqF/+44zU0w1G9ktA6gKkrkMTN
        SseqH5S451xL6XkcstEN23EQSIN3YrAG5lCrDcaHAEI0IA==
X-Google-Smtp-Source: ABdhPJw0uILieaMH3Md5pDW6MLvdTIEjLkaUHI8McMxvysOSsWSpCu7dFxVboDb/ZbuayzuGCaPRAGD9wnbbUoyVsfI=
X-Received: by 2002:a17:906:8c8:: with SMTP id o8mr419310eje.91.1599600213831;
 Tue, 08 Sep 2020 14:23:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200908140543.25514-1-wanghai38@huawei.com>
In-Reply-To: <20200908140543.25514-1-wanghai38@huawei.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 8 Sep 2020 17:23:22 -0400
Message-ID: <CAHC9VhRGzWd+SSQvMqapzLwo3dAJGShJOq-3Wyx0SNZ+TvmjqQ@mail.gmail.com>
Subject: Re: [PATCH net-next] netlabel: Fix some kernel-doc warnings
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 10:09 AM Wang Hai <wanghai38@huawei.com> wrote:
>
> Fixes the following W=1 kernel build warning(s):
>
> net/netlabel/netlabel_calipso.c:438: warning: Excess function parameter 'audit_secid' description in 'calipso_doi_remove'
> net/netlabel/netlabel_calipso.c:605: warning: Excess function parameter 'reg' description in 'calipso_req_delattr'
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/netlabel/netlabel_calipso.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks good to me, thanks.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
> index 249da67d50a2..1a98247ab148 100644
> --- a/net/netlabel/netlabel_calipso.c
> +++ b/net/netlabel/netlabel_calipso.c
> @@ -426,7 +426,7 @@ void calipso_doi_free(struct calipso_doi *doi_def)
>  /**
>   * calipso_doi_remove - Remove an existing DOI from the CALIPSO protocol engine
>   * @doi: the DOI value
> - * @audit_secid: the LSM secid to use in the audit message
> + * @audit_info: NetLabel audit information
>   *
>   * Description:
>   * Removes a DOI definition from the CALIPSO engine.  The NetLabel routines will
> @@ -595,7 +595,7 @@ int calipso_req_setattr(struct request_sock *req,
>
>  /**
>   * calipso_req_delattr - Delete the CALIPSO option from a request socket
> - * @reg: the request socket
> + * @req: the request socket
>   *
>   * Description:
>   * Removes the CALIPSO option from a request socket, if present.
> --
> 2.17.1
>


-- 
paul moore
www.paul-moore.com
