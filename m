Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021AE61F08
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731094AbfGHMz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:55:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55197 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbfGHMz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:55:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so12645979wme.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 05:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pdABVG9Ip+Pta1HFRI4HuryHOT94FWz4XAprlKE0zys=;
        b=k2FVm65WreED+lr8ubs2W1pfLvbWg1vcP79+CD5sHQTz1qBbBBMfqnGv+0CoGwgSED
         oRNXlfPzzosGnx/TGYR+aCtdvhdfFIejl3inVnVyJ7DZdKUm2ossF8GaLXBs8y+1W3X4
         6qwiZtmReCHh1oXKqQLN3gVJYvgXTjdeJQPqUE3tcwgQ7tlBW3gTIydT5+yyY6Imj8a+
         sA3mUccqSYy4l0jn2r4DbJ/tsJkyWiEZvhpUSYoytDxOIIo6+0brEzdNyhFZRhZWUa/1
         v0cy90oYrX2LlIz84Ao4NN6ILSMUWyu9DN7hsKDmcamihWXdiLLiGQvEPxiu36OCS+T2
         KlmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pdABVG9Ip+Pta1HFRI4HuryHOT94FWz4XAprlKE0zys=;
        b=olFcSDJ5SH7eCKVZHU5IT6qBFvRJ29XQ93aIcB7SuJeC10Ngcv7rbH0J2hzIJJDhwC
         gFJP325PrxJ56hoRg6U4CYHpWW6bB5OkTeECWFcTKgwnfpzsI2kf9NjzEnvgx8A4wWbV
         6/p4NBMiSsr0UsxW513RIaBfxG5w+oi5naosQVAdiATc2c3oabIiRPTBt/2iJ+YhVo6n
         xTiiqBzU/VSEojVIIFMOsvJcuDChCVHvnUg+5wDTh6lXaiWGTQ49VyxuSSNKtAm1nv3e
         Ni0F4vUDOoZSETjYy0AfGPA72TlHaI8ICKaHs7d0ibD3JNEnNogBNRJ6PDSvAdrvTIsd
         0lkQ==
X-Gm-Message-State: APjAAAU3qEHqCbWr878zNvtuOwqG22DWLOpFngS6DgvhmDfOIttJqIrU
        wyYbOD5WekVr3vaH0o565UDsxw==
X-Google-Smtp-Source: APXvYqwr5tycNHDhvdb2b5eYbNJ3NGRWh/tiEHyocWaW4xEiCXhhbPo8dc/64+m7ogE6F050tfYL9Q==
X-Received: by 2002:a05:600c:214c:: with SMTP id v12mr16869835wml.28.1562590554538;
        Mon, 08 Jul 2019 05:55:54 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id u6sm17297740wml.9.2019.07.08.05.55.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 05:55:54 -0700 (PDT)
Date:   Mon, 8 Jul 2019 14:55:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 09/16] net/mlx5e: Extend tx reporter diagnostics
 output
Message-ID: <20190708125553.GG2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-10-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-10-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:53:01PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Enhance tx reporter's diagnostics output to include: information common
>to all SQs: SQ size, SQ stride size.
>In addition add channel ix, cc and pc.
>
>$ devlink health diagnose pci/0000:00:0b.0 reporter tx
>Common config:
>   SQ: stride size: 64 size: 1024
> SQs:
>   channel ix: 0 sqn: 4283 HW state: 1 stopped: false cc: 0 pc: 0
>   channel ix: 1 sqn: 4288 HW state: 1 stopped: false cc: 0 pc: 0
>   channel ix: 2 sqn: 4293 HW state: 1 stopped: false cc: 0 pc: 0
>   channel ix: 3 sqn: 4298 HW state: 1 stopped: false cc: 0 pc: 0
>
>$ devlink health diagnose pci/0000:00:0b.0 reporter tx -jp
>{
>    "Common config": [
>        "SQ": {
>            "stride size": 64,
>            "size": 1024
>        } ],
>    "SQs": [ {
>            "channel ix": 0,
>            "sqn": 4283,
>            "HW state": 1,
>            "stopped": false,
>            "cc": 0,
>            "pc": 0
>        },{
>            "channel ix": 1,
>            "sqn": 4288,
>            "HW state": 1,
>            "stopped": false,
>            "cc": 0,
>            "pc": 0
>        },{
>            "channel ix": 2,
>            "sqn": 4293,
>            "HW state": 1,
>            "stopped": false,
>            "cc": 0,
>            "pc": 0
>        },{
>            "channel ix": 3,
>            "sqn": 4298,
>            "HW state": 1,
>            "stopped": false,
>            "cc": 0,
>            "pc": 0
>         } ]
>}
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>---
> .../net/ethernet/mellanox/mlx5/core/en/health.c    | 30 ++++++++++++++++
> .../net/ethernet/mellanox/mlx5/core/en/health.h    |  3 ++
> .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 42 ++++++++++++++++++++++
> 3 files changed, 75 insertions(+)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
>index 60166e5432ae..0d44b081259f 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
>@@ -4,6 +4,36 @@
> #include "health.h"
> #include "lib/eq.h"
> 
>+int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name)
>+{
>+	int err;
>+
>+	err = devlink_fmsg_pair_nest_start(fmsg, name);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_obj_nest_start(fmsg);
>+	if (err)
>+		return err;
>+
>+	return 0;
>+}
>+
>+int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg)
>+{
>+	int err;
>+
>+	err = devlink_fmsg_pair_nest_end(fmsg);

You should end the obj nest first.


>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_obj_nest_end(fmsg);
>+	if (err)
>+		return err;
>+
>+	return 0;
>+}
>+
> int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
> {
> 	struct mlx5_core_dev *mdev = channel->mdev;
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>index 960aa18c425d..0fecad63135c 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>@@ -11,6 +11,9 @@
> void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
> int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
> 
>+int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name);
>+int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg);
>+
> #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
> 
> struct mlx5e_err_ctx {
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
>index dd6417930461..c481f7142a12 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
>@@ -153,6 +153,10 @@ static int mlx5e_tx_reporter_recover(struct devlink_health_reporter *reporter,
> 	if (err)
> 		return err;
> 
>+	err = devlink_fmsg_u32_pair_put(fmsg, "channel ix", sq->channel->ix);

"ix" is an attribute of the channel. I think it should be nested under
"channel" here.


>+	if (err)
>+		return err;
>+
> 	err = devlink_fmsg_u32_pair_put(fmsg, "sqn", sq->sqn);
> 	if (err)
> 		return err;
>@@ -165,6 +169,14 @@ static int mlx5e_tx_reporter_recover(struct devlink_health_reporter *reporter,
> 	if (err)
> 		return err;
> 
>+	err = devlink_fmsg_u32_pair_put(fmsg, "cc", sq->cc);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_u32_pair_put(fmsg, "pc", sq->pc);
>+	if (err)
>+		return err;
>+
> 	err = devlink_fmsg_obj_nest_end(fmsg);
> 	if (err)
> 		return err;
>@@ -176,6 +188,9 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
> 				      struct devlink_fmsg *fmsg)
> {
> 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
>+	struct mlx5e_txqsq *generic_sq = priv->txq2sq[0];
>+	u32 sq_stride, sq_sz;
>+
> 	int i, err = 0;
> 
> 	mutex_lock(&priv->state_lock);
>@@ -183,6 +198,33 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
> 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
> 		goto unlock;
> 
>+	sq_sz = mlx5_wq_cyc_get_size(&generic_sq->wq);
>+	sq_stride = MLX5_SEND_WQE_BB;
>+
>+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "Common config");
>+	if (err)
>+		goto unlock;
>+
>+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "SQ");
>+	if (err)
>+		goto unlock;
>+
>+	err = devlink_fmsg_u64_pair_put(fmsg, "stride size", sq_stride);
>+	if (err)
>+		goto unlock;
>+
>+	err = devlink_fmsg_u32_pair_put(fmsg, "size", sq_sz);
>+	if (err)
>+		goto unlock;
>+
>+	err = devlink_fmsg_arr_pair_nest_end(fmsg);

Which nest is this supposed to end? Looks like it is extra and
should not be here...


>+	if (err)
>+		goto unlock;
>+
>+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
>+	if (err)
>+		goto unlock;
>+
> 	err = devlink_fmsg_arr_pair_nest_start(fmsg, "SQs");
> 	if (err)
> 		goto unlock;
>-- 
>1.8.3.1
>
