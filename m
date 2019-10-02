Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0144C9041
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfJBRwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:52:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40327 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfJBRwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:52:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id l3so21915wru.7
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 10:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SKkHWMf4Nb1N8S24JeSwPqfZqBt8SCCbec2tMPEeKiU=;
        b=DkMqUYgECmQGOAH402VUbCJeOsj19hSRlZ6ZEWIntRJEnVVcDxVP4jPPBovTuPqwAJ
         XpsOHxp/FlE75xIOfMRtKlSpO+wqJsaLHhG2+8NSB9PdSBO5f5d8t95YkQdWYpdbyyIH
         VAqISepym1nDR82WQkfCRvZClUgjxkKuUIf0eY+oPazYEERF6tN9klT4jsOGslMRvM1D
         UjI0+IM2jhE/kSrc0M643zDi9tkwp4QvfTqk+AzdIve6WQgx6ZPZ2LBASi2Ivv/XY0nZ
         0VpCej207C299wBxxE5johHM2mdvMc2WsfTEIHMh/DvzC5olx9ZnWuUsL0UzdfB3XXl6
         lOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SKkHWMf4Nb1N8S24JeSwPqfZqBt8SCCbec2tMPEeKiU=;
        b=b0B0jdBvpAX4a1Kl4g1ldsskv+qOViuNcNTq0s8DV7Xi6LYMW7JMdsEsN6s+OoG/v+
         vkMhwC39PX5Mos1PO/bex8rCM57hTY2PZCtR9xerr612eEoFw89DM5/yKilcux+fDoHs
         IUzMNZ3AycrZyNWT89HPEUbgz0McVX1M6oPU/HOTk2dAOxi9p6fe5PvUwE/QpfRiy3U7
         QnBdHs51MnTyTwd9jzEaL3/qGsRhi2l+CmhTLhqOgcLguIqK6sLCQ1UkzDuRW8dgk/xs
         JJiao9HEMoySZVsqtAgSzoICLyOIovDIoZG9l//YxaRqYXaUYMivA5slmwTfVQ3mPqkB
         9XLw==
X-Gm-Message-State: APjAAAUMZmw0cPY/Xepw+YQ7W1k/VW2KWmZfvN3hlTnB8Tf3OIQ/WUFr
        DuyTTVGX9aZtE0MbQ8n+OZYXAQ==
X-Google-Smtp-Source: APXvYqxkwqG0K/+Zq/9pAXBTnXQevRxWWWT/yAiYxMNV3/mtsfvzHS4Vmd1bDd+hcoQbHNcUD1k2Zg==
X-Received: by 2002:adf:b6ac:: with SMTP id j44mr2864040wre.156.1570038751374;
        Wed, 02 Oct 2019 10:52:31 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w125sm13661914wmg.32.2019.10.02.10.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 10:52:30 -0700 (PDT)
Date:   Wed, 2 Oct 2019 19:52:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 08/15] mlxsw: spectrum_router: Start using
 new IPv4 route notifications
Message-ID: <20191002175230.GC2279@nanopsycho>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-9-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002084103.12138-9-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 02, 2019 at 10:40:56AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>With the new notifications mlxsw does not need to handle identical
>routes itself, as this is taken care of by the core IPv4 code.
>
>Instead, mlxsw only needs to take care of inserting and removing routes
>from the device.
>
>Convert mlxsw to use the new IPv4 route notifications and simplify the
>code.
>

[...]


>@@ -6246,9 +6147,10 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
> 		err = mlxsw_sp_router_fib_rule_event(event, info,
> 						     router->mlxsw_sp);
> 		return notifier_from_errno(err);
>-	case FIB_EVENT_ENTRY_ADD:
>+	case FIB_EVENT_ENTRY_ADD: /* fall through */
> 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
> 	case FIB_EVENT_ENTRY_APPEND:  /* fall through */

Why don't you skip the three above with just return of NOTIFY_DONE?


>+	case FIB_EVENT_ENTRY_REPLACE_TMP:
> 		if (router->aborted) {
> 			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
> 			return notifier_from_errno(-EINVAL);
>-- 
>2.21.0
>
