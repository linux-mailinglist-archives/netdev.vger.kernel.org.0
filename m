Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70EC10AFBF
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 13:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfK0MqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 07:46:12 -0500
Received: from mail-qv1-f54.google.com ([209.85.219.54]:44356 "EHLO
        mail-qv1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfK0MqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 07:46:11 -0500
Received: by mail-qv1-f54.google.com with SMTP id d3so8785453qvs.11
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 04:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zh/vBERm/TbGM+yKl5SoCFkCcaIxa+50MOn7rbgBP8Q=;
        b=gkyvth1/Mbl64/TJUNIuUxJnbtlh5omWv1qlqK95S5J7cYBXdi05gUzZBljO3jOOcb
         HqEHMrZG/RmkV85nz7Yx4rZl1Jt53AtzzPaneyjPwSRKTJU2syvy170bWmvbWkzdQVWa
         DYiB77Gxhziqu90y/UTPGDggPTj7u5l6r1SZCSDOJSLMWldtA1LMX2yCGoFzxPvFGpGL
         Iu6kTOYu347m34fMmuuKuQ6KFlXEgX1LSHGIa72Ko70Ewh0IcOplDsh2WzzpLwL392gd
         oO7rEwZ6sun1jv2g5Qh1UzzGd+OFJydJmNRGMk+8O3HFB1dzUg2MRi34BWcKZiM1dNId
         YYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zh/vBERm/TbGM+yKl5SoCFkCcaIxa+50MOn7rbgBP8Q=;
        b=MOx11TvzympMvCAk2yiMOu8rHuImDQtQZsFrKLKKPzM8/rljR4ER0UdaFr4gpK/6IK
         faCZVM7hgeWJBwYRMpQP7XeyMHY+VnleKLpWsygJssqXX2fN8luQuFhFk5sUGSOP1NWx
         qxTsktR8cxqG5CqUNdIJMuSVLR1sTazhGY+VV4pHZ35PWEw6wBeic/ey0AlFn/kqYLt0
         3GNfbZFmgpz+ClOyeMvkV75w3eRYRYix2YLXDeygMqYH3YOGdYG5xP8MFwm8OngCX+jx
         0UOvry+v8Ct6gub1unAg3x9/V0uxrlZ+h7djo8QlpskaPDo8P0PmWNTa8oK/1bitvTSa
         BrRw==
X-Gm-Message-State: APjAAAUZEwUBu7P118y2a83NwzKgejTWZ+b7P76zsJTeZQCgJkQcQYCB
        xk6XfeDtnfPS/zsnnHSF88rIrRClJJpJDLhabGPing==
X-Google-Smtp-Source: APXvYqzYfa89PkENwWgrr+lbnyQptNxwjQ2eMJwZTVJ9xXPkWzFPnmQzwgOahRvkhhc1AO6G3I1PdkrXLAcRysHEqrU=
X-Received: by 2002:a0c:9bd1:: with SMTP id g17mr4504471qvf.59.1574858770657;
 Wed, 27 Nov 2019 04:46:10 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYtgEfa=bq5C8yZeF6P563Gw3Fbs+-h_oy1e4G_1G0jrgw@mail.gmail.com>
 <20191126155632.GF795@breakpoint.cc> <20191127001931.GA3717@debian>
In-Reply-To: <20191127001931.GA3717@debian>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Wed, 27 Nov 2019 18:15:34 +0530
Message-ID: <CAG=yYwnm4vRLRpjT2VOj5fynPhBfhvpVjfbSOvPrs-bwv09mTA@mail.gmail.com>
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

On Wed, Nov 27, 2019 at 5:49 AM Jeffrin Jose
<jeffrin@rajagiritech.edu.in> wrote:
> Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> Signed-off-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
i do


-- 
software engineer
rajagiri school of engineering and technology
