Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0430C1684BD
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgBURUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:20:12 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51274 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgBURUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:20:12 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so2574821wmi.1
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 09:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hqQ+aTrDEnBx+s6claZe2vKTKMHC/7x41HzbdXRsZ8E=;
        b=JynLIov+unMZmGChYa0cW1kD9wPV8hyIwmkvkxY2XgSnIKCbqVMYu0RQz+3zwwZyCv
         +N3u7P764XeiKP3oOQFv7dXKC7+Oe4ZQDA/88VwAYfY6lrtrLbJNEvdvyuV/d9GRpOZ1
         ZkMX8o/2quq4U5DJcXi8UuYkeXZJey2JnVfFKzF9TKPa88hn7dRrRu+jW+qIcl3gksOj
         4xTz4SdkHQQUdE/5kZzWczDO3qTOKmqRbmh1IsYfFJZ94Uv9AWIYcC9I6qjUfmaNS3+A
         xl90fPMcBWh6lQ2Gu0cPrw1W78ymY0t48sgRG64HIWovINycKZ6pBj5tY22Y+Bvv0N7X
         AHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hqQ+aTrDEnBx+s6claZe2vKTKMHC/7x41HzbdXRsZ8E=;
        b=ZlJEiOnyF0dpnXHOKzi9aGVGzw6Ze3lRC3qK3uO9sBD/Irn7LIwDJfhiiDKAaRB6Hz
         703CBB4mJm8Q67imf9xYahOniEw4eITUhXR1vRvmVHOfXMqgZiE/vY5Dbi36kzpIufgP
         2TK5QoTjAHBnA4nK+qr848EalsbSP4fYjcaffM2zi9+uJ9+KUBduVVTt4vYn0vufMZS/
         HKA2FbMdoSYGRHEdBYbzknSAK6qNh+GcLpsLZqQGAtSiVbmuCMMK4gd2vd9ynnnILisJ
         yWklxk9tsgGyFdk23q9u7kKEKtqg44R+iLyuGB59LSuRevbCN0qjqQHEMN9PzBlHhHxR
         rTbA==
X-Gm-Message-State: APjAAAXXCXOGGPf5CWeBJkn+rnY66wm8+PpeO7rSMpDKyhO2++ET7KEU
        K7Uo8ocbM/5gGHPaQgE/sXcB5g==
X-Google-Smtp-Source: APXvYqzxk6iXslWi+d+A4DYTS4zK4n/WpayK/WU8wiRI+NtfEMydS6s1VGa9hfiASMIsFY/HqR57aw==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr4856445wmi.128.1582305610253;
        Fri, 21 Feb 2020 09:20:10 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id d204sm4379677wmd.30.2020.02.21.09.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 09:20:09 -0800 (PST)
Date:   Fri, 21 Feb 2020 18:20:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     madhuparnabhowmik10@gmail.com
Cc:     jiri@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Use built-in RCU list checking
Message-ID: <20200221172008.GA2181@nanopsycho>
References: <20200221165141.24630-1-madhuparnabhowmik10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221165141.24630-1-madhuparnabhowmik10@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 21, 2020 at 05:51:41PM CET, madhuparnabhowmik10@gmail.com wrote:
>From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>
>list_for_each_entry_rcu() has built-in RCU and lock checking.
>
>Pass cond argument to list_for_each_entry_rcu() to silence
>false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
>by default.
>
>Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Thanks.

However, there is a callpath where not devlink lock neither rcu read is
taken:
devlink_dpipe_table_register()->devlink_dpipe_table_find()

I guess that was not the trace you were seeing, right?


>---
> net/core/devlink.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 4c63c9a4c09e..3e8c94155d93 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -2107,7 +2107,8 @@ devlink_dpipe_table_find(struct list_head *dpipe_tables,
> {
> 	struct devlink_dpipe_table *table;
> 
>-	list_for_each_entry_rcu(table, dpipe_tables, list) {
>+	list_for_each_entry_rcu(table, dpipe_tables, list,
>+				lockdep_is_held(&devlink->lock)) {
> 		if (!strcmp(table->name, table_name))
> 			return table;
> 	}
>-- 
>2.17.1
>
