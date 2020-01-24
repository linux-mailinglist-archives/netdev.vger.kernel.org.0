Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF05148AE4
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388003AbgAXPGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:06:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42745 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387432AbgAXPGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:06:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id q6so2350102wro.9
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 07:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UKKUT0BWlOSRHDW887ntedKd6OnWC+G3dYPZsDNED08=;
        b=Fr0o/OhBivjMOVT/SaKeh+nC/zsUa8+k3wKUfNMUNB4w2vMkSANTbs4z3lSmYrs/gv
         Scs8vgLR1Kw3SKQIpa36o1rek+usdL1nM6w20G8iGCkvmTHq11lpZ8NahXfOWbdtEtWL
         A83TnbquANEpG3Bf2wuL0WUzdN+VoibYVNGnt5OE57zfebx8cV1Kf4/lSlghzbslt8H1
         yNvYK7KmAoABzLYlKnEpu3hFgw8+G4GZIP35AbkItnlzDyPu8/BYYxnXe4c0+uyabWKo
         gvSl+N72UbyhuuO+JkJBTU2OetYd4I+aSUnhewz0d8TkGBBZgSLLyoxKhA89o4LVsqkw
         94EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UKKUT0BWlOSRHDW887ntedKd6OnWC+G3dYPZsDNED08=;
        b=e+X3boqIWB2io/hpTAWj2Jt/qKI2VQzut/4gIANI9q0b5utImIfvygQLmDX7MHOUvZ
         nzxejYVMHNrD0mkXKclop8DWYcEmcviljmcHwwgzI7gI7xgVKdFTPdi8EfSNiFv7ZVdk
         3muShVg0l79VkV6mn4mHJGLOw/Jz+jztlIZwU9UlP15qLUIXIQ4MdYHGv3b2I9+SKeII
         TW4o6x6yPA1zjiNTWt4XtRFpmCuzcsDi8YQc2fjmODAPc/DXhn9MSSB7dFrwPvhCR6gt
         WA49562dsWu9z28WMi1IITYLYlOK7vToRdtdVCLu0mItz/F3J3PUg/nc5NsHn1KyGUUG
         eebQ==
X-Gm-Message-State: APjAAAUi0HlR+8TpNY1PSPq4GH5SDxFw70xgF5kzv3gqUhFHxB3Bkrvu
        qVCbOmot1VSt/bXcfje5CvJx3Q==
X-Google-Smtp-Source: APXvYqyaHBqJfRHmRlFxEbIUZ8tMaAt+UJMk12qMRPdhDXStPks/9Tb3SYxWFnSbbkFYqTjsci3d6w==
X-Received: by 2002:adf:c54e:: with SMTP id s14mr4588949wrf.385.1579878391099;
        Fri, 24 Jan 2020 07:06:31 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q3sm7781573wrn.33.2020.01.24.07.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 07:06:30 -0800 (PST)
Date:   Fri, 24 Jan 2020 16:06:29 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 08/14] mlxsw: spectrum: Add lowest_shaper_bs to
 struct mlxsw_sp
Message-ID: <20200124150629.GF2254@nanopsycho.orion>
References: <20200124132318.712354-1-idosch@idosch.org>
 <20200124132318.712354-9-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124132318.712354-9-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 24, 2020 at 02:23:12PM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>Lower limit of burst size configuration is dependent on system type. Add a
>datum to track the value. Initialize as appropriate in mlxsw_spX_init().

"datum" :)

>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
