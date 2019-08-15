Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D3F8ED26
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732426AbfHONmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:42:33 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:34992 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729918AbfHONmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 09:42:33 -0400
Received: by mail-wm1-f49.google.com with SMTP id l2so1297907wmg.0
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 06:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xl/LJCMo6v5+MB+aONmN3VPaNSHCs5z1zHdgvddUcWU=;
        b=kJZlft0noJzN6/CD6ieu/muAGIzO6tF9X9KgeXKHo+ADkreqoD97Y1NmpELrCkSi7z
         zPbeLMuPvZLYHZr6B6q1o1odP8E530foo3fp9rpM1yfQYi89e2xS54wVnJqlt7gfGBh7
         y+IoGUBLlXOOL1RBpMejk2G0LmSa3SDzKvl0lq+KBKIxdGiHiShf9KgZO0iPFq54GgAH
         DSHLlWKQS3e6R7KkjiHRUrzW13HH5tMMXYiQkOhWzFs34aSfcqUWvyT58zC/lRxuW3ag
         EPntDP010sMH5LicnTTZi9stQO6WbhLB447kI+IjqPJ7VW3hkThpyPUWittfUdYJwTKU
         x1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xl/LJCMo6v5+MB+aONmN3VPaNSHCs5z1zHdgvddUcWU=;
        b=ZLT9ewHEXJw0HsaMlMWCRjowEkumXoUsBluxOg1XPxV+z9QWfVnTA4UY1yKD8CoE0Z
         OpzhNe6sFap+M3UYs5jUUrJRCBhI5at9GGBRddcFY0A67a9pxUodHT8/zSvo5kMxOeqp
         CNCzbLlgpNfk6IGDo4CakTqhFz5VmnSi2ZLfrHgf5h6cgUi7qdJADgcOk5yrRPR6K9f1
         flWubqygcORl4ElCH9aLj0W9Nk+znLpOR9uGH7fszYGI//YNzWf5P4P4Ccp/fgOck3rK
         6H0HHVvKwYh1heEycQSrF/dyPFABWa/ps58nOqDaTKPRH5da7xfW7mggwQpIrzcoz2jM
         7oAA==
X-Gm-Message-State: APjAAAXbF2Yf+XHoGYVxY9A+tiZwJLDnNYHJn07whbsP6Cu1/oiF8/Wb
        w6qT3wJK501Aat/zpWkxtKjemAKLVZQ=
X-Google-Smtp-Source: APXvYqzuQ5P7jZ02WwYU2YzQLRIchVV5LBNXvvKJxZKDBj4HDJC0q7p6QyJ+OMIUNRpL0ryTC9VIxQ==
X-Received: by 2002:a1c:61d4:: with SMTP id v203mr2972984wmb.164.1565876550814;
        Thu, 15 Aug 2019 06:42:30 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g14sm4925864wrb.38.2019.08.15.06.42.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 06:42:30 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v3 0/2] selftests: netdevsim: add devlink paramstests
Date:   Thu, 15 Aug 2019 15:42:27 +0200
Message-Id: <20190815134229.8884-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The first patch is just a helper addition as a dependency of the actual
test in patch number two.

Jiri Pirko (2):
  selftests: net: push jq workaround into separate helper
  selftests: netdevsim: add devlink params tests

 .../drivers/net/netdevsim/devlink.sh          | 62 ++++++++++++++++++-
 tools/testing/selftests/net/forwarding/lib.sh | 19 ++++++
 .../selftests/net/forwarding/tc_common.sh     | 17 ++---
 3 files changed, 84 insertions(+), 14 deletions(-)

-- 
2.21.0

