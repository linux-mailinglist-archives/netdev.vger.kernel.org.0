Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884776C2D2
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 23:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfGQVy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 17:54:26 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40782 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfGQVy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 17:54:26 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so48199594iom.7
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 14:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9+9k5AIUFXbmnr6feE7Z9yQDht+lkYgKKlJHtCBvILs=;
        b=LG/ILG89thHpRLqiY5wI8jToLbeUI2GPHFO/rrNrCgfwVYeYeFUZrtOhhclAC0SESo
         arOjpCQwjTJaBbI+32jRMcvAJTRcIzrz2NiRjMTWTdrpelJ9MgAxPFTCcGOmSR8RsBjq
         +kdD3ALtffvLb5jLSOntrLCCilhKnqjrbRBgtYa0sOEx8D6bTBZEXlCZmjoGxtp6LPmN
         /haU6GQQmsYFfJDXkHIyXtbTcg0UeUUiGOOmtGAj4YD5oWTAEEmXpR1ds/3mvtA/LC+l
         zpceBcg1ZFPcsRWQfsSuna7zSga3zFjZybnALOeA2beftAhZR5Notpi1c5/STV7HyrAQ
         d0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9+9k5AIUFXbmnr6feE7Z9yQDht+lkYgKKlJHtCBvILs=;
        b=pdfaz2BZU5df0vH7dgwqa2S11JmiNBaOsMt4Hok4A+vGkfZYEUpg2D3QyUiS+6vYeV
         WBrv62tCfgPe8bWblcXJ6eqCz2qP8cTRUnUnVixL4YczLC/Ek2cIRoRWC/ztLIM98yna
         1lSUoSJisqkdJNHjRdilkgsydnm5m4X9ttwqRdYVe/7kJIzPBLvVl4OwK0K4AgYPPbn/
         6fNHC40UYTGGRODbnoqGXSyRoOF2vZ3nXEuse6mJldifJ+9+VeD9qwGwOtoLTUOh9Ucl
         sYLcVZwBcKuqjEndRwwS8jfllwarCDlftwuameyN4ED5/4+eLfIzPcJ+lmdNI7D/uqfZ
         dAzg==
X-Gm-Message-State: APjAAAWjOAKCnzs6e4k9/uROU5cVEO9Sabe+URnBB9gMcYbFvDWYfXKk
        N2SF+y+unV1v/MFiNWxwoVdZb4x1
X-Google-Smtp-Source: APXvYqy1iLA6qO0Dn66LpuFACvJYrlH6GB6HeLVRSPriGwjf5TzFqHtGYjPXPV29H2534sMqHgn8rQ==
X-Received: by 2002:a6b:b985:: with SMTP id j127mr39387789iof.186.1563400465557;
        Wed, 17 Jul 2019 14:54:25 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:5059:73bc:5255:ccf5? ([2601:282:800:fd80:5059:73bc:5255:ccf5])
        by smtp.googlemail.com with ESMTPSA id r5sm24260110iom.42.2019.07.17.14.54.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 14:54:24 -0700 (PDT)
Subject: Re: [Patch net v3 2/2] selftests: add a test case for rp_filter
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
 <20190717214159.25959-3-xiyou.wangcong@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <49029fbf-9cbe-b261-d224-b85b536de42d@gmail.com>
Date:   Wed, 17 Jul 2019 15:54:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190717214159.25959-3-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/19 3:41 PM, Cong Wang wrote:
> Add a test case to simulate the loopback packet case fixed
> in the previous patch.
> 
> This test gets passed after the fix:
> 
> IPv4 rp_filter tests
>     TEST: rp_filter passes local packets                                [ OK ]
>     TEST: rp_filter passes loopback packets                             [ OK ]
> 
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  tools/testing/selftests/net/fib_tests.sh | 35 +++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 

Thanks for adding the test

Reviewed-by: David Ahern <dsahern@gmail.com>

