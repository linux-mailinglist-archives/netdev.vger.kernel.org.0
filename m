Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E29820F540
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388104AbgF3M6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387953AbgF3M6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:58:50 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE029C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:58:50 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w73so5735501ila.11
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sN4WZooX8Gl6AP3Ic7xgoU0JpRoYJKFZBAKo2Wp6GOY=;
        b=NwkdIgvIjDrjCiYlaFBEn/UOBG6CtDIWqacpay+y08rck5lFhwf4gT5B9FYNAs9vzD
         FZ0GuDIH9dbd2/SLh2f49YB29ERdOsffJMJ5QLVxnIfRQEmTswumKxjBEGP7wepW23pW
         SZi70uR/hx83eweAUeolnBUvimEOPV0tr8OMSXwZRUrWq4v0fa8NAqXMFbzteb5yoUr3
         9CURcA3baW0YtA7gA3GeKCpl8haPk/cEiTDO2qFCoLsdg275sVsuP4tSO+jNE6CFP/sJ
         SFXhMO19vFpD+sYJZZOx+yWlJb+w1pIah4ttOgI2X5PE28Ot0sRZIYsfUxIxhQmYWOiA
         b62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sN4WZooX8Gl6AP3Ic7xgoU0JpRoYJKFZBAKo2Wp6GOY=;
        b=VXR3eL56OBDm1FDKsvbs50wygNX6iEslTQsIHUPD/9+tCn05S5x59gH42G5kAw8eAE
         GsKiypdeVZPUUDDVD96s1WDdEjAyRv1xyt67Z9spWEbUrywl26SacWHAD34oE5fRqjwy
         FxBZhByljyKHTWzOE3wknVVRrjv9cdk/rcZczxeshNITn8YAwHJIgDfncKmX1Y1j8ikM
         dSqMpYvl7dFazvIs99Fiw5ijA0bBId9c5Imnei7UAm7JC0X5REdW4OhT3CE3HuzEyzuK
         2Jutje9tdJE6743akJ4eTpQh3lEMD8sdJ/ZSCfjiUTcgSl/VGMyBwZrQGKbOU94E3tU+
         AvVg==
X-Gm-Message-State: AOAM532Uap76MGn2h67LvmbLDBE0fs3L6iVeKf8+HTaGSYGzGXcZ2rMN
        3b+kwpjvL1ibqSVr0OlQRsPkcg==
X-Google-Smtp-Source: ABdhPJx9rT+fY5TiBPLJucFzrV8MGLXHE90n9Zw2yvlFQ2QJJpVgA91984J51C7l6guYP0Yj1hMFMg==
X-Received: by 2002:a92:10a:: with SMTP id 10mr2399769ilb.172.1593521930164;
        Tue, 30 Jun 2020 05:58:50 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z9sm1622588ilb.41.2020.06.30.05.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:58:49 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/3] net: ipa: small improvements
Date:   Tue, 30 Jun 2020 07:58:43 -0500
Message-Id: <20200630125846.1281988-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains two patches that improve the error output
that's reported when an error occurs while changing the state of a
GSI channel or event ring.  The first ensures all such error
conditions report an error, and the second simplifies the messages a
little and ensures they are all consistent.

A third (independent) patch gets rid of an unused symbol in the
microcontroller code.

Version 2 fixes two alignment problems pointed out by checkpatch.pl,
as requested by Jakub Kicinski.

					-Alex

Alex Elder (3):
  net: ipa: always report GSI state errors
  net: ipa: standarize more GSI error messages
  net: ipa: kill IPA_MEM_UC_OFFSET

 drivers/net/ipa/gsi.c    | 111 +++++++++++++++++++++------------------
 drivers/net/ipa/ipa_uc.c |  10 ++--
 2 files changed, 63 insertions(+), 58 deletions(-)

-- 
2.25.1

