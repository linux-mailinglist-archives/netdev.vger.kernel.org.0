Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A92A14103
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfEEQTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:19:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53656 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEQTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 12:19:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id q15so12833585wmf.3
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 09:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vOiqHdFs1erjEg6nGKi4AXR96/apyQnxT9DpaQesn3U=;
        b=zBIrz1U0oix8G+Fyhy0vNQ0l/WCi/LPkgwtJRhL6Fmbbc7qSBu7aph8n+qkDCDNkJP
         v7Kq4oYnmm/7FycXpVbAHhj+xi2vIUkfvm4b5i305I2YvzDBgnENCbvRIKDZoypdkSpd
         eYIgH/YfYqUaaqH3PPsA2HFtK7weorKnl0nHk3g6Bu650NeWfkldFeWJmMk+KhNzJquv
         waSIp08PKGcH5Uh3aK6O6yjdVtwl/O2jWyZDjGaSAK1xgI9yfydefopIE+4g8+AZZP0p
         NI7sPBnVNvRIf2XSS9olXsSQoXdYQ4knfPiL8IbXJ4x2sUgJkwqB647B/kxMXFyGTEdl
         Q6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vOiqHdFs1erjEg6nGKi4AXR96/apyQnxT9DpaQesn3U=;
        b=lW0WtZcBXW5lR0lpkWR+0mbtcOH/L2+CcWtiE8nberRbq2WBI8w9aEtikAGMsS6SkN
         Zn/NWPuzmCKNyZ7u8EuMLYYd7Xg/BcM1KtKGHtyAwKVtpN+baP2HgU3bT5ZS+/iHJb1r
         6BLWYVzXLtUGwH5eTOYc1K3VSvHjF/4h8aq+TQyv92+jjSxlmTy8EPpiviriyjkb9q4l
         bmkbQr584fcDyF19H0VOVUj65pCdqCGRx8BD11nu/bhxe1Ghh6R5eSLmM6wYQ4KXrT8T
         uv47cMugqFDyFjFQITqWolx+nEQnlcuE1X06ELTjz//cv+kyLx8brvhLVtySLw9Awd8M
         2Eew==
X-Gm-Message-State: APjAAAWlfYRCujatIDrANblAosK0dRoZ3mf+VlnYchT8kV2BF9//UOpd
        dguCN5d1btBBFLGS4Yk9Chf08A==
X-Google-Smtp-Source: APXvYqwZNsV5HR8YW37PwOr5lUnejDYLIT8bUlp9Je47uwTHg6qUIo3ILfse8j8/TBpTicThYCk+cQ==
X-Received: by 2002:a1c:6783:: with SMTP id b125mr14058572wmc.41.1557073162242;
        Sun, 05 May 2019 09:19:22 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d3sm15393875wmf.46.2019.05.05.09.19.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 09:19:21 -0700 (PDT)
Date:   Sun, 5 May 2019 18:19:20 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH iproute2-master] devlink: Fix monitor command
Message-ID: <20190505161920.GH31501@nanopsycho.orion>
References: <20190505141243.9768-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505141243.9768-1-idosch@idosch.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 05, 2019 at 04:12:43PM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>The command is supposed to allow users to filter events related to
>certain objects, but returns an error when an object is specified:
>
># devlink mon dev
>Command "dev" not found
>
>Fix this by allowing the command to process the specified objects.
>
>Example:
>
># devlink/devlink mon dev &
># echo "10 1" > /sys/bus/netdevsim/new_device
>[dev,new] netdevsim/netdevsim10
>
># devlink/devlink mon port &
># echo "11 1" > /sys/bus/netdevsim/new_device
>[port,new] netdevsim/netdevsim11/0: type notset flavour physical
>[port,new] netdevsim/netdevsim11/0: type eth netdev eth1 flavour physical
>
># devlink/devlink mon &
># echo "12 1" > /sys/bus/netdevsim/new_device
>[dev,new] netdevsim/netdevsim12
>[port,new] netdevsim/netdevsim12/0: type notset flavour physical
>[port,new] netdevsim/netdevsim12/0: type eth netdev eth2 flavour physical
>
>Fixes: a3c4b484a1ed ("add devlink tool")
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
