Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE5726B81A
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgIPAgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgION1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 09:27:11 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0884CC0611C1
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:26:17 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t10so3360451wrv.1
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nj5427NwfkAcod/jrpxPO35Ai9seXyFseb14ybySFfM=;
        b=QdJ2+kJmwNT2Rpeynd20wnfA2n5PgwvW8q0QlYHqLR7ro3Toewl4315Be5CVsKBHZh
         OMgk03EvoactAAXW/p2vTIkFSHggeL09y0WS6v9YSbB5sBgKsBc1LIwTyxViUDecSze3
         j7f+9+k8UuQGNij/vw1YOL1TLdZVVCsB2h7SbbdsQ+jS/hUhlDRzEDXUbI2eUs+mc6OX
         1MpflgJ5M/nzMSdaRl5D72mgdrbnQSgo3t7miz06w0bL1d2D2xEIGYCzQk0+AHzwq5H+
         cUsIogqEoCMxr3MR+pxkoSQt/LNuvKx9fizekZYmIyA2x+ga2SG3eGTbcZVJX6UYvHLc
         Lj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nj5427NwfkAcod/jrpxPO35Ai9seXyFseb14ybySFfM=;
        b=F8+WX5gjbekESlJ287h3hfwTHIXtO/uTK5IEvh+IYSzBBZC7y+jgmjVkG6AND8KAXJ
         7LQbsYXc+VecHvhZyO55sMjckXrfN9Vw9q1Wjue723FmRhgcyDqvFy05BiKg7s/s/iy6
         OGpVNO+GmzgJOapPqOgVkYAxQo1+OJqU1EmLjPrHrrpDyp8EAsTWsw2jnNVvPVJsGk4G
         XKljR7RfOGBVNaWtJB9cy3SpoIHMAJFr7tdgNLuBSvnwZInyUgySjISN2wPhKWXdH8SB
         0yof9LCEOc3lvaqxiXA19Ha6+/4qPaAi3UrD52SAmv0Qivh7Cx5/A+A+FodrVoICjDsn
         Wb9g==
X-Gm-Message-State: AOAM532O6/xcToATX8rtv8N3CUaXNutojL+S0TFkGVXjETun7PnaDF/o
        7YfCqPEeiYPoImyd4tDUM22+a9hq6/6AozuN
X-Google-Smtp-Source: ABdhPJxUX3SywtAgbIzvAPBC3VuqGFTB/q/j/ez9t1LNPTmXjvJgQ8L9UOasQDwBRHrHUf+PvOb/og==
X-Received: by 2002:adf:d4c7:: with SMTP id w7mr21860249wrk.263.1600176375639;
        Tue, 15 Sep 2020 06:26:15 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id m4sm28137345wro.18.2020.09.15.06.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 06:26:15 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:26:14 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200915132614.GN2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-2-git-send-email-moshe@mellanox.com>
 <20200914122732.GE2236@nanopsycho.orion>
 <996866b1-5472-dd95-f415-85c34c4d01c0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <996866b1-5472-dd95-f415-85c34c4d01c0@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 15, 2020 at 02:12:25PM CEST, moshe@nvidia.com wrote:
>
>On 9/14/2020 3:27 PM, Jiri Pirko wrote:
>> Mon, Sep 14, 2020 at 08:07:48AM CEST, moshe@mellanox.com wrote:

[..]	
	
>> > @@ -7392,6 +7485,11 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
>> > 	if (!devlink)
>> > 		return NULL;
>> > 	devlink->ops = ops;
>> > +	if (devlink_reload_actions_verify(devlink)) {
>> Move this check to the beginning. You don't need devlink instance for
>> the check, just ops.
>
>
>Right, will fix.
>
>> also, your devlink_reload_actions_verify() function returns
>> 0/-ESOMETHING. Treat it accordingly here.
>
>
>Well, yes, but I rather return NULL here since devlink_alloc() failed. If
>devlink_reload_actions_verify() fails it has WARN_ON which will lead the
>driver developer to his bug.

So let the verify() return bool.
My point is, if a function return 0/-ESOMETHING, you should not check
the return value directly but you should use int err/ret.

>
>> 
>> > +		kfree(devlink);
>> > +		return NULL;
>> > +	}

[...]
