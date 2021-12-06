Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C847469140
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 09:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238978AbhLFIRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 03:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238917AbhLFIRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 03:17:23 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45279C0613F8;
        Mon,  6 Dec 2021 00:13:55 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x5so9504135pfr.0;
        Mon, 06 Dec 2021 00:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQ00ky2Ne2VJ/9bg5G+lrrgYhyU3nnQstVQuNpHAyxg=;
        b=e2chXaS377yk1sxO6XO3/pETNgP7JYsITbLM1gL7t/eY3xGt5WRJIJzbkjWrX82gKv
         acsDOE1zNhz3jYOQclP3lt6dWJg8/Pm8liExGSfIu5IesfVz71TTBVqwcGlFDHjh5Dxw
         6CZcn5SxxAy0+ZCqQW5EzngehSQ9THc/AMJHp1scYUdB4MtNkhjMXzTZ8bbn53gBuWkk
         DlbefndgJQApqzm6dmxN/DEoNe8kyFAvrVf29MKHohxyxiw+4n/EAXw4dVqZ/5S/geLH
         Y5x1bE2UaHXhbItatZDMRM7rMOKba88xYJ4F5P83Baxn85Dd8kyPRIX38h+jXyVdqZxU
         kv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQ00ky2Ne2VJ/9bg5G+lrrgYhyU3nnQstVQuNpHAyxg=;
        b=vo6JQTMA/+6lrtbZP0pJr17+4z9+upYwu75qz6mUfX5UYDGVb9F4s9OYzpCAwMtCrl
         FYFWrEhCQ/INmkg1ok25SLdFXq0WkHV98ewh3qDVyvYIDEKgoyaZIqK4evme+69tp+NG
         8P3oi5k3lcUUTz5XeyTc2xxEhyZzLzDOplKTL2aWYx74p+Maaj+fdaR6n2mcHc5Qqq3P
         1Cv65c68c2v4cg9bdQYIS8gFbv9wShynHst8Rtij9rrcP4u1ftYeND4KkVNaNcD0Piu3
         nwX9Sr2wSV6mApj+ZhWLiWeygV8Gct1pQ2a5rTdVItyOo7F1utyqEkUWEDoQ8eS3TLdY
         qYRw==
X-Gm-Message-State: AOAM5332WVZjYHb8S2aGcT5dhpqpjoDi5Zj/C6Ps4EDTHbCGSpRE2AMp
        TiIGvM5MWA184WeOLNY58fQ=
X-Google-Smtp-Source: ABdhPJxfDoBSvz/k2kiY28HuJX4XmRlwrFcheVwIQFS89onAX6UoVdor1i3hYZmL+s7I+eClRr+6eQ==
X-Received: by 2002:aa7:93ce:0:b0:4a8:19fc:f024 with SMTP id y14-20020aa793ce000000b004a819fcf024mr35570878pff.10.1638778434834;
        Mon, 06 Dec 2021 00:13:54 -0800 (PST)
Received: from localhost.localdomain ([8.26.182.175])
        by smtp.gmail.com with ESMTPSA id 95sm8999332pjo.2.2021.12.06.00.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 00:13:54 -0800 (PST)
From:   Yanteng Si <siyanteng01@gmail.com>
X-Google-Original-From: Yanteng Si <siyanteng@loongson.cn>
To:     akiyks@gmail.com, linux@armlinux.org.uk
Cc:     Yanteng Si <siyanteng@loongson.cn>, andrew@lunn.ch, corbet@lwn.net,
        chenhuacai@kernel.org, hkallweit1@gmail.com,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        siyanteng01@gmail.com
Subject: [PATCH v2 0/2] net: phy: Fix doc build warning
Date:   Mon,  6 Dec 2021 16:12:26 +0800
Message-Id: <cover.1638776933.git.siyanteng@loongson.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


v2:

* Modified Patch 1/2 under Akira's advices.

* Add Patch 2/2 to fix warning as:

Documentation/networking/kapi:147: ./drivers/net/phy/phylink.c:1657: WARNING: Unexpected indentation.
Documentation/networking/kapi:147: ./drivers/net/phy/phylink.c:1658: WARNING: Block quote ends without a blank line; unexpected unindent.

v1:(Patch 0001)

* Fix warning as:

linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:543: WARNING: Unexpected indentation.
linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:544: WARNING: Block quote ends without a blank line; unexpected unindent.
linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:546: WARNING: Unexpected indentation.

Yanteng Si (2):
  net: phy: Remove unnecessary indentation in the comments of phy_device
  net: phy: Add the missing blank line in the phylink_suspend comment

 drivers/net/phy/phylink.c |  1 +
 include/linux/phy.h       | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.27.0

