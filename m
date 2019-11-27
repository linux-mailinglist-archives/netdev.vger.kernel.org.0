Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC9A10AFC5
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 13:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfK0Msk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 07:48:40 -0500
Received: from mail-qt1-f173.google.com ([209.85.160.173]:45342 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfK0Msk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 07:48:40 -0500
Received: by mail-qt1-f173.google.com with SMTP id 30so25161764qtz.12
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 04:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tGwyIKoVSTSDVQc5rcJNfdSD4C5j9jIXNWmLacJmp+s=;
        b=kvW9Z1cila5wlFeElHAI+CETLkXmJ7VqeVmmhGn2iVJPDivEWSRn6vyYDmf3wdvPO6
         jmWKNfeH8zDab2MYkCEuxCD3fJM3ir3uq+enaGlTmNsa2AaX6KHNnF9tqVCDmDqFJMWz
         C08/CtlCupR83nBD1jn8KjFnVK4B9Gwz9wiqDc9TEoF+Es0K2afYeYD74EPnvEc+0RCK
         tX85HhzEK+r240MSMCF+fH+l0yrizmjC7p+vlXZwnXpcCMnGycDzhkATLofgGqh1MSBL
         ufgDndRGl1aKkOyzuoJGs5yb6Ix8fppHJuhcUcTiUaMwH8nFf+6w98Epa7zNFWtYhpOv
         p3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tGwyIKoVSTSDVQc5rcJNfdSD4C5j9jIXNWmLacJmp+s=;
        b=E2dXKxzVuhnc3nLRi/STHEPrTkH0MqntV3RmTpdMNzIYKKzq6iG5Tf7H/ypO0Dgj4K
         Svr37D5iXQL6hzMCoi2cO71OtzqYRvIpKe1OnkQjYaUfjtqXy/6z1cpBRI74GlLJdkMD
         iLQzPNQin4BFJC+2QO6uNgHYn220dl806gOoVgUqFN5rxT2wN9WCry/IExjW/p6iRkbw
         1+WSell48e7LQox7AwFNslObhYg6JdKaRs78OCAv1BY69mXDZrACCD7wGtjNdWj+eguW
         eVfeq78qJKBl3iM4gpTm+4hVmUnv7LeF6L//RiRcF50aTaNKFuLHQcnwBxFfoBt8JR6R
         9M8Q==
X-Gm-Message-State: APjAAAVEkHhUTtlCWQST7qkHxNNp5952sI+X7R2QjxgdpWhiHPKkjARJ
        0GJ+huwW8SAF8d/81k6u5kL+Sh0eNcmY6ov/LE9yew==
X-Google-Smtp-Source: APXvYqyQW5p1T+6tDo7Vd44ox6ytIZkKwYCSMkVhX3YfVzriqzbA4J3IQbGjaBsQr9PXiQodkruQ2t85s/zfmyyaSJE=
X-Received: by 2002:ac8:66d7:: with SMTP id m23mr30807597qtp.53.1574858919038;
 Wed, 27 Nov 2019 04:48:39 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYtgEfa=bq5C8yZeF6P563Gw3Fbs+-h_oy1e4G_1G0jrgw@mail.gmail.com>
 <20191126155632.GF795@breakpoint.cc> <20191127001931.GA3717@debian> <CAG=yYwnm4vRLRpjT2VOj5fynPhBfhvpVjfbSOvPrs-bwv09mTA@mail.gmail.com>
In-Reply-To: <CAG=yYwnm4vRLRpjT2VOj5fynPhBfhvpVjfbSOvPrs-bwv09mTA@mail.gmail.com>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Wed, 27 Nov 2019 18:18:03 +0530
Message-ID: <CAG=yYwnx9y3ph74ARdSocca1rqoDVz5vt7WBL=5Qhw1fVEnPNA@mail.gmail.com>
Subject: Re: selftests:netfilter: nft_nat.sh: internal00-0 Error Could not
 open file \"-\" No such file or directory
To:     Florian Westphal <fw@strlen.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, horms@verge.net.au,
        yanhaishuang@cmss.chinamobile.com, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> > Signed-off-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

"i do not know if i deserve Signed-off-by "


-- 
software engineer
rajagiri school of engineering and technology
