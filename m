Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1320A1BE564
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 19:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgD2RhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 13:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726950AbgD2RhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 13:37:04 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867DEC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 10:37:04 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id t3so2891275qkg.1
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 10:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vjM4nhI/Tg4z1tdpdiSi1G65ack8i4Y4ysgBV3alWr0=;
        b=lCv3t/euHxLyfOBoa2lfbII0LHPaxWFGCCsC9a4w+UaUWw1bZUPq/8wipzk37uxHP2
         KTB9lFdpqkLVn6tnRzUoOW3Yt0An0OLN7Y/TuBYPHb7zDQ1YhtUWn97lKZg4LwqHd4me
         xHZEGr8r2KuMI7gk2H/2pUrKFCRI0lJYXUkQXrHZ4FTPb/KMxTSgpZJHKF61e/tYZbGV
         tRLR6oZTNt/yvAXpQhvCzDcwnqAU/6NrQeEttoicP9FL3jfmn9n1rEH3EEhbVI8Wrj9l
         Stfwm55SotBX++e8+LwWTnYS91FCpbFDWlaTbocB+Hm+LzgECBDKlBrXMRPtqIZsrecY
         pIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vjM4nhI/Tg4z1tdpdiSi1G65ack8i4Y4ysgBV3alWr0=;
        b=ssHWtehhl0PsAJROM5/S8vVQXTC4J8XFN4t/SEBk67s+7kjl65jd0YboR2WGpwAqTq
         x7SEX9VMTWkN91kQgIMfav/cWrvWWZLZOR79yPvK4oLH8C5rEhqX3+66c4z2xFdKiGyv
         YvGTSYdAl17PViqlqBZLKPlMSx9IQhhWIaZvspCSE0theYThpH/ySxLc5txHxaWp7tLt
         WDNBPA3MsLJd2YN3EhrSo2uin82KkfG0GO56iVgVUjZuFRDuGHtyTOa+84+jJlSXKFk0
         Rh0ApMe34SmTSPSew6BjcxbmeCS9bwrNnXTYEoe3rAYbo8m+ZiTa1YFUCLZAfk1wF/wp
         kGpw==
X-Gm-Message-State: AGi0PuZGrl4k4XvCJyhvnPy/gWepsRsm4X/da0likRxWLbxsPqEFvhe2
        4t2zvSeCDavCsACLNgQhxRg=
X-Google-Smtp-Source: APiQypLr8ZqxJYG24Ce8ybkv63ObGxYZPFFIDkv3wjC+mMIv3Qqe/LJXgD7XgIfdtxRJKGU5ie4+FA==
X-Received: by 2002:a37:7c7:: with SMTP id 190mr34767114qkh.477.1588181823820;
        Wed, 29 Apr 2020 10:37:03 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:3576:688b:325:4959? ([2601:282:803:7700:3576:688b:325:4959])
        by smtp.googlemail.com with ESMTPSA id 103sm16514333qte.82.2020.04.29.10.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 10:37:03 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] man: ip.8: add reference to mptcp man-page
To:     Paolo Abeni <pabeni@redhat.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     Andrea Claudi <aclaudi@redhat.com>
References: <bc8e7bce10677759e39fb8524f4f3e5a991313fe.1588180491.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <175e7fe9-f8e3-4f82-d18e-4c1efe0f8ec0@gmail.com>
Date:   Wed, 29 Apr 2020 11:37:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <bc8e7bce10677759e39fb8524f4f3e5a991313fe.1588180491.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 11:17 AM, Paolo Abeni wrote:
> While at it, additionally fix a mandoc warning in mptcp.8
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  man/man8/ip-mptcp.8 | 1 -
>  man/man8/ip.8       | 7 ++++++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 

applied to iproute2-next. Thanks for the quick turn around


