Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8E044D3E4
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhKKJVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbhKKJVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:21:04 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFAFC06127A;
        Thu, 11 Nov 2021 01:18:14 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id b68so5069859pfg.11;
        Thu, 11 Nov 2021 01:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LjO7/fZn8A4IMe1GMP9m7bCzLwYikbXUyytf4mrez9I=;
        b=V1HNfvZ2U0+GPbyim+Kquq2OpFo6MTL7U1sTyfO9l//Vdqxn3/GEjWHaK3qHOluCKM
         1iT3+STWT6gBV1QU8fkNMye7i60ccrJL5PpAfOG8LCjQSmWwztH5MLpyBDXqTmqZHHQG
         qmcxvXC+lVdk84bWi3TI5aXd9n3UT6UCPUoz8048ePkmjMvowScbI9iEjucfXPeQGFYT
         IC5bWeZdok9G8M6AAoVf5Mf6TrVHgb0q5jSZz7iqf2rsYQLVEOo7VsElhT4y2XYAX/1y
         JXKN/6lK/3JfvUrHGUhwuH/13U3Us/n3Dop/lvQGat0gxlSQumxWmrQVhDwGGoCaozKU
         gUOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LjO7/fZn8A4IMe1GMP9m7bCzLwYikbXUyytf4mrez9I=;
        b=8BlQPNAiNoeKhEHxMRASGLdcmdeaUXUMyQXHr8vt0xdnc2TQfa9waLpcWZg5I+fDZf
         Mln/bT9wciDydBmgGVr5oN++I2+HR3mOiemCq/gynPVR3nzNvJcigSllwvK5ApozhIHF
         RBqb2+9uLguFtJibS4qqpKJ6rEyAj2fdY2jzixJFITBlozvFQq6rrvRXMl1IJM01q3h/
         mCbSGOkgEMKO7WpOc7rEK5TBsDpiXPtBj+WVsZ/LBCi0ZJX/4etWmF6MjMONYjOTA4Bi
         A/5EQqu5ZWJr6rYGgVl+satYmALg/fTe/QuUiVx/Ap86/Yf01+UXYctnz1GNQbL6hWMO
         ZtMA==
X-Gm-Message-State: AOAM531qmoGd8FEoLBCgvtSbrb/cIkStQDrhpUQg+1evgaankmTf2Oxr
        uCI50DksPKkfHCFbmpehUHJan+Xzv9Y=
X-Google-Smtp-Source: ABdhPJwisArS43Uz93uj5pf2J2ZmQmsWA5250+ed2chujObe4GEphMp/fRmHAuFOU1Luib+EXkvy1A==
X-Received: by 2002:a63:63c1:: with SMTP id x184mr3585330pgb.401.1636622294165;
        Thu, 11 Nov 2021 01:18:14 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u2sm2233225pfi.120.2021.11.11.01.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 01:18:13 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] ipv4: drop unused assignment
Date:   Thu, 11 Nov 2021 09:18:09 +0000
Message-Id: <20211111091809.159707-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The assignment in the if statement will be overwritten by the
following statement

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/ipv4/igmp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index d2e2b3d..2ad3c7b 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2558,7 +2558,6 @@ int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
 	msf->imsf_fmode = pmc->sfmode;
 	psl = rtnl_dereference(pmc->sflist);
 	if (!psl) {
-		len = 0;
 		count = 0;
 	} else {
 		count = psl->sl_count;
-- 
2.15.2


