Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1B2CDE85
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 11:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfJGJ42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 05:56:28 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:41259 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfJGJ42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 05:56:28 -0400
Received: by mail-wr1-f52.google.com with SMTP id q9so14476217wrm.8
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 02:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lrJbbVinyzS4tJSnvulsdUzjYBv7CtHU6r3nHxlQjY0=;
        b=tUPCFi9IsRt68oqGyTEivLWyBZKuvQWOrK90jAh3KHJrDJQavtiOYxVsMIKJqFV2p1
         caUqF9Oj2zmE2Ptdoz87cHQSlcgKr/8302uyK6iZE2QxT3wd3exrmhlE2KMKNrGTVb1h
         QVx3PwjuT7XTpTcT66F1ia1L7BOsY+Q5AbrrT/OtUBJVU/j+p9qlLFX1MM4Xf8NKImN1
         NDclcFFp0btTWv74G9Q9JfbRrjiDAZnvbkDneEMeSKKaplYCS+gmQb26vcfviPBx6rwD
         /Bu5F+zypd79DF1ZhQnSQPwa9GOo5xkQMndw72ncjIGcymfI62ucgBcK70a//4DolFNG
         OI/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lrJbbVinyzS4tJSnvulsdUzjYBv7CtHU6r3nHxlQjY0=;
        b=Z0LIAiWasiSWclju1SrIgJXPQOg++Tl6DeEcgcKYL0bVh8DVOOjc1au7n6xmPouzJS
         Gpug1OTXwEr5yHYn7rwQAWLIEDFBP55f3RVId+Ekh6yta9mCEXc/mED55KN1aVkvzP7p
         i9RVW0SWDxbMExQdQLV4hjCyQkeesSr73dDD+FdU0IeIz3by2jqmLYHl+yd+Gr5w8Aov
         agXVgi7xx9AAcOwl9iRwhsAzSnqDK4x6bkjIkDH76r32UL4+vzMcNUcY8s/OcNXtVZBW
         YWgPfvPw7lbMzY2voRzkhj2h/M8NwvIT+9uUX38ZF6GwywicNVz6J9WbFeVIKRCux7er
         8x8g==
X-Gm-Message-State: APjAAAWzy5Zt/k2/3KSsSKzLlx3brDR9Trpe2ISTOHBGtL3Yrc+eb+YK
        myF+n3BCcXS1ATtr0IL0yUeeyA==
X-Google-Smtp-Source: APXvYqwTOGRjQFTyuUUtB48lRkEbk8WpBYaThIEsF/Im/42GOPoGTXRgwfHUtcwzaydclc1HaZ02Qg==
X-Received: by 2002:a5d:4f0b:: with SMTP id c11mr21643226wru.63.1570442184635;
        Mon, 07 Oct 2019 02:56:24 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id q19sm40350444wra.89.2019.10.07.02.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 02:56:24 -0700 (PDT)
Date:   Mon, 7 Oct 2019 11:56:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vasundhara-v.volam@broadcom.com, ray.jui@broadcom.com,
        Jiri Pirko <jiri@mellanox.com>, ayal@mellanox.com,
        moshe@mellanox.com
Subject: Re: [PATCH net-next v2 14/22] bnxt_en: Add new FW
 devlink_health_reporter
Message-ID: <20191007095623.GA2326@nanopsycho>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
 <1567137305-5853-15-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567137305-5853-15-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 30, 2019 at 05:54:57AM CEST, michael.chan@broadcom.com wrote:
>From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>
>Create new FW devlink_health_reporter, to know the current health
>status of FW.
>
>Command example and output:
>$ devlink health show pci/0000:af:00.0 reporter fw
>
>pci/0000:af:00.0:
>  name fw
>    state healthy error 0 recover 0
>
> FW status: Healthy; Reset count: 1

I'm puzzled how did you get this output, since you put "FW status" into
"diagnose" callback fmsg and that is called upon "devlink health diagnose".

[...]


>+static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
>+				     struct devlink_fmsg *fmsg)
>+{
>+	struct bnxt *bp = devlink_health_reporter_priv(reporter);
>+	struct bnxt_fw_health *health = bp->fw_health;
>+	u32 val, health_status;
>+	int rc;
>+
>+	if (!health || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
>+		return 0;
>+
>+	val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
>+	health_status = val & 0xffff;
>+
>+	if (health_status == BNXT_FW_STATUS_HEALTHY) {
>+		rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
>+						  "Healthy;");

First of all, the ";" is just wrong. You should put plain string if
anything. You are trying to format user output here. Don't do that
please.

Please see json output:
$ devlink health show pci/0000:af:00.0 reporter fw -j -p

Please remove ";" from the strings.


Second, I do not understand why you need this "FW status" at all. The
reporter itself has state healthy/error:
pci/0000:af:00.0:
  name fw
    state healthy error 0 recover 0
          ^^^^^^^

"FW" is redundant of course as the reporter name is "fw".

Please remove "FW status" and replace with some pair indicating the
actual error state.

In mlx5 they call it "Description".


>+		if (rc)
>+			return rc;
>+	} else if (health_status < BNXT_FW_STATUS_HEALTHY) {
>+		rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
>+						  "Not yet completed initialization;");
>+		if (rc)
>+			return rc;
>+	} else if (health_status > BNXT_FW_STATUS_HEALTHY) {
>+		rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
>+						  "Encountered fatal error and cannot recover;");
>+		if (rc)
>+			return rc;
>+	}
>+
>+	if (val >> 16) {
>+		rc = devlink_fmsg_u32_pair_put(fmsg, "Error", val >> 16);

Perhaps rather call this "Error code"?


>+		if (rc)
>+			return rc;
>+	}
>+
>+	val = bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
>+	rc = devlink_fmsg_u32_pair_put(fmsg, "Reset count", val);

What is this counter counting? Number of recoveries?
If so, that is also already counted internally by devlink.

[...]
