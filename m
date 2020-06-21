Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51250202BA4
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 18:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbgFUQ5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 12:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730411AbgFUQ5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 12:57:08 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654A9C061794;
        Sun, 21 Jun 2020 09:57:08 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id j10so2387014qtq.11;
        Sun, 21 Jun 2020 09:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=ZKgh5VrRkI53I/DikrIaKRiawjmibG2W/wE03anJVnw=;
        b=iOvn2N/fqR26teEW4gZfqgukxfH+HF0sBaSnGIoWUawmxw6tg3l6/Ioxr0kRuayi/z
         JsHqHbB8xYieVBGNUnlAfxzzUICPhTKLU2jlMD5NdZ7/UoESDD04viFgutZ6aNmr9N61
         hDkZcbNngdGM9kw+PaUe1z2nZi4YOXRd1fTTrECWtM/WEXC3104bg1LA+fsl4kUxVROC
         lJb3TlhmucUZ4EGSVIxNa+A5NHplXboSbJCcWJ7Fkn8x+7sNlJYSJ9O+fnPy6ECpEVpG
         jof98PGEWcxamd1sV/h69WXgi49Ga+vVlq47mFi4Kd4rCRq5s0DC9gyVimqXtrmQY5Dm
         6w9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=ZKgh5VrRkI53I/DikrIaKRiawjmibG2W/wE03anJVnw=;
        b=dUW9Vp0t4xZx8OMFgnCgeJwOwu8FFhQvjcvZxHRoQWMmcKjwy9t3UmWZrqiPubW15J
         DNNTU8hlfRKZhBFdb80cP0d9mv72aDvCVgFFLWnAvNznN2ArhVZBnx1cvW8BEbbxTFS4
         xPlJ5E6MA3w/ExB4E79b8adlBzzxlkTxGEvWK0KXpiqD1aS7TAmC5vOmaNGWominu0Wj
         Snxv/ryR5NHR7mH7QizW/Wkvepf+oMXv/vg9pe2OJiEiOpt9xMIUECDflc6llCl5iIR6
         ZBqv7xTuo8UYabrCRBkyKOb/7ZTV+1ORuxlE38iLaG5+klgG95JerOMcs2mWmM1RaEXu
         VX7A==
X-Gm-Message-State: AOAM5334GBZjWU8MZFU5slBIXSRUcghy4NcdhryfLj74gh4tqB0rfBZ1
        gfiMkCj4U7+T8/psSKpKKOk=
X-Google-Smtp-Source: ABdhPJzR4bIL1kX8aj+3TtKAudxmsnoL+9oEcagU854TYUK9FSeX0338S+VfM0osn6SpnV07vhEAHA==
X-Received: by 2002:ac8:3908:: with SMTP id s8mr6338156qtb.97.1592758627505;
        Sun, 21 Jun 2020 09:57:07 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:c0e3:b26:d2d0:5003])
        by smtp.googlemail.com with ESMTPSA id e16sm13464489qtc.71.2020.06.21.09.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 09:57:07 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net] dcb_doit: remove redundant skb check
Date:   Sun, 21 Jun 2020 12:56:28 -0400
Message-Id: <20200621165657.9814-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the redundant null check for skb.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/dcb/dcbnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index d2a4553bcf39..84dde5a2066e 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1736,7 +1736,7 @@ static int dcb_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_device *netdev;
 	struct dcbmsg *dcb = nlmsg_data(nlh);
 	struct nlattr *tb[DCB_ATTR_MAX + 1];
-	u32 portid = skb ? NETLINK_CB(skb).portid : 0;
+	u32 portid = NETLINK_CB(skb).portid;
 	int ret = -EINVAL;
 	struct sk_buff *reply_skb;
 	struct nlmsghdr *reply_nlh = NULL;
-- 
2.17.1

