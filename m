Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EA7140B7
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 17:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfEEPmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 11:42:16 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:35033 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEPmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 11:42:15 -0400
Received: by mail-wm1-f48.google.com with SMTP id y197so12245550wmd.0
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 08:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p4JsYWi9ym08opXx0yjpQVEz2QDZjiF/Ki7+3ghiRfw=;
        b=0aZf4l5/XNzmhPji0CuJyeGqqzl/N2KpjYJHMr+OF1YCS6tTVhH7+RtZm+m3u1YMMD
         WYw7THgBAmHUrpsJN9Jz5AVXdE4Am1jHmEEfynHSJ/Yi45FlHgo6unIRz7299QXyVMJN
         yZS3tBaNbMtN5Mtf4BukJI2Huyu3wT4j54V5TuUG0ubpVjOEhuI1sI83m108udd3wcw3
         3uhTm6Jb3M26FKD2GGndVa1y0xYRRQypIAL8TXqBVD3zT/ZaPJKYrPSYg46p7tP7smS7
         M0CZirhscx0tc4kBOeVYOG3COC2v6Jk2PLFcGvy6kowq/uuwjaCbshVCflSNu1qhugnO
         usEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p4JsYWi9ym08opXx0yjpQVEz2QDZjiF/Ki7+3ghiRfw=;
        b=Vlqj3jI1w88xyW99o/YRHqVPWpMF1jWJBUGT8nbAcGSGB4Mj9yohXvnn8nJK7cAwnl
         cl+sYFxt4/neJ0kr/3vToL35TPvxNxf51avvyiMT89vR3Fftxh6OfMkreHPy48kqbT08
         WiLfR62WLy38MAlofC2tefqjTdZuTqtt5gmWrZraQGdTli74OcjwQ8YVjkdW5oxCTddJ
         yNc0Q/sS11wAHV/xvpIE2txo3zq6l/Q9W+QSB5tn4d2IIK9jtdMxSiCAWg5Sx/Il0U+r
         eJBxOR0GCoBdyPPKQze4FrLxbZO0zOkforwbtm93WkISRxzc9eulgb8qcxKE/kUQHeTe
         OwLA==
X-Gm-Message-State: APjAAAXfYVmWWl0iCSMG/pDtw0MMj0qyXMCLpTc3d//M6TtzwY2DdZYL
        vzVqlyuTZVQkewWcHgkRxxjQAQaTz2w=
X-Google-Smtp-Source: APXvYqxWCndnzlM6w2KJzdiJys2xh9hF2yhl5PoLGVKYqlqwdSpFJ4sPNt+8oMjjqrybTBF1hVsuUw==
X-Received: by 2002:a1c:f606:: with SMTP id w6mr12713541wmc.130.1557070934118;
        Sun, 05 May 2019 08:42:14 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v23sm5752667wmj.43.2019.05.05.08.42.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 08:42:13 -0700 (PDT)
Date:   Sun, 5 May 2019 17:42:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Message-ID: <20190505154212.GC31501@nanopsycho.orion>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-10-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505003207.1353-10-saeedm@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 05, 2019 at 02:33:23AM CEST, saeedm@mellanox.com wrote:
>From: Moshe Shemesh <moshe@mellanox.com>
>
>Create mlx5_devlink_health_reporter for FW reporter. The FW reporter
>implements devlink_health_reporter diagnose callback.
>
>The fw reporter diagnose command can be triggered any time by the user
>to check current fw status.
>In healthy status, it will return clear syndrome. Otherwise it will dump
>the health info buffer.
>
>Command example and output on healthy status:
>$ devlink health diagnose pci/0000:82:00.0 reporter fw
>Syndrome: 0
>
>Command example and output on non healthy status:
>$ devlink health diagnose pci/0000:82:00.0 reporter fw
>diagnose data:
>assert_var[0] 0xfc3fc043
>assert_var[1] 0x0001b41c
>assert_var[2] 0x00000000
>assert_var[3] 0x00000000
>assert_var[4] 0x00000000
>assert_exit_ptr 0x008033b4
>assert_callra 0x0080365c
>fw_ver 16.24.1000
>hw_id 0x0000020d
>irisc_index 0
>synd 0x8: unrecoverable hardware error
>ext_synd 0x003d
>raw fw_ver 0x101803e8
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
>Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

	
[...]	
	
	
>+static int
>+mlx5_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
>+			  struct devlink_fmsg *fmsg)
>+{
>+	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
>+	struct mlx5_core_health *health = &dev->priv.health;
>+	u8 synd;
>+	int err;
>+
>+	mutex_lock(&health->info_buf_lock);
>+	mlx5_get_health_info(dev, &synd);
>+
>+	if (!synd) {
>+		mutex_unlock(&health->info_buf_lock);
>+		return devlink_fmsg_u8_pair_put(fmsg, "Syndrome", synd);
>+	}
>+
>+	err = devlink_fmsg_string_pair_put(fmsg, "diagnose data",
>+					   health->info_buf);

No! This is wrong! You are sneaking in text blob. Please put the info in
structured form using proper fmsg helpers.
