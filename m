Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D47F25778C
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 12:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgHaKon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 06:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgHaKol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 06:44:41 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598F0C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 03:44:41 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a17so4577490wrn.6
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 03:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k+EYgDY4h1YnjFAKejF6GzhKvmGlD2uTuVOl9S42RJU=;
        b=XqB9pDZFFdbsN4WAsjqI6EX/O5KjFFP6wjsWbg9oDnQZBxcMHzwP7YSIBUJt5O0VAX
         OJAyoBLH3V7jmSvh8XTcTRa/7UPkOSfImLuCq65zVihXa3b96Ef1YlqhHN96BiRyrjt8
         RTNB3lCbQlbWxey2ErX645oW0ro3qstDprORVaDt1QBJAJser/0m/EPKi9yovckee5B9
         FA/j6+zfLwp03TvPPRgHW2DyLPXKn/l4Z3kKweG8Z5yvPyvnsOc2ag7LSWwMd5wumTWj
         o78Tmnuo5V11ZRQwk2ZMqofBq8HQwnVGCOfFw/Nntf3JUFQFnKJQJyLcFDVmQSe9rAaY
         jejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k+EYgDY4h1YnjFAKejF6GzhKvmGlD2uTuVOl9S42RJU=;
        b=gXfsy3NepmH9amyH0dp6xaHpkR35H4s7qWWyH+sgOXP5v6C5yUGOBRjRyTpsgTxtOP
         HPiuHsiQ5lG2RLTjLUcTgqsQ27ppqxDrScDBcXK1Ec1qX61rom63sjxSvDZYiL1VQ2VW
         3+X1O3T6uZnrxnhC30IAOKq1WbpD3TuldFG/PpBL4bva5UclN4OPL7UwxpNfaSbEblPf
         3sWVdTJThQPn8mWr8W867egI+Ft04RJPkwaxNvfVyK4KjWx0Y3GiVu2xUmY+aTgP5VUI
         28ofQqTryu/lGFibMvPiJiVpRBTzjAOuQWl7IkE80QNBvbv+RpOqL+1uzUlW6+QJT0aF
         hxog==
X-Gm-Message-State: AOAM530gOOGn5LYQBObhgWPKkEASzazDqSe6c9WZeMTD+D+wFED2V4+F
        5eOUkBAa7mRSlxyAeGqQykxsSw==
X-Google-Smtp-Source: ABdhPJyRFov4JuNLN5DAXSh9XQtJj9BZLjKnRtnTEzitPpCAZ1aI/EixspeKXwmvuQAztWmzQIGZzQ==
X-Received: by 2002:adf:e58b:: with SMTP id l11mr1162050wrm.210.1598870679800;
        Mon, 31 Aug 2020 03:44:39 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id l10sm9639574wru.59.2020.08.31.03.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 03:44:39 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:44:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v3 03/14] devlink: Add reload actions
 counters to dev get
Message-ID: <20200831104438.GA3794@nanopsycho.orion>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <1598801254-27764-4-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598801254-27764-4-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Aug 30, 2020 at 05:27:23PM CEST, moshe@mellanox.com wrote:
>Expose devlink reload actions counters to the user through devlink dev
>get command.
>
>Examples:
>$ devlink dev show
>pci/0000:82:00.0:
>  reload_actions_stats:
>    driver_reinit 2
>    fw_activate 1
>    fw_activate_no_reset 0
>pci/0000:82:00.1:
>  reload_actions_stats:
>    driver_reinit 1
>    fw_activate 1
>    fw_activate_no_reset 0
>
>$ devlink dev show -jp
>{
>    "dev": {
>        "pci/0000:82:00.0": {
>            "reload_actions_stats": [ {

Perhaps "reload_action_stats" would be better.


>                    "driver_reinit": 2
>                },{
>                    "fw_activate": 1
>                },{
>                    "fw_activate_no_reset": 0
>                } ]
>        },
>        "pci/0000:82:00.1": {
>            "reload_actions_stats": [ {
>                    "driver_reinit": 1
>                },{
>                    "fw_activate": 1
>                },{
>                    "fw_activate_no_reset": 0
>                } ]
>        }
>    }
>}
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>---
>v2 -> v3:
>- Add reload actions counters instead of supported reload actions
>  (reload actions counters are only for supported action so no need for
>   both)
>v1 -> v2:
>- Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
>- Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
>- Have actions instead of levels
>---
> include/uapi/linux/devlink.h |  3 +++
> net/core/devlink.c           | 37 +++++++++++++++++++++++++++++++-----
> 2 files changed, 35 insertions(+), 5 deletions(-)
>
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index 0a438135c3cf..fd7667c78417 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -478,6 +478,9 @@ enum devlink_attr {
> 
> 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
> 	DEVLINK_ATTR_RELOAD_ACTIONS_DONE,	/* nested */
>+	DEVLINK_ATTR_RELOAD_ACTION_CNT_VALUE,	/* u32 */
>+	DEVLINK_ATTR_RELOAD_ACTION_CNT,		/* nested */
>+	DEVLINK_ATTR_RELOAD_ACTIONS_CNTS,	/* nested */

Be in-sync with the user outputs. Perhaps something like:
	DEVLINK_ATTR_RELOAD_ACTION_STATS
	DEVLINK_ATTR_RELOAD_ACTION_STAT
	DEVLINK_ATTR_RELOAD_ACTION_STAT_VALUE
?

> 
> 	/* add new attributes above here, update the policy in devlink.c */
> 

[..]
