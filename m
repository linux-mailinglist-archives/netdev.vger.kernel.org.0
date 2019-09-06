Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D095DABF6C
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 20:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436564AbfIFSbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 14:31:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42234 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730881AbfIFSbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 14:31:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id q14so7543294wrm.9
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 11:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+7Zvdf6feNwNwU0hTXxK0YEshi7BiLXqpt7wOJb4VD4=;
        b=EiuGtEA3L6jtE9WyIXVwP5BgrPJT9yEVlPcrurFjtZYFxZvVNhvnfucuRpHRQCQ497
         YfuhhptjYxoVwyZcICxi1AuZR/bFgmf9h/XZcOePpgF62QEra1BZ7ZzkM6nTvXIrO3PB
         0X4mIwG2g7Pv0qbXesKSteIZkffQLiVwzzYTKlEA9WQ78bTaHwoq1efj7b3ZRM9woInR
         SkmKzq1qfkDwjQ3FeabgZwBNJco7fRLT5vByaHzCW8MWfscjKdH95022MKVcyirgW2Pc
         OuPXB8rPa2WhVZocUfvMt5NKSGBareKnoOijIzkL6xMJrNnN9zf7AbHuUlxeEV44fUdw
         52uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+7Zvdf6feNwNwU0hTXxK0YEshi7BiLXqpt7wOJb4VD4=;
        b=LiDeLae+MJfF13Qq8Ts1709e3fR2IX78EUDkamauUhguGTSZHMMWuygauDtOCrz/AM
         dqwinYK+J9/mq6LbEMC/WZzt3gV6d518gXKeW/uV7MgNF5QcXq18BP2UoYmXVRVkg6U7
         4aJQ2hrSKU6IMJLJ6gxNYHLoACTK2fIT7//h7P6b+NIrJcRgU7pbH0H/IHjP+fbc3791
         s/09Pbsa6x6tDcCGX5XweVuAjTfi9axjY0/EkUwlBLU3G7nISFpZDK3Dqa3YeVqKs043
         n0rXwMys5ZASeN0gOIPwcKkY9pMRmclU2Vpb8bIyNqGVQ2Uq3AEqLV0jKSgMSVEC55aU
         u4yg==
X-Gm-Message-State: APjAAAXXtcVXkD9CvnKwFJm+2SIfuu1gAw5qm3Bp4s4SznFoaE1ul1wB
        mkhHba5+UGOY1f8mg2ToOnF6yw==
X-Google-Smtp-Source: APXvYqwUYlzNIwcFO4i0nBUa7teHldj5FELo+lxU7i4nrzJ1YSxCXvjOYI7KzK/nlHKL02hyFRys1Q==
X-Received: by 2002:a5d:4ac7:: with SMTP id y7mr8756402wrs.271.1567794668103;
        Fri, 06 Sep 2019 11:31:08 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k6sm11601319wrg.0.2019.09.06.11.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 11:31:07 -0700 (PDT)
Date:   Fri, 6 Sep 2019 20:31:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: Re: [net-next 02/11] devlink: add 'reset_dev_on_drv_probe' param
Message-ID: <20190906183106.GA3223@nanopsycho.orion>
References: <20190906160101.14866-1-simon.horman@netronome.com>
 <20190906160101.14866-3-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906160101.14866-3-simon.horman@netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Sep 06, 2019 at 06:00:52PM CEST, simon.horman@netronome.com wrote:
>From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
>
>Add the 'reset_dev_on_drv_probe' devlink parameter, controlling the
>device reset policy on driver probe.
>
>This parameter is useful in conjunction with the existing
>'fw_load_policy' parameter.
>
>Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
>Signed-off-by: Simon Horman <simon.horman@netronome.com>
>---
> Documentation/networking/devlink-params.txt | 14 ++++++++++++++
> include/net/devlink.h                       |  4 ++++
> include/uapi/linux/devlink.h                |  7 +++++++
> net/core/devlink.c                          |  5 +++++
> 4 files changed, 30 insertions(+)
>
>diff --git a/Documentation/networking/devlink-params.txt b/Documentation/networking/devlink-params.txt
>index fadb5436188d..f9e30d686243 100644
>--- a/Documentation/networking/devlink-params.txt
>+++ b/Documentation/networking/devlink-params.txt
>@@ -51,3 +51,17 @@ fw_load_policy		[DEVICE, GENERIC]
> 			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK (2)
> 			  Load firmware currently available on host's disk.
> 			Type: u8
>+
>+reset_dev_on_drv_probe	[DEVICE, GENERIC]
>+			Controls the device's reset policy on driver probe.
>+			Valid values:
>+			* DEVLINK_PARAM_RESET_DEV_VALUE_UNKNOWN (0)
>+			  Unknown or invalid value.

Why do you need this? Do you have usecase for this value?


>+			* DEVLINK_PARAM_RESET_DEV_VALUE_ALWAYS (1)
>+			  Always reset device on driver probe.
>+			* DEVLINK_PARAM_RESET_DEV_VALUE_NEVER (2)
>+			  Never reset device on driver probe.
>+			* DEVLINK_PARAM_RESET_DEV_VALUE_DISK (3)
>+			  Reset only if device firmware can be found in the
>+			  filesystem.
>+			Type: u8
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 460bc629d1a4..d880de5b8d3a 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -398,6 +398,7 @@ enum devlink_param_generic_id {
> 	DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MAX,
> 	DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MIN,
> 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
>+	DEVLINK_PARAM_GENERIC_ID_RESET_DEV,
> 
> 	/* add new param generic ids above here*/
> 	__DEVLINK_PARAM_GENERIC_ID_MAX,
>@@ -428,6 +429,9 @@ enum devlink_param_generic_id {
> #define DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_NAME "fw_load_policy"
> #define DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_TYPE DEVLINK_PARAM_TYPE_U8
> 
>+#define DEVLINK_PARAM_GENERIC_RESET_DEV_NAME "reset_dev_on_drv_probe"

The name of the define and name of the string should be the same. Please
adjust.


>+#define DEVLINK_PARAM_GENERIC_RESET_DEV_TYPE DEVLINK_PARAM_TYPE_U8
>+
> #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
> {									\
> 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index c25cc29a6647..3172d1b3329f 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -205,6 +205,13 @@ enum devlink_param_fw_load_policy_value {
> 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
> };
> 
>+enum devlink_param_reset_dev_value {
>+	DEVLINK_PARAM_RESET_DEV_VALUE_UNKNOWN,
>+	DEVLINK_PARAM_RESET_DEV_VALUE_ALWAYS,
>+	DEVLINK_PARAM_RESET_DEV_VALUE_NEVER,
>+	DEVLINK_PARAM_RESET_DEV_VALUE_DISK,
>+};
>+
> enum {
> 	DEVLINK_ATTR_STATS_RX_PACKETS,		/* u64 */
> 	DEVLINK_ATTR_STATS_RX_BYTES,		/* u64 */
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 6e52d639dac6..e8bc96f104a7 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -2852,6 +2852,11 @@ static const struct devlink_param devlink_param_generic[] = {
> 		.name = DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_NAME,
> 		.type = DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_TYPE,
> 	},
>+	{
>+		.id = DEVLINK_PARAM_GENERIC_ID_RESET_DEV,
>+		.name = DEVLINK_PARAM_GENERIC_RESET_DEV_NAME,
>+		.type = DEVLINK_PARAM_GENERIC_RESET_DEV_TYPE,
>+	},
> };
> 
> static int devlink_param_generic_verify(const struct devlink_param *param)
>-- 
>2.11.0
>
