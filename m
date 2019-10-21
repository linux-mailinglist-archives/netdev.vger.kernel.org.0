Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A82AADEF6E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfJUO0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:26:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34905 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfJUO0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:26:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id l10so13822894wrb.2
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 07:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k9OhaapLttbgrLG0ujYxke7ZpYiCgwq26jLFElleNIc=;
        b=gByG6po9YkNMSAHqHObfovww9m7+TM5QrxSpHSl72D88zbDQgQ26tAO2Y0TpqI70yC
         9WYt3DcV48qFkvLf3fsQRbND7/UgSdN9e86br7M/ixVPBr36VMFTtnp/zOyFqfOIUEr9
         K9Y9iWWsrY1yPUhW9rz8DqghZPUMFBUTb9wiYAZLlfv1EPvNtA7+rKMic/f9h1kDpzHv
         VElshmfcs5q4eXAbs/b44zARZzs337uKTpLHtzS5FLjROxl7LeblWislBx+LW5jWaQ8m
         Dt/03wN5sj5Ybu/bhirkS7RfkSYPBS0vNE+U1ZGlcb4RNy2dZ8nGU03hG6WJhcut9wxr
         BCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k9OhaapLttbgrLG0ujYxke7ZpYiCgwq26jLFElleNIc=;
        b=lt+o+KPfMrwnI7fbNspLDhdPO+k5eX8LKK4omMAbPKD8/NF6u4vbTEWRgykbJFwUXQ
         pmb9sUwt1Gs9fQfB+t+Nj8qlH/hdljWFH3FyCP4BqT/kDSAtEWcNGFfse0UmePE/eCtW
         76ghLuJTUcO5CsmNECz/MA6dhBLcJCaY2spTs/tJxoZdjX5XALvL1uWV+CcoVPcT9Vmx
         7DUC3GmY9u8da9R8KVmHH5BOQWlVpvIW78k8jvdoT5/X0WAq7phE8v8qoJ9QfR+2z5q8
         WkXFNNHuGhZy2c63PF2RJbDoDOI300Tqm6YvWFDlyvAo5yiDinWX/1qithNzrduZnR52
         G+QA==
X-Gm-Message-State: APjAAAWRJn1t3yhVD6kFPgxWUZGpr37471L6im6FVUK14jA9SEBxt9Rg
        1fq0DxTHGUCDMdpi96vAsRrDMTm+RyU=
X-Google-Smtp-Source: APXvYqwYK23UCoVZyeZdC9C8sFS1MSuc6iYqRE0XP7L8fgq4jJiZiR2+yMwwxeeUwy44MEIA9YKHCw==
X-Received: by 2002:a5d:5587:: with SMTP id i7mr20490331wrv.289.1571667974720;
        Mon, 21 Oct 2019 07:26:14 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id i3sm11192130wrw.69.2019.10.21.07.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 07:26:14 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: [patch net-next v3 0/3] devlink: add format requirement for devlink object names
Date:   Mon, 21 Oct 2019 16:26:10 +0200
Message-Id: <20191021142613.26657-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Fist two patches are just small adjustments to fit the format required
by the last patch.

Jiri Pirko (3):
  netdevsim: change name of fib rules resource
  devlink: replace spaces in dpipe field names
  devlink: add format requirement for devlink object names

 drivers/net/netdevsim/dev.c |  4 +-
 net/core/devlink.c          | 85 +++++++++++++++++++++++++++++++++++--
 2 files changed, 84 insertions(+), 5 deletions(-)

-- 
2.21.0

