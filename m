Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640E439F284
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 11:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFHJge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 05:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHJgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 05:36:33 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F84C061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 02:34:41 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id m7so2343115pfa.10
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 02:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AyMIcj8m5LIdqN1ycU6LnuJAf/FFtgNQ9trQC0hELZ8=;
        b=yAX/DjOYZs3WCaN28iKCdR4yMSqBA/4bSwLX8NZuMgC0skXSkmVo+/J+Oujx4fcYIk
         lU0DYx4Kpee0ZJb0oct5wWpcHepUSKWlpNLw68AiFKeKQLPM5GG5bjomOBuoX7wA7J3y
         oCDvOWqwlTE57PGofu73hQPQYAcHchq24zporwJpknBk0cDCEdAFkCOf9JKDxOCl/yBR
         ++IbT40Vsx+LZzfYN0SArFTcfOcc1X1svdwYTfMYIR+4qxAzejq83mpg31zk2GsDzMlt
         +Z0BppjjEZicE1RkTxq+FwcLrQaU0dpZ+ARUZUL1EKITgcyys4ygqBy0kKg8mfarzbBz
         2reA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AyMIcj8m5LIdqN1ycU6LnuJAf/FFtgNQ9trQC0hELZ8=;
        b=sF6xxKioLXt9M/NKL3uG+YPPx1CjfljBg/qFt+XCe9FzWBVU89hD+V7YdLscatv+kJ
         aFH+iuYzIY+SBMlE/x4kB9ZjrPaj/hErgxMoSimfuupNCzKKzU3kRDifC9+7DFIm3aZj
         Pw/zEmqceZYM+FMfSDPEOGNrztxEVp09IhGYNfKEtbKHvP6QwqQu+vVKRlzo4evBLFy2
         w+GNQVNGXQIFBx1YwsG8J3dCZIGqmvHwKNuuRx9bQkeBkyY0aSkCcvO8e3bUcAMCyGmf
         4IBD3qv12MuD5iHM7L9CfrfYSSFW0BZdH+0GdYm4fB8Pzf22lHEco3p4yNpvdnM2l07Y
         3CcQ==
X-Gm-Message-State: AOAM533K4oJ18Dvizl53wbtVvnvZ8+pkuWc+5Cz1pKk1tY/ZkVmn0IMe
        BrdUXTIVHrZf1eMBOFWMFdgtar0tWkjbXGvhpACiPw==
X-Google-Smtp-Source: ABdhPJyRSWQ91ImL59rbVAi3rnX2iCSp22oMKXvcHCG+R4y1N9YiJFTUsvpx+wCBH6rCh8mSxSqcbOgQLM/jCuUQwR0=
X-Received: by 2002:a62:5c1:0:b029:2a9:7589:dd30 with SMTP id
 184-20020a6205c10000b02902a97589dd30mr21047692pff.66.1623144880756; Tue, 08
 Jun 2021 02:34:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAMZdPi-MrOAfLu6SaxdEqrZyUM=pyq7U8=dokmxdB+6-C3W3aA@mail.gmail.com>
 <832997cdbd3a4f4bb87978d26d3e5ca5@intel.com>
In-Reply-To: <832997cdbd3a4f4bb87978d26d3e5ca5@intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 8 Jun 2021 11:43:51 +0200
Message-ID: <CAMZdPi8wW2CWfc0rVKNgy0UKUWvGqiD9yFq09CxC1LH2ng0WFA@mail.gmail.com>
Subject: Re: WWAN rtnetlink follow-up
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chetan

On Tue, 8 Jun 2021 at 11:18, Kumar, M Chetan <m.chetan.kumar@intel.com> wrote:
>
> Hi Loic,
>
> > Thanks for your involvement and great work on this WWAN topic. I've picked
> > your patches in my tree for testing (with a Qualcomm MHI
> > modem):
> > https://git.linaro.org/people/loic.poulain/linux.git/log/?h=wwan-dev
> >
> > This is minimal support for now since mhi_net only supports one link,
> > Essentially for testing purposes, but I plan to rework it to support more than
> > one once wwan rtnetlink is accepted and merged, This limitation will not
> > exist for the Intel IOSM driver.
> >
> > I'm probably going to rebase that and squash the fix commits (from Sergey
> > and I) to Johannes changes if everyone agrees. Then I'll submit the entire
> > series.
>
> Could you please tell us when you intend to repost patch series ?

Going to submit this today, feel free to reply with your Tested-by tag.

Regards,
Loic
