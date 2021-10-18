Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3531C431301
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhJRJQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbhJRJQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:16:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC0DC061745;
        Mon, 18 Oct 2021 02:14:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso6500924pjw.2;
        Mon, 18 Oct 2021 02:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oFAbXqA6zWIIm+vWnBjNCmD/eug6wi9LsU8+kOasxIs=;
        b=Wdh7lBDdAWKD8/k/eMS2KuccvGhdKK2S+VohP4+icKxaCmTiQ/di31bTthWwOFNoLo
         hCm0qZuR/eP29cVCow+00sNwe4npZ9k8VEZ1oxXTpa8gpsfYi/clbBR361mHX1Y8j9Ai
         PAU7kgk3YH/RzKsw7Okmuq+JyP0E1LS2IEGG/4kWdtY5t4Cs2Ii54NlEZrmcj0KYqdov
         U5OtSbTNtNoAq8OHCsc6xABuTiCOStOTFvbQJI6DCXek98kc6KwiYPewUjZeYHtfLio+
         QuXZY4tigaEgSmWR431nE5Fn7FAE6zAr0pyYcnJpM4PIbVg+mrLqJqeBj2mefob5tUj8
         UtWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oFAbXqA6zWIIm+vWnBjNCmD/eug6wi9LsU8+kOasxIs=;
        b=mYafZvFXot7WuhqYKOSgJTN17dA5wtiqtvI9x/VZ9Bm9YxaFYrdQ1/Zog6Md5Xabpv
         YYxfHQWLp86XzS0fSL0Iw2PK+nE2cErBj2TrkqfxIRokX4rFSaHHgc44u2FTFSM1sPv9
         HY5UFkHMfy7/wWcNsBx6DayKQ7+flNrLMJVmA4yXoWwBM2HC584eoNyzBEx5KKygs8d/
         nz8B2WSxPAX05kpylM4eyrpea3V9gxOvpTbhMffwmSgU2YFp5CDXheYHm98hjhnWz9oN
         Eph2rZ1q0o2vHD2lE6RnCo0PZwnW+IE9eRgucLp7ZqYdS5n5EZEvX2d2n379TeqUqPw6
         qoVQ==
X-Gm-Message-State: AOAM531AOHM1UkpJTqVgl9MCHoGa7GbB+lAXkGiusxDInGtNSvW1c9Or
        fXRD6Gozs7cr9A/A2Bd5xkA+VITq4yo=
X-Google-Smtp-Source: ABdhPJxYeOZW916ZhLvxOrYJSceadI+yLzBOrXglPM4F4+L8FECKrpKNUesLSORLd5CmFxEm5fIJug==
X-Received: by 2002:a17:90b:4b10:: with SMTP id lx16mr31927942pjb.217.1634548440694;
        Mon, 18 Oct 2021 02:14:00 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x23sm13146856pfq.146.2021.10.18.02.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:14:00 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        penghao luo <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] net/core: Remove unused assignment operations and variable
Date:   Mon, 18 Oct 2021 09:13:56 +0000
Message-Id: <20211018091356.858036-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: penghao luo <luo.penghao@zte.com.cn>

Although if_info_size is assigned, it has not been used. And the variable
should also be deleted.

The clang_analyzer complains as follows:

net/core/rtnetlink.c:3806: warning:

Although the value stored to 'if_info_size' is used in the enclosing expression,
the value is never actually read from 'if_info_size'.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: penghao luo <luo.penghao@zte.com.cn>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 327ca6b..52dc51a 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3804,9 +3804,9 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
-	size_t if_info_size;
 
-	skb = nlmsg_new((if_info_size = if_nlmsg_size(dev, 0)), flags);
+
+	skb = nlmsg_new((if_nlmsg_size(dev, 0)), flags);
 	if (skb == NULL)
 		goto errout;
 
-- 
2.15.2

