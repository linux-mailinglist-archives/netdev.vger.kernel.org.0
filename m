Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CFF3077B9
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhA1OMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhA1OMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:12:47 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CADFC061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 06:12:07 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id c2so6737214edr.11
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 06:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VK5tR6Myn0rdzrjWUwSngUiLXr6XHXBHtgosAt8owDM=;
        b=jcR28sEFwTvqqG74+xy8c4zNH7+CWx/F5w+G4U0rp3iS5sM00Q9Vg+KPV12LujbIfB
         28wwNePBbdpv1ougPxCdp5aeaYrPYiGvdemWglVla3SRLS+VJIAETp4RTo6M6Y6Q+J4e
         SGibFFDG35UO+6StqoVkZ3Fd+zclvZsECjlrpaVoftWmhCFTBpTgaK7uwTrWYEZ0wMTc
         CWPrtwIc3H9iKbdHy2u/SCPEkpFulbSmc0dKRCvhb35lkIBNLX7cYASLAqqNR3UCDw2M
         P37XmY+dsPohKFaawAXJiNgOTBrfem9e9TrQmUAUP3Xg3jOnvUX17qSL2/GhwYKje3lQ
         oCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VK5tR6Myn0rdzrjWUwSngUiLXr6XHXBHtgosAt8owDM=;
        b=IWr7QYoqnEHfNTMuRLVtm4tVnYUQq0Sj5c9czToOsxrKPuoTBuY7WA3DXvGo1fL48o
         vqNCXgL/H70fL+ftDM1pnaInMpSpEEoD9qDlUeUUCaxmXOjA1jLdzdHgJclYD9+GI9ru
         vQuBQ/+YoG20KpwKKzlflE/jEuhe167iumsxphvzk+GFY+sEfjvVEUEM3iMW1uGREi/M
         UAOgK1+x253+B+0HUUAtoCP40SR50vzjtc8XogwvbHQDnAtFKBe83jvAtq+JH4pcrhJq
         CBive0BynxebjiOItIiD2RFngqXI4iklyQDrGV+gKOKVECaThxZ6ip9qIyMFIgVfSgg/
         NU0Q==
X-Gm-Message-State: AOAM532zWqtMI9fLLSxBErWjZ3AQ+W2yWlQ0yhSoMkPzFOKAYlKMTQsd
        HuRf5xsc67XBfkePzgP6BjPJMD8CNtUi9Pe1Gwf5bQ==
X-Google-Smtp-Source: ABdhPJyrJEfRRy4hE+fKBAWtMRTpry0IU4WzQQuDzJjUfaLQmW5rxaNRGbCOW629ZKnlQQlooz37n0IS63ioM4JbaLw=
X-Received: by 2002:a05:6402:3495:: with SMTP id v21mr13973861edc.323.1611843126031;
 Thu, 28 Jan 2021 06:12:06 -0800 (PST)
MIME-Version: 1.0
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 28 Jan 2021 15:19:12 +0100
Message-ID: <CAMZdPi_xQYooy9cDdf1Snen3A4OUbDt-6JScSuhWh5obv0E9iA@mail.gmail.com>
Subject: pull-request: mhi-net changes for net-next
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

As requested, here is the pull-request based on mhi-net-immutable +
mhi-net patches.

The following changes since commit d1f3bdd4eaae1222063c2f309625656108815915:

  net: dsa: rtl8366rb: standardize init jam tables (2021-01-27 20:21:20 -0800)

are available in the git repository at:

  https://git.linaro.org/people/loic.poulain/linux.git
tags/mhi-for-net-next-2020-01-28

for you to fetch changes up to b5d9e4f01c8110e50d3f5d49bc0efbbce828b81f:

  net: mhi: Get rid of local rx queue count (2021-01-28 14:48:39 +0100)

----------------------------------------------------------------
Hemant Kumar (1):
      bus: mhi: core: Add helper API to return number of free TREs

Loic Poulain (3):
      Merge branch 'mhi-net-immutable' of
https://git.kernel.org/.../mani/mhi into HEAD
      net: mhi: Get RX queue size from MHI core
      net: mhi: Get rid of local rx queue count

 drivers/bus/mhi/core/main.c | 12 ++++++++++++
 drivers/net/mhi_net.c       | 19 ++++++++-----------
 include/linux/mhi.h         |  9 +++++++++
 3 files changed, 29 insertions(+), 11 deletions(-)
