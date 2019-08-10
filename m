Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7876288733
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 02:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbfHJATA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 20:19:00 -0400
Received: from mail-qt1-f176.google.com ([209.85.160.176]:43095 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfHJATA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 20:19:00 -0400
Received: by mail-qt1-f176.google.com with SMTP id w17so16922006qto.10
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 17:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l90Cc9SU6Olx8UAftJaEaDn8294kEt6Y2l5qLNNQUSc=;
        b=ZICpQ9Th3iBEvK1fnU50o1UAMrZk+QDQWZuJ4IEggrnYy7O+tAXNwGpJ3cuxdlurjy
         05YR5mTBo42GZtLiRyAidYyDsWZQbpNuwEsgOf2JApIHCvHtUbceCzlBqwQz9T/U4qo/
         TeciwvZqhiSVFEm/vuZjDeFqFRUEsvoR55I60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l90Cc9SU6Olx8UAftJaEaDn8294kEt6Y2l5qLNNQUSc=;
        b=ZLOGvJuRBZmXE0k0UIvKCzn9QEl9JG0ffGcNFLM5FmdsJCNmLNWxV3YdAFCiMbH0XM
         SLACCkmr7q7E0+v00TTmE2twQqgRr7LM67bXmhfB9t/jTP4ZRSkYEPg0k9WBxSPt2lam
         /X5iY1qeV2GzRIuM+UYb9/eYQ4uM2B3krTNG77HpaaTnihrXuJoK7jRgdPydLcIPIJzm
         FFqunskrdnZ2ZYkqbjnM7tSOabk6cPuocoOWMmkCzmB7rMx9vruS/L0LaYgfQ2DHzynR
         82W3obV+PxN0AQNkmIMqD7mDV8XI+XK1dcPQ0d3Bi47pUEk+7nUWLh2lI57SRzz26gWD
         ISYw==
X-Gm-Message-State: APjAAAWF75as0ro3TikxRM8cgqXgh8DkIBGKs46xmAXvj+d1zitA/HhJ
        qbJSxJ0MRUciV3QPnZ2JbHW2rm7njD4=
X-Google-Smtp-Source: APXvYqzhWPcczJnPqw0jZwp51B+s3FwOsLU0Tuq+AxjNv54DWiRAubTG/N8zht2HHz4UJ3GXupF3OQ==
X-Received: by 2002:ac8:1106:: with SMTP id c6mr19326869qtj.332.1565396339296;
        Fri, 09 Aug 2019 17:18:59 -0700 (PDT)
Received: from robot.nc.rr.com (cpe-2606-A000-111D-8179-B743-207D-F4F9-B992.dyn6.twc.com. [2606:a000:111d:8179:b743:207d:f4f9:b992])
        by smtp.googlemail.com with ESMTPSA id u16sm1230497qkj.107.2019.08.09.17.18.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 17:18:58 -0700 (PDT)
From:   Donald Sharp <sharpd@cumulusnetworks.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: [PATCH 0/2] iproute2: Improve usability of `ip nexthop`
Date:   Fri,  9 Aug 2019 20:18:41 -0400
Message-Id: <20190810001843.32068-1-sharpd@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch fixes a spacing issue and the second patch allows 
the user to filter on the specificed protocol.

Donald Sharp (2):
  ip nexthop: Add space to display properly when showing a group
  ip nexthop: Allow flush|list operations to specify a specific protocol

 ip/ipnexthop.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

-- 
2.21.0

