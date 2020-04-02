Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4510019C2B9
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388659AbgDBNcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:32:21 -0400
Received: from mail-vs1-f47.google.com ([209.85.217.47]:41172 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388311AbgDBNcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:32:20 -0400
Received: by mail-vs1-f47.google.com with SMTP id a63so2241075vsa.8
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 06:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qbxYEcxLIAfmwv8/JFI5XlK7N/zQk0sceuC21pvNkUA=;
        b=AdaaY+gn4z7+BZ2xgWzQadQI7VaB3LbrQp8VRIoUic6M+z7EtYYK2rlHlrs2psSrIc
         OtksR+m+TO7hqyOdk4T6DAile9TGDoQhFLfSf7sjPltqkAEDCYZNpBjfiVmwl+Abv3AQ
         gLtbkxRtXJG0EhJ4iyC5KZ6Bfea2ho09JQUcs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qbxYEcxLIAfmwv8/JFI5XlK7N/zQk0sceuC21pvNkUA=;
        b=GuHzA5tiPmR5glOsKmQ7nHS2G0SM0eYIsCMFT5pXGxKvDPg55BlwFepAkQh+d2ZYic
         g9LaljunKR3yKYce1s+IG8qOVlM719ia6YfltFdizYblMUk/B90zxeQx0CW3CFU78Udl
         Nyi651YjBB8Y1ctIHvj1I9+ShgYjPe+i3AWMUnjoliboy80Kdn6xqDS2G1gvFDjv0JmD
         02aeeTjR0YqsxcnXgahK+ohuNO+I76NR30lD7KRsz7jIq9mc3b5hQRfWCznXxOtmzIe/
         ipiF8BpsaDxpL8RkHnwT7LIoAYX2N7pRo64INuDV4Z5Z/+XZUr5yBCuMy5qRZKG1beXQ
         u4KQ==
X-Gm-Message-State: AGi0PuZr5VV8ZpgZP/Asf0VyJ9dg0kltM9z+Nfb60TyRyx1vpzPvwWdw
        URLlUtg55ms9GhfFdNoNJ2vCq3+lAypMaw6W4vqRvg==
X-Google-Smtp-Source: APiQypIzo5JZ4FoCUGL923E9gS/mAOA37qSLNmFR6zs1LpS6Fzg9QMVVfzTzIN8sXVW82JloTmnXGJkHqmSXXhdX11U=
X-Received: by 2002:a67:fa08:: with SMTP id i8mr2107813vsq.64.1585834339872;
 Thu, 02 Apr 2020 06:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200401143114.yfdfej6bldpk5inx@salvia> <8174B383-989D-4F9D-BDCA-3A82DE5090D2@gmail.com>
 <20200402124744.GY7493@orbyte.nwl.cc> <60AB079D-9481-4767-9E07-BDEE7E691B6B@gmail.com>
In-Reply-To: <60AB079D-9481-4767-9E07-BDEE7E691B6B@gmail.com>
From:   Brett Mastbergen <bmastbergen@untangle.com>
Date:   Thu, 2 Apr 2020 09:32:08 -0400
Message-ID: <CANBx8VBF2LuGoE2dODLB_3mQixj5YUQTvvsaUTDyNniwb-Ti4w@mail.gmail.com>
Subject: Re: [ANNOUNCE] nftables 0.9.4 release
To:     sbezverk <sbezverk@gmail.com>
Cc:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, lwn@lwn.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I need to revisit this patch, as I THINK the typeof support for maps
gets us close to where we want to be.


On Thu, Apr 2, 2020 at 8:52 AM sbezverk <sbezverk@gmail.com> wrote:
>
> Hi Phil,
>
> Thank you for letting me know, indeed it is sad, but hopefully it will ge=
t in sooner rather than later.
>
> Best regards
> Serguei
>
> =EF=BB=BFOn 2020-04-02, 8:47 AM, "Phil Sutter" <n0-1@orbyte.nwl.cc on beh=
alf of phil@nwl.cc> wrote:
>
>     Hi Serguei,
>
>     On Thu, Apr 02, 2020 at 08:38:10AM -0400, sbezverk wrote:
>     > Did this commit make into 0.9.4?
>     >
>     > https://patchwork.ozlabs.org/patch/1202696/
>
>     Sadly not, as it is incomplete (anonymous LHS maps don't work due to
>     lack of type info). IIRC, Florian wanted to address this but I don't
>     know how far he got with it.
>
>     Cheers, Phil
>
>
>
