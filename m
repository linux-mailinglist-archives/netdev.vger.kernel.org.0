Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C939639B6E1
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 12:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFDKU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 06:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFDKU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 06:20:27 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8291C06174A
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 03:18:41 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id h16so5305593pjv.2
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 03:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=FzDuveLp7uQGL8pZZlAKqOHjNBHyT1iJWmEcrAoVNPA=;
        b=Eik69OqhRGmhIYakYzpWqyHIhBBP6PIMb6Wh7Vk+lAs2njafNODtq5oLzxvlJuHtQi
         a+nFm9F4rfVhEUTl+sLQ1pZpIWPsWJcg4mclnIpJEI398SRrgNYRpvAo91nRBo63Ifni
         UpIW4qc2MIKN8rEX1JEadNWb4FPdPOjIS3YQENLsRKGDShNQSvb0mRKXEV/JepKry19/
         K2QjCAQsjEfTrjTBfKYhmgXOqWHioFpTbH4ZNCucMp0pPsPzrIMKiy1WY7/GqSErNWsH
         0gNWTN3PFy06dYvrhLxXaORIFJsFToLPbs4hwqtYndmEy5eFKIBlT+IM2hVog4j71qfN
         el+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=FzDuveLp7uQGL8pZZlAKqOHjNBHyT1iJWmEcrAoVNPA=;
        b=XBrOIYNhZvDP7px0x1B2jW6sQcdMBLAejhwFMCLm4UqW1hYayz7XPRl+20NTl9UmNK
         14GtCmrnmu/3lNh3I0TpDGherikG1Z6dxds9NU37EbgHUIAen4Mzg9TocwAxhwAF6kwm
         JSIjIYUvlPuSmg0cCTNnFkjj4xPgjZljNCrry66NEdO9njUzJJlhkOVLyT/F7vY+g3kS
         9vpDsT4qwUO1mNlkM+pEdukIPdVLs5vIW5B/Kia3bKj/bbhkDL4JLHB2hACgZCHpxxoZ
         /2fORENkDVp0kxhLNVigdspcyJUap1b4BvoxJ6EvprU1BR62xfnb1/XC5/ItE8Jn2NNf
         3Ypw==
X-Gm-Message-State: AOAM530PkcHiz8ImoIUdR5ya1PahDEBGRZqwggj1QMhge3wkWvTDjRP9
        6HEWKtC3ysT6Nq4GK+lO+E9RxbVhCHwAlggyyvzfqg==
X-Google-Smtp-Source: ABdhPJzZui9fGbYjNE6HqSrUTEtsd0bkduXpAV11ciTlHX6kvr0IZncAcGv6PhsziqndfN1pE1al06iTIgUWzjz6QlI=
X-Received: by 2002:a17:902:8e86:b029:10f:44bb:2c42 with SMTP id
 bg6-20020a1709028e86b029010f44bb2c42mr2245115plb.67.1622801921386; Fri, 04
 Jun 2021 03:18:41 -0700 (PDT)
MIME-Version: 1.0
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 4 Jun 2021 12:27:56 +0200
Message-ID: <CAMZdPi-MrOAfLu6SaxdEqrZyUM=pyq7U8=dokmxdB+6-C3W3aA@mail.gmail.com>
Subject: WWAN rtnetlink follow-up
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

Thanks for your involvement and great work on this WWAN topic. I've
picked your patches in my tree for testing (with a Qualcomm MHI
modem):
https://git.linaro.org/people/loic.poulain/linux.git/log/?h=wwan-dev

This is minimal support for now since mhi_net only supports one link,
Essentially for testing purposes, but I plan to rework it to support
more than one once wwan rtnetlink is accepted and merged, This
limitation will not exist for the Intel IOSM driver.

I'm probably going to rebase that and squash the fix commits (from
Sergey and I) to Johannes changes if everyone agrees. Then I'll submit
the entire series.

Not sure what is the procedure for iproute2, should it be included in
the series or be part of a dedicated one?

Chetan, you can use that tree for your iosm work, or cherry-pick the
[FIXUP] changes if you already work on the submitted RFC series.

Refs:
https://lore.kernel.org/netdev/20210602082840.85828-1-johannes@xxxxxxxxxxxxxxxx/
https://lore.kernel.org/netdev/20210603044954.8091-1-ryazanov.s.a@gmail.com/

Thanks,
Loic
