Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1533A140D2
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 17:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfEEPtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 11:49:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33272 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbfEEPtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 11:49:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id e11so997992wrs.0
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 08:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RtVTCrERd8LU4ht9V9tNA41JVBaMag9U/S2whaVc2AY=;
        b=n9MKuIp0x6ayiZsnFVG6me+ub7pGN+3NyMwhmcBaYj1wWovR/an6jABulxehmKDpoP
         5f7MIj+MlquI0etiS2cDkyIwC9r/usjkI5G9Z5KfWaK4kQoQvxVhtFCXCvC7v0fZtkup
         7l4Lvk5hTJFPpoqQYWqMZOVgMUnZ8bZfF7rkoIZeeA7JvUULztTkjZ1CKx9zde+/0vI3
         ADIDg3qs5V3Km2JpNI6Vh9RgMsJvkHbTZCygRsfW+td3TmI15Dlya13jnPB8CvkDJof8
         Kp4b59Q039U69n796aNkARh20I93HueDZ/xw6qeYRjNf8umdJ9SELL4RmJ/RTiatrfH9
         FC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RtVTCrERd8LU4ht9V9tNA41JVBaMag9U/S2whaVc2AY=;
        b=Gs9jK+urNCElAfROZkSSfCN8b4CN2LlMVZZqRZEX/2GLTWCdzVkODJzeiqYijYHeZF
         aNxdl95LGj1t5ZLsI5OGXevcyVqzHQrSIiFFzCzH3dduTrn7WHKBbf1WQu3U4ICaFVlb
         HFCgIu6CwOmH/6AaKkKdaT+4YETHhzB7t6CfyGtW4LmOcPYbcpj8e4wy4Nfa0eaohf8g
         Mu66VdPY7eAa75NfJBG4rHYhl4shpuZlLZ+pe9e2XQNuGc9t3BoNogffDESGhyjL1TFV
         vgOHHU1schQY5IUVpMc2+dpLdy5Nl+Dzun126wjYvccsQGbX8t4Rdq0RG4+U4Os4ZUnh
         StlQ==
X-Gm-Message-State: APjAAAXhLW1cMc0qoh7fKd3rrfH/FDkj8d4rkOTItuxSlMI69PjxiiG+
        8SNxX9AIHApDjhwNdQWr1Y2HOg==
X-Google-Smtp-Source: APXvYqyhUCyCd6GyRTa7OXTgRzQJb9MFjITAT1dauJFYm1nbyGTsNVH/RfBMn0WiAg6N38rVxczTpQ==
X-Received: by 2002:adf:fd45:: with SMTP id h5mr11732619wrs.52.1557071343255;
        Sun, 05 May 2019 08:49:03 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t2sm6265284wma.13.2019.05.05.08.49.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 08:49:02 -0700 (PDT)
Date:   Sun, 5 May 2019 17:49:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net-next 11/15] net/mlx5: Add support for FW reporter dump
Message-ID: <20190505154902.GF31501@nanopsycho.orion>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-12-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505003207.1353-12-saeedm@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 05, 2019 at 02:33:27AM CEST, saeedm@mellanox.com wrote:
>From: Moshe Shemesh <moshe@mellanox.com>
>
>Add support of dump callback for mlx5 FW reporter.
>Once we trigger FW dump, the FW will write the core dump to its raw data
>buffer. The tracer translates the raw data to traces and save it to a
>buffer. Once dump is done, the saved traces data is filled as objects
>into the dump buffer.
>

[...]

>+static void mlx5_fw_tracer_save_trace(struct mlx5_fw_tracer *tracer,
>+				      u64 timestamp, bool lost,
>+				      u8 event_id, char *msg)
>+{
>+	char *saved_traces = tracer->sbuff.traces_buff;
>+	u32 offset;
>+
>+	mutex_lock(&tracer->sbuff.lock);
>+	offset = tracer->sbuff.saved_traces_index * TRACE_STR_LINE;
>+	snprintf(saved_traces + offset, TRACE_STR_LINE,
>+		 "%s [0x%llx] %d [0x%x] %s", dev_name(&tracer->dev->pdev->dev),
>+		 timestamp, lost, event_id, msg);

Please format this using fmsg helpers instead.


>+
>+	tracer->sbuff.saved_traces_index =
>+		(tracer->sbuff.saved_traces_index + 1) & (SAVED_TRACES_NUM - 1);
>+	mutex_unlock(&tracer->sbuff.lock);
>+}

[...]
