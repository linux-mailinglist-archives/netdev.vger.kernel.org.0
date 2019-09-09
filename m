Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CD6AE121
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfIIWh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:37:28 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41514 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfIIWh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 18:37:28 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so7372400pls.8
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 15:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eint4nhfCiEnji9TBmfOSvGzwj5ZKI3qj6Kalnk/SmM=;
        b=bE2Y4D/OOjzjoXw0mx+BiEJSrzyC9l7jB036lYGT38qcnYHDvmdrFHJSlo0vj68jhm
         saoQFTQUHCRZZxAJX6iXShzgb0p3F0TVIFFSeoetDO98pOjfA3GNr/V4QHzFSmn5bVyP
         ai3AHVAaHGctkSdj8RX6jPDH8bp1w6LqvuXjEa/wQNgasmFTnHe+RsqjGztxKnLAuH4P
         U9otBxA+rJ3laVM8RlxQuyHoJon5QQ6kac2uyTSeAKJmj8oNb83nOw7KsX/3I7T0BEAM
         yB/bspiJba+2Do8zWwDoytdtWlph5L7tZrJbeOJtPCW4528/73a7YkVSNKwdrOvZC0+3
         GbfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eint4nhfCiEnji9TBmfOSvGzwj5ZKI3qj6Kalnk/SmM=;
        b=P9hhk0QjSPFCVRIUrAfaVhRH34+V6hupERKmu7MyAZJwjO3Ve+YLfAZVqCtRD4GQQs
         BPY4CWPuaZ7rocDrhICskzlIjx8cVnStv0OnLik/MCr+Vrs3Te7a81vVhPNA1FAQeT1Y
         5HIOvLLtc9cFlqxw1BXUs/jp2SfERlqqqagyZTvCfSqPzGX8Po2IGPEUrRTFU4OuLpn3
         sLmG3xqDWCRvf5Og/+X6o7bJfybhIUnL648e76EOO5QrwveKWCK9vqoZTuIbo7UDJlRJ
         StXxd4JZAg9tgrk18oV/UXc5jAkY1Nrs5J4AsyCvcXGHEik9qCE1wGvJcmuL0SbBOGS1
         RcSg==
X-Gm-Message-State: APjAAAWjIcYK3b98f3uaUOXKJBGm1xIlVGM7o3EnH6jBEWU4XgipyFc1
        682Zjdn32V5pLp6iOr4yB/yIxnTrKJbapQ==
X-Google-Smtp-Source: APXvYqxO87b/3lfZiwxls+JIcEJsMIPyu/p1zKX50OtZ3owTGESN6xJ/YTITNzcCWU9M25WiPmBP2Q==
X-Received: by 2002:a17:902:fe01:: with SMTP id g1mr7585398plj.178.1568068647439;
        Mon, 09 Sep 2019 15:37:27 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id q204sm16186732pfq.176.2019.09.09.15.37.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 09 Sep 2019 15:37:26 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: [RFC PATCH net-next 0/2] more IPv4 unicast extensions
Date:   Mon,  9 Sep 2019 15:37:17 -0700
Message-Id: <1568068639-6511-1-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support in linux for the 240/4 and 0/8 ipv4 address ranges were
easy, no brainer removals of obsolete support for obsolete
specifications. Has anyone noticed yet?

The following two patches are intended as discussion points fot
my https://linuxplumbersconf.org/event/4/contributions/457/
talk today.

Dave Taht (2):
  Allow 225/8-231/8 as unicast
  Reduce localhost to a /16

 include/linux/in.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
2.17.1

