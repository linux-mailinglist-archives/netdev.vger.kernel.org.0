Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCE619BEF3
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 11:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387526AbgDBJzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 05:55:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38002 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbgDBJzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 05:55:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id c7so3404155wrx.5
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 02:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2iZDG8pkitByAJ8vU1P7gjtAh1LyP7nXeEvd/6j/dcQ=;
        b=aSt92Vs9f1WD0djEnGy830zZSXYnsq0CCOQahU2RgsqwJvGrd6Tj4E0DAGE64qRaqP
         GOZSo/WrS6tLs+WyzApfw5gTsLFEe/2rTI7/jiDaAWhEqa1f9TulW3TL0OkSp3tJT/lE
         /iCX225mtdRkhxA9+QWxIKdToz6GhGbt+XH5vvHws4c3XE4Vew+XkwG40+fg7UOWPKHI
         jNZ7JKm5bmQ2C9OGK6OMNINNJhs9xXwbCp8PekjF6vtmmxus0nAs6ldleX/6orIDPGQP
         TknJopG3hjZO+CgyiB6rA9tcCWiDhVIUbSWsTe8cOKvJ9EpFRdrQYiCRnm1+vvQo6oTa
         uRPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2iZDG8pkitByAJ8vU1P7gjtAh1LyP7nXeEvd/6j/dcQ=;
        b=sfQ7F90vItYYQ3OwLWVXiN0QzYZ9Svad0YTlFxRHoS3M6CH5Yxh7luxkbRF0ip/4ns
         P/QI7JVO7sTXmN+Ke9DEwGv+KeksAJCZ1dev4lNsb59S2f80/mFn/xqcR4YLByHXGtJT
         0NvgihbsYKnHO4Kw7FGYi2N3w/C7kfxkUZY/p2712YkCoXTbDfltF49lztf0O1s3VTZF
         S8X1IOdGNoS2O/KFtBUqL51AwARHm4gVzCYGq+2nxLYdVaT2Zz/y52zvE/1hrigJG3dS
         nh3fvK5nQykD1JWUVjOKkQb7dH3lCEfhrcHgzLvrkeV3LnY8rFNaNZ+OvgScA0BSir5K
         JmWA==
X-Gm-Message-State: AGi0Pub2XIV9m4bua0vh8p0nPPbOBlzVlGylMLcVgeJSG6ESQ0oKNW3O
        BuBN32zfGq43tjjy7GZRMCXRjOj2tUw=
X-Google-Smtp-Source: APiQypI1Swx8n+WYK9GkLAH2A6Cp3wSKecDgccXFX4Y8Z+se4wuJGl9RfWBiSAlCBfYRe9G6479i7A==
X-Received: by 2002:adf:f2c5:: with SMTP id d5mr718337wrp.409.1585821341314;
        Thu, 02 Apr 2020 02:55:41 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a64sm6399468wmh.39.2020.04.02.02.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 02:55:40 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, davem@davemloft.net,
        kuba@kernel.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next] devlink: remove unused "jw" field
Date:   Thu,  2 Apr 2020 11:55:39 +0200
Message-Id: <20200402095539.18643-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This field is not used. Remove it.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 67e6e64181f9..b8c1170be0e2 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -312,7 +312,6 @@ struct dl {
 	char **argv;
 	bool no_nice_names;
 	struct dl_opts opts;
-	json_writer_t *jw;
 	bool json_output;
 	bool pretty_output;
 	bool verbose;
-- 
2.21.1

