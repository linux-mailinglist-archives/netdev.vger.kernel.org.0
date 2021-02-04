Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B38230E9AB
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhBDBwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 20:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhBDBwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 20:52:07 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C113C0613D6
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 17:51:27 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id a12so1887123qkh.10
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 17:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pbFyeyTgMq/YfVxfYlhMlQPUwLskoiC4c9TMqZHDxPo=;
        b=F1RgP3UXg8cX1ARBxMkssTInDHMJRhPPoK/5BNJ8GL6nlBwJ33bucbrExm1ytAtbGm
         HbgxT5L/fIEsVhBw97S0p3GZZmeEO2XJ9BUbILKQ4DoLFeXP/ywx/uT57lpLO6wy32tE
         KUKZJwdwrAtBBbTAMKC8oIoImmz1BRraHReMFmry0gU5bd6r8muOqDR2+cnXmair2ZtD
         +jfR2t1rWO5IPVTCQwiiU1o10aVnWGHVdG/ucwSduBzyOfXxaHtYr0UebMIi4w+rufPx
         7dHcwI6sijMXZv18hAOQV+kLRRLtxtxQbIzU49TK6PK5u6SZ8/4DH+q/E0UjLqcwNgxb
         5Tgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pbFyeyTgMq/YfVxfYlhMlQPUwLskoiC4c9TMqZHDxPo=;
        b=LDt2WoGYju7QoRD4K/HqS8PV+SXCSTmStDVwVJg2ai0ryNtEI7pWUUzsTWZWfk64Lt
         swehn8AqnxPPXR4OvCnKE4lgbYLYHl4WVtp4R6+dYJaNuFWNSBy3peZyRcZDFKEjY/Kr
         q+NEd4NkcrqvzSX0784KctkEKQZ+Q9T7jsV6i11GIRmVcnd+D4yaehyxd+6zqc8P1JU6
         uaJlRDEOVEC6SJwZdTq5yVUrIJ5VsSNQ+HgzA3ub6eMVo9OsBOJa4KAXBdu1SZb6B5k4
         3140BR52xHUpfSE7PXaL8W437xwlGdiOGRqU1HOQqAqTw7HHuGu5kzNcAEU6VOFxnrgb
         8/Yg==
X-Gm-Message-State: AOAM530/Lz43Brsc2MS81nuDD0NpRJ8HglQlfeqONTHTytGhkloj0lpm
        rpSjCMPWoLFDhqZIJFNrREI=
X-Google-Smtp-Source: ABdhPJyeof5MJYvRQXWM/+A540ZBA1bgwwJy8qanmLjOw0tUezP/0kt5ym8eMpKagWtDQYM1Oo6Uow==
X-Received: by 2002:a05:620a:5fa:: with SMTP id z26mr5566022qkg.108.1612403486518;
        Wed, 03 Feb 2021 17:51:26 -0800 (PST)
Received: from horizon.localdomain ([177.220.174.167])
        by smtp.gmail.com with ESMTPSA id s129sm3625249qkh.37.2021.02.03.17.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 17:51:25 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 2FBAEC2CDA; Wed,  3 Feb 2021 22:51:22 -0300 (-03)
Date:   Wed, 3 Feb 2021 22:51:22 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2] netlink: add tracepoint at NL_SET_ERR_MSG
Message-ID: <20210204015122.GN3288@horizon.localdomain>
References: <4546b63e67b2989789d146498b13cc09e1fdc543.1612403190.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4546b63e67b2989789d146498b13cc09e1fdc543.1612403190.git.marcelo.leitner@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 10:48:16PM -0300, Marcelo Ricardo Leitner wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> Often userspace won't request the extack information, or they don't log it
> because of log level or so, and even when they do, sometimes it's not
> enough to know exactly what caused the error.
> 
> Netlink extack is the standard way of reporting erros with descriptive
> error messages. With a trace point on it, we then can know exactly where
> the error happened, regardless of userspace app. Also, we can even see if
> the err msg was overwritten.
> 
> The wrapper do_trace_netlink_extack() is because trace points shouldn't be
> called from .h files, as trace points are not that small, and the function
> call to do_trace_netlink_extack() on the macros is not protected by
> tracepoint_enabled() because the macros are called from modules, and this
> would require exporting some trace structs. As this is error path, it's
> better to export just the wrapper instead.
> 
> v2: removed leftover tracepoint declaration

Whoops, missed a blank line here.
Please just let me know if I should send a new one.
Thanks.

> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
