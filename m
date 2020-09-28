Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84A227B79B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgI1XNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgI1XNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:42 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1326DC05BD09
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:51 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id k6so653276ior.2
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+7dZm4XarjDGmNj6mEeY9lZjDxqbv2ERHcjckqzeJOI=;
        b=P0X+NETBfSw8rqVOOH84xeeFDpFRRaZ4svHpY+AlfKKn/OOGSm4IPArCPeZnx9hU7+
         1KEyLUlNARAbQSvfLTPLsfy8xztUblCkuyaKmKdnw4rtsFveCKJ7JXoeUkDHqYAWh0Gp
         2c88+fsb4T39mQj910e477loZr7RuRVWHT0ipS3hn8t8wMyZjkM1nyHP5811nCPrCPaW
         Yi4qpVCF07pa1Mmmns08QndEW8mppOrOXNLJ99jqG7V/i6EnbKCan8H1TsYM8ZQEx2df
         ZDDEnisVBc61x08U+iQVdo/dFULKzmUIXqqL3MeO06QNDkEB81pfMVhqogZ2LPbK+MeK
         rKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+7dZm4XarjDGmNj6mEeY9lZjDxqbv2ERHcjckqzeJOI=;
        b=iA9QL+h0Byy3RzW1wm0ThAo54rRIKHEH7M6zJgr6A3mzJC/tppwV92M6b6nT4P3+GG
         UvFRfIDwFwQKYS/difaH9u1Gf+X8cgX0wLX83UwQB6VNqd8SOSxT2OzLHbH0ncEUDmt1
         8jyX54nqdYPTw5fsvxjzkJsQ5QqEOD2sBEvWUNBjb4O7a7/wHxdj7VAYQw+lbmUuRhZU
         pVaBF51lu/ZTkThSkvZnMLrcNp7q4AJvfGl9oJfU8Oa04yItj6SFh+yEmhMyj8awYz0O
         jNaVYpnntTIMHok2JRbv5huILioAxiiid5fiJIzrRNBPJ3Xu+Zmg1G0ehIgcSuyDYGc9
         IUPA==
X-Gm-Message-State: AOAM531Ak4aBGCljMY9pIexEBOAAp9yfLrThRj58EDiKeKkLlUOhkMZl
        SPjHy46veiGvq+9dFe5fBhJTeg==
X-Google-Smtp-Source: ABdhPJzBJTGFdRsDvhXQZrdKhD2lZVVDBE4o2J7VuSmcwxy3n8Gkec80e2BssnLEUB812suplGpp4w==
X-Received: by 2002:a05:6602:218f:: with SMTP id b15mr406692iob.8.1601334290293;
        Mon, 28 Sep 2020 16:04:50 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 137sm1009039ioc.20.2020.09.28.16.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 16:04:49 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/10] net: ipa: miscellaneous cleanups
Date:   Mon, 28 Sep 2020 18:04:36 -0500
Message-Id: <20200928230446.20561-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains some minor cleanups I've been meaning to get
around to for a while.  The first few remove the definitions of some
currently-unused symbols.  Several fix some warnings that are reported
when the build is done with "W=2".  All are simple and have no effect
on the operation of the code.

					-Alex

Alex Elder (10):
  net: ipa: kill definition of TRE_FLAGS_IEOB_FMASK
  net: ipa: kill unused status opcodes
  net: ipa: kill unused status exceptions
  net: ipa: remove unused status structure field masks
  net: ipa: share field mask values for GSI interrupt type
  net: ipa: share field mask values for GSI global interrupt
  net: ipa: share field mask values for GSI general interrupt
  net: ipa: fix two mild warnings
  net: ipa: rename a phandle variable
  net: ipa: fix two comments

 drivers/net/ipa/gsi.c          | 15 ++++-----
 drivers/net/ipa/gsi_reg.h      | 59 ++++++++++------------------------
 drivers/net/ipa/gsi_trans.c    |  1 -
 drivers/net/ipa/ipa_endpoint.c | 47 +++------------------------
 drivers/net/ipa/ipa_main.c     |  8 ++---
 drivers/net/ipa/ipa_reg.h      |  2 +-
 drivers/net/ipa/ipa_uc.c       |  2 +-
 7 files changed, 34 insertions(+), 100 deletions(-)

-- 
2.20.1

