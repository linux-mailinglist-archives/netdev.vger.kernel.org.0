Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3888391541
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhEZKqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbhEZKqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:46:44 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF010C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 03:45:11 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id t206so460399wmf.0
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 03:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9MLmJByVj2TIVzcs6s0SLW2aMc3U99lPiWZfFi/BdnQ=;
        b=z36NsX/2HzkHBfvuFFumODYjmlU0Voq0aQsNJxcPs6H3YWM0Jywa9mH+BqXdLT6HnW
         fsFa66QWJVcu9wCs+xvWa576QHRgvgHTwpBF+THAIprfn17FcfKdCf4CXysr81MBO9AK
         CH7iKIPG6R0UZzAIJFVEAFZv1vOW4mXlxJmhh+FpflbRD9iIAqUDm6AF6yob8XjFRkrp
         xt7X0j2XxlFyd8RB9eCeH8GnJO8Z2dT+akx2tBjJYgYXb9CUoZDrRZ4WrUlg5+G+WM50
         IACAj5X7YmRRpDRT51gvQwyjrPGsS9Y0GrsHp8rzfuFA22u2bfL9pX6FNqNcY2d4aHrx
         URcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9MLmJByVj2TIVzcs6s0SLW2aMc3U99lPiWZfFi/BdnQ=;
        b=S5GJTACP9p/RmbthZkOunV+ng7Wloi+H1f6WPKh6SmMH68WZeIOFt/V1zlW00YHn6S
         gmd4/h4HX4ZZqEp1b+yihcyME872EqCL5LonDsKN2EC85+6v4/P6dGl+HA/S7gULTOD9
         dDdHEPW3VXO5a09dXnlzZL9aQY4T1UXZlthUifbvw/bByYtfG0P0hM9Bwf+BuHUfeB06
         R5nFdtgpAutmQrdyiRFidVQ3z3PrsM3CvBW4GmfnVhsfX0fuLl8yV8+6MZZ6KmIRF1ez
         qJGuz2wc62eDH1G42k08BWgL6KzxnwsR9v/Rji7Ufpvx3vQ8Xdc41eh9+lvjypF5259Z
         qlcw==
X-Gm-Message-State: AOAM531KZvVd9gUMhdz4B/kFML63XenVgpD7tSmXDErH0vA5145gOMzo
        Rr6xcn0HUPnW+wBEmLfxa+5FkbyB3qDEpSWbmDE=
X-Google-Smtp-Source: ABdhPJy+ahJbOTMCtwiXDnUM27TdNA+4TnsURGApKhYpiL1nbPvno20QOpELlUdkiECzvLvfkbBesw==
X-Received: by 2002:a05:600c:350a:: with SMTP id h10mr2775059wmq.154.1622025910425;
        Wed, 26 May 2021 03:45:10 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id r11sm20246846wrp.46.2021.05.26.03.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 03:45:09 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        idosch@nvidia.com
Subject: [patch net-next 0/3] mlx*: devlink dev info versions adjustments
Date:   Wed, 26 May 2021 12:45:06 +0200
Message-Id: <20210526104509.761807-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Couple of adjustments in Mellanox drivers regarding devlink dev
versions fill-up.

Jiri Pirko (3):
  net/mlx5: Expose FW version over defined keyword
  mlxsw: core: Expose FW version over defined keyword
  mlxsw: core: use PSID string define in devlink info

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 10 ++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core.c        |  8 ++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

-- 
2.31.1

