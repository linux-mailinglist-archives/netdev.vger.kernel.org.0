Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C1B16C1A9
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgBYNGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:06:50 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38602 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729181AbgBYNGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:06:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id e8so14664318wrm.5
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uMjhr8CMWX21ynVJVCnTzKkHtTnq0PDF47au6rdT/nQ=;
        b=xz6KmNkK/lHhlnyw2oikBfjwgiFERtVWum9ciRHolZ7CEkp1ZJSYhrecY4iYbaJ3DN
         hRrD+zuzyRgxzJLrDiDAwDO9t9GHOainLRXJlillHMi4led/g/3ZawzpDt7RwYi4vtxe
         DtlfzUHEatOoLGQnXjpNSisijiJvcc0m71D8e7qZeEpWG+DgeVENJaXVdv4VS1JZGRtX
         bLZgsah8Hxihi7TjIsvj75xjcw7negQb3RkjNAkfOwRHObuT22b+zZZ5e8hGBLmvNr9I
         E4OuHGm7J/ZH3aDcZodqk2eoTsS51nckhzmHZTcFaysuHLYA1N8JQOp/eNbM7SkQsRx3
         om2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uMjhr8CMWX21ynVJVCnTzKkHtTnq0PDF47au6rdT/nQ=;
        b=LCz7IqOmOrnCjW+O+4ZzjdQ/jS5MjJZKO7MngIL0ABRPAfE3WwMwwRozpJLDbfpmj8
         Wi+utC1f4Oy2cmcl9HjfKLclF5EegMCxUHAuHSwAiFz17FNeSAipwSDlijsx+yA9oy8J
         H/qmtnCoSU9sjf8f62Lw4t0ADoegaraxKlhhagDWDZFjP/wKa237wpVfwPsNb1uS+7/C
         Rplge1xls0dDe8I0u7WNA/vg91a2DxAbY/Is2EoNPzlIuZ+wlh2m8sKJ5QKom7hasIb2
         xWmwSb7H9sFECPbglKqV0keLuXlsughSsX/junbKva42TQM/be+xJHs/EhkrrnxelPHX
         V/kg==
X-Gm-Message-State: APjAAAUIk2toKBGpoY0yHg3c2DcCIcYOsTdNSLvwstfpRRuAGiqaKl9a
        Sz7hMPG4ZIDmfaAQwbwva1XVNQ==
X-Google-Smtp-Source: APXvYqxavRUvXtPThejGl2mpg0JIuneJtxsS5/rFce8Vy/41DqKJfXTbqBZl7KDpyOoc1duWXrlehA==
X-Received: by 2002:a5d:51ce:: with SMTP id n14mr74348991wrv.426.1582636007795;
        Tue, 25 Feb 2020 05:06:47 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id l17sm23554997wro.77.2020.02.25.05.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:06:47 -0800 (PST)
Date:   Tue, 25 Feb 2020 14:06:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     madhuparnabhowmik10@gmail.com
Cc:     jiri@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, paulmck@kernel.org
Subject: Re: [PATCH] net: core: devlink.c: Use built-in RCU list checking
Message-ID: <20200225130646.GD17869@nanopsycho>
References: <20200225122745.31095-1-madhuparnabhowmik10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225122745.31095-1-madhuparnabhowmik10@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 25, 2020 at 01:27:45PM CET, madhuparnabhowmik10@gmail.com wrote:
>From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
>
>list_for_each_entry_rcu() has built-in RCU and lock checking.
>
>Pass cond argument to list_for_each_entry_rcu() to silence
>false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled.
>
>The devlink->lock is held when devlink_dpipe_table_find()
>is called in non RCU read side section. Therefore, pass struct devlink
>to devlink_dpipe_table_find() for lockdep checking.
>
>Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
