Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D900349465
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhCYOon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhCYOol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:44:41 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B38C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:41 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k25so2164281iob.6
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dmbiy8bt5dKb1N1ydrZrK2Erg+SC78sJKlK5EXA4En4=;
        b=qvDRVnHEF+1PQn0LPt9ySrCIWT0pC0Gcw9Y8cDz297IZ/UwAF79wU92nAVCx4ew6sV
         4ZQig7gWRpWHM3Qh65esaw28KL44SMYeCqtEDiP7g5mO+CzF3OYBV0kd0ytIM8CU2YP6
         NFSHxIQ4zVJUqYOdfo0DOMX27u1SpLu98iF8/KjZa+z47R+joji8Uv8s1pjTD56GeQ3F
         t/mYJk14gNtiAROrOpxfRohu6w4kKySLz6ZczPxumHnfXt/e6BEMo2IPOwRxHXgdbU4m
         yhvt89DSNME9BwfMJotAESJXDWdZlcWEOdZlGr91JFLGm1zgj7kwqG3r0X9RthHKcDFC
         vkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dmbiy8bt5dKb1N1ydrZrK2Erg+SC78sJKlK5EXA4En4=;
        b=H4kVT4Egjgo2R2X+aehd4GWEvw/yXfe7bbqw02WdPzGlO1uGqzs9wnlseAEeXmbdRj
         TdPziqdKkQ8Qsk+7AovL0AD8+IQMSX+5rVVUqwhL+o6pQQfmmWFu8xyg2ral1MOS9sBY
         UAa3e+zgDqxUnBDtWI1SKuLDssa30QJ4zRB9OvcabqA0YHXXLpgP/Plmres7f2zFlRjP
         PhaRNWHUOKumVwnBs053Qm2nT/grmmTRALEQtmM9eJu4HMVJm2Xmp7LucLeIC91fBXxr
         uDimle0YlTINCvZQhRy608cSGFjjMqQGcZnvHFzU0rv8W+WDENQ4Q56B7FnKxSgYREzZ
         nn5w==
X-Gm-Message-State: AOAM530eJWdGp9zyXxJyUIAm+Nr+gRNHow4C3xfn/jlFRAiWvjyeZONo
        uwejH5rNCFMbYYxJcuB1RnVUyw==
X-Google-Smtp-Source: ABdhPJxRcgY6KsKUpWGA3KvwfQmCc7ZmYEHXe783zw3JzlXfc0Vbec1EfzwaGmb59s7amTWvytTiRA==
X-Received: by 2002:a6b:5818:: with SMTP id m24mr6456659iob.144.1616683480987;
        Thu, 25 Mar 2021 07:44:40 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x20sm2879196ilc.88.2021.03.25.07.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:44:40 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: update registers for other versions
Date:   Thu, 25 Mar 2021 09:44:31 -0500
Message-Id: <20210325144437.2707892-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series updates IPA and GSI register definitions to permit more
versions of IPA hardware to be supported.  Most of the updates are
informational, updating comments to indicate which IPA versions
support each register and field.  But some registers are new and
others are deprecated.  In a few cases register fields are laid
out differently, and in these cases the changes are a little more
substantive.

I won't claim the result is 100% correct, but it's close, and should
allow all IPA versions 3.x through 4.x to be supported by the driver.

					-Alex

Alex Elder (6):
  net: ipa: update IPA register comments
  net: ipa: update component config register
  net: ipa: support IPA interrupt addresses for IPA v4.7
  net: ipa: GSI register cleanup
  net: ipa: update GSI ring size registers
  net: ipa: expand GSI channel types

 drivers/net/ipa/gsi.c           |   9 +-
 drivers/net/ipa/gsi_reg.h       |  69 +++++--
 drivers/net/ipa/ipa_interrupt.c |  54 +++--
 drivers/net/ipa/ipa_main.c      |   2 +-
 drivers/net/ipa/ipa_reg.h       | 352 +++++++++++++++++++++++---------
 drivers/net/ipa/ipa_uc.c        |   5 +-
 6 files changed, 366 insertions(+), 125 deletions(-)

-- 
2.27.0

