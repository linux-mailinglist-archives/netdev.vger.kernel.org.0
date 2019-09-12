Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6902AB0DCA
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbfILL3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:29:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35457 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbfILL3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:29:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id n10so7228194wmj.0
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 04:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u0wQXtlUepAD13MrfASSxGEj5MVfg36xcebgm37Y6GY=;
        b=pvUoCfADpegGym/W/hY1akmoUjL8pjQCnfbXaapLLk1ggHsuu4UmVrVfp7gx1BYLgu
         lNSDbSoD+Ff5877GG0gG4Sf3ZO5FRFNKr102WoWPLIoKIA8b8JGrsVcAD8BqjWsXg0+Y
         eQHl+2ftDNij9O0NLWpG3XeLmsjYxStuuXLhLQ8b9ZSCKResTsuelzTdFe8HuKBfptnU
         UiwQzUPZRfJZ37OpfhEXK0oLlr+USODLsKqDWuFk2nnjamGRnOmlhRIb7JKcSx7s3sUK
         IrMTiTzhtZ+AwRRU6OM/RctF/77zPXYZitEC17BWKjmdyIkGE42slgvAE5Xpyyqw/bi4
         zIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u0wQXtlUepAD13MrfASSxGEj5MVfg36xcebgm37Y6GY=;
        b=pRSQZjROhmO2QtSa6jPl6umHoV75MVdxY/Tm1d0E4lrFFlCaBm8exAxgnV+aAnoXSA
         J53h/yFHAETy8Qz4eVFuzULWLr1D+I2+OrYwJEmENGQSQwC/i7jFyLMorJCSbe+WsXtb
         YFnviWcmblrsEJl5xj7yTm5s6WqoAT5uef0Ut+2eqZETyj2yv4F6U/T+L+F3mPDB/8Gq
         5X65zPZcAnqkSVY2rwsLLgK0FS54PL6Y870/EuwnNSVaPgGc6MFvJ/RIq3dpog3KxVW8
         iZo5scoHHcKn3n3pP0/RzvRIxKtBooIvCoxhTKuZVA2BiBz9NqOl3FTiMtidj5JL6NUa
         t0uQ==
X-Gm-Message-State: APjAAAUx+E9dzqKgaFPzLr/4YkAhk6cf1mv/m/EMEkl7WaWfn1ZPry9O
        ekOZCho2k+BXAeqIMXNq7yteaCbLj1c=
X-Google-Smtp-Source: APXvYqxt28O3wpAbIdgOodjhV17oDIFLPuh/r/A/ui/r1184kMYZEvM0CWCIRN8xpIwZF19i6eQRXQ==
X-Received: by 2002:a05:600c:24e:: with SMTP id 14mr8179737wmj.140.1568287779214;
        Thu, 12 Sep 2019 04:29:39 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b7sm4785397wrj.28.2019.09.12.04.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 04:29:38 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, f.fainelli@gmail.com
Subject: [patch iproute2-next v4 0/2] devlink: couple forgotten flash patches
Date:   Thu, 12 Sep 2019 13:29:36 +0200
Message-Id: <20190912112938.2292-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

I was under impression they are already merged, but apparently they are
not. I just rebased them on top of current iproute2 net-next tree.

Jiri Pirko (2):
  devlink: implement flash update status monitoring
  devlink: implement flash status monitoring

 devlink/devlink.c      | 258 ++++++++++++++++++++++++++++++++++++++++-
 devlink/mnlg.c         |   5 +
 devlink/mnlg.h         |   1 +
 man/man8/devlink-dev.8 |  11 ++
 4 files changed, 271 insertions(+), 4 deletions(-)

-- 
2.20.1

