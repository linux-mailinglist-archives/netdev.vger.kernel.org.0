Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8933E8D726
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfHNP0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:26:08 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:37716 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfHNP0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:26:08 -0400
Received: by mail-wm1-f44.google.com with SMTP id z23so4835589wmf.2
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 08:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YNZKomGx/ucQAaHefBlpZKplTTiXJDdJl1Fbv8ajoLk=;
        b=CAoQ/cHO0MgfSbZMSdiXIQz9SeMSfxzvkN4p3qgs4X5ho07vKDqW+ulPlLI89jJC6g
         barJpddY/zf0B1uQCcEaOLgLs7Y263yRRzgFqg5fu29PLA9AcaaESzW3gJuOOX3DJZYW
         /4cHxCbvIwdJ/jajtdOYotrIXO13pceDJvuekWckvMacfDEvwHFUcKKfgzw/jhfR3Puu
         qUP7RMokMzh6HdnWBK34YGc6o61v4EryUM4ms17gs31hZTrBu6vfgjCt5hgc/9WYdr84
         VAGS7gbSMg7qtJnNzJNz7FVYapx1mSN8GRem/Q9LtDnTgFjBycLzyPlhc22Nnro/VJ8D
         yb4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YNZKomGx/ucQAaHefBlpZKplTTiXJDdJl1Fbv8ajoLk=;
        b=mcbN+YAdgEQxOq8p1c6dV0/S0oYHr4CiL6RLq0QeJ6ymC1v3H274em2T5RXGVHNvSM
         l2vEI3baIN+AtPvp5n9E0SpecvQ1Qu26YNl19M3WergNssf0cH4uIA6zTff0bg0r0GFs
         Ed5C/n2zL51pWI3Wuc3QMrg6gBNPnXtNuW676UXTtX5FJfDmDE941OHaPS8zAJ7r5Fcn
         Sn0wKXNXUOe/y5HwysvQHpTRVirzzHDct+CVBZs8m5ce97u4XgLnpbCzawYMAxu2YHZb
         G6C6FC2NPHbVrf/pZm9mHe/CJDyuFDQygymvqmws38YTqvfeP6bTQd0DJahUYmmySOc8
         lkuQ==
X-Gm-Message-State: APjAAAWMbrKuHe0++86C01kaGcJhQ0g4S4kHGJqmaXiX/elKaICypWxU
        qRQJRQMjuEi/saRJ9RZP92KwHpxVsp4=
X-Google-Smtp-Source: APXvYqyTcmJgsp3LzLcklkNpLdze50dz4H5AIZ1iF8APNGcjxnyn/3eeCr/Ga9YN8Z8XgQFhIsszwg==
X-Received: by 2002:a1c:3944:: with SMTP id g65mr4342491wma.68.1565796365758;
        Wed, 14 Aug 2019 08:26:05 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f10sm90165wrs.22.2019.08.14.08.26.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 08:26:05 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 0/2] selftests: netdevsim: add devlink paramstests
Date:   Wed, 14 Aug 2019 17:26:02 +0200
Message-Id: <20190814152604.6385-1-jiri@resnulli.us>
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
 tools/testing/selftests/net/forwarding/lib.sh | 16 +++++
 .../selftests/net/forwarding/tc_common.sh     | 17 ++---
 3 files changed, 81 insertions(+), 14 deletions(-)

-- 
2.21.0

