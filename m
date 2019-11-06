Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1922F1179
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 09:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfKFIx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 03:53:57 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32832 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfKFIx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 03:53:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id w30so2009884wra.0
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 00:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dEfVVo0cEBPUxFVnnTzNXCF3wuhgZe3bWHn0NKU3gS8=;
        b=nFzRS7PHEA6wQNf2kqWlzGTnUIWKXlkVbFU0IV6yiuEWLKRg7H8t9mteEW2zb+ofxM
         I4uu2OvnzFFsZE3JhCUkTW5cT0suBUhsa4bfMxU/NH8LvY2/2VMcmV7UuciFCrQC+omY
         GNQzTahw6+H95/HE1zzMc3p1vKGVl6uQuHVVvBayHqpSXAUwIM6igSV5IiWM0t9wZQ4Z
         buiRhYWefVfwYcIzJGyr4nANsYtTtNBlN8Cw16PnHp5LMdf/ufwqi6F8OqZvjWLmDesm
         Yma6BdjSGaiPZOtcqTEPW9V+RMgcQTQSs/4zh0F5VU2HPm6pXHjzH0tTFOH/p88ZXcCl
         XxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dEfVVo0cEBPUxFVnnTzNXCF3wuhgZe3bWHn0NKU3gS8=;
        b=ClnB+654gT9haRmSTQifoNz1rqr2GKQXzPLn4P0RvyPgwhLcLHJ+ZZhHwLFH+qc441
         5vUXLTD22FvkkoQUXwiN+W21k394S+oXi1BEPmKMXQjW4CX0cxo8yXF47xMhHJjA3Y46
         DKI7PuxcXIDyelxpvkVZfeWmaeleJT3t1ACFZK+N+lZaVy1WhwjM4WkTDFqbgRZUbDNC
         xcRO1QajWcWWTGp6CI1wgoHlRUGaKsFoPIFObpDn4jFkmpZR3/+gKAOt5AIPqAK6pb1P
         R7vaby3pSTOQtVqMm+3KNhkqmlXoP5YaJ8MrEKV078F5lBKEf4fMq+UGFwRhFBokE7nl
         qOXA==
X-Gm-Message-State: APjAAAWOFzg8QKcB6Bw7nykb+TxnJIT1TijY7mGpLwrROnoZqzAW1DMJ
        0rOI2ar1987Ix05zPb9xxoV8IA==
X-Google-Smtp-Source: APXvYqwkahDLU+Hb0hgletCJ/eBQZjYwrvewVQrzlwD1gA+S7dVRH6g+37aGszH9QHUAZn7sI6QaSg==
X-Received: by 2002:adf:ee81:: with SMTP id b1mr1424418wro.58.1573030434632;
        Wed, 06 Nov 2019 00:53:54 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id l5sm1814021wmj.44.2019.11.06.00.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 00:53:54 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:53:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH iproute2-next 3/3] devlink: allow full range of resource
 sizes
Message-ID: <20191106085353.GE2112@nanopsycho>
References: <20191105211707.10300-1-jakub.kicinski@netronome.com>
 <20191105211707.10300-4-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105211707.10300-4-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 05, 2019 at 10:17:07PM CET, jakub.kicinski@netronome.com wrote:
>Resource size is a 64 bit attribute at netlink level.
>Make the command line argument 64 bit as well.
>
>Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

This can be:
Fixes: 8cd644095842 ("devlink: Add support for devlink resource abstraction")

Anyway:
Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks!

>---
> devlink/devlink.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/devlink/devlink.c b/devlink/devlink.c
>index e05a2336787a..ea3f992ee0d7 100644
>--- a/devlink/devlink.c
>+++ b/devlink/devlink.c
>@@ -283,7 +283,7 @@ struct dl_opts {
> 	bool dpipe_counters_enable;
> 	bool eswitch_encap_mode;
> 	const char *resource_path;
>-	uint32_t resource_size;
>+	uint64_t resource_size;
> 	uint32_t resource_id;
> 	bool resource_id_valid;
> 	const char *param_name;
>@@ -1348,7 +1348,7 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
> 		} else if (dl_argv_match(dl, "size") &&
> 			   (o_all & DL_OPT_RESOURCE_SIZE)) {
> 			dl_arg_inc(dl);
>-			err = dl_argv_uint32_t(dl, &opts->resource_size);
>+			err = dl_argv_uint64_t(dl, &opts->resource_size);
> 			if (err)
> 				return err;
> 			o_found |= DL_OPT_RESOURCE_SIZE;
>-- 
>2.23.0
>
