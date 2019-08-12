Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDBC89B72
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfHLK0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:26:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34859 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbfHLK0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 06:26:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so11287995wmg.0
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 03:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rDB5BKki8yIs6XgzMfPhCXxTJG2SqJxjPTFmL72epn0=;
        b=FdIUWMKjVhrglFeAbUe1JIoJs0PhUxrp3vzmvESFu0Tu8YQtbc9J/EJh7FDqPE4Icb
         p6opQNJq12uJAo5+hT6HjUBIXuTyovBcpDjvpUSM++UsRlTiXeNTccn9/Ni9A2ZOBcJ2
         2t5oSfa27NJ8jd2iZs3DUI8xSnhYvKuORAg/eyiDEk2NWGj87ER8xJgUIcuYmP3e3tNA
         esJzCCk6S0F67iRlvSVLpgeIE93+N5+OP8uBSaomazX8mWUsNLMHPeoRDriWOFRxpUbb
         dxHX4QY48XYqSS5mv2t0THtLNA5VKX6ca/r1MLmdanfYZTgvgS3Qi7Ee/3ArTUHyBMiy
         gFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rDB5BKki8yIs6XgzMfPhCXxTJG2SqJxjPTFmL72epn0=;
        b=JDcG4Wd+cMOl6u60jUG0RXQcZCHlPjMaBiSd6xr2hHDaMriTAx7M2pRQUCBiF4GLGk
         qUrcWRBKX9L/9kzrRSOdwb1bORKRVVRoYQbdh6h4njKqJlib4UeZ+/6LvQX/CCQyoAWw
         G/cFm+QFVUkVYngkqfrDeI/DG6GORcAMbNePRFD3BoHusX/M92N1oorn8VDLjicHYlRx
         A3ZEiki7ubsTVMQnXiUZ4QsHmApZvMQUUy2sbISeUbfNR+dz1fhx4cXqW0vhReuyh4lG
         T0x7FdPRKV5XmHm3EPUJw1BXWhEpHnMbymuzpAdvQ50yr81/548slWIJrcXIYFcLJ5JS
         anaQ==
X-Gm-Message-State: APjAAAW+Dpai58IjwBvuuwazZeY6AcY2ybPJL92e0IOL8bJ/ByFXY+fg
        cHy3WGDHzQe7SOkAhvnAZeRsHw==
X-Google-Smtp-Source: APXvYqwc8ukSsvrwQdh4Gd54LUo0ClrtTiyYtMf6fqeSrRRoGLLI/cWssn0Nbv9F1vmnjn1/+mIQ+A==
X-Received: by 2002:a7b:c187:: with SMTP id y7mr7935915wmi.155.1565605594643;
        Mon, 12 Aug 2019 03:26:34 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id x24sm15632848wmh.5.2019.08.12.03.26.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 03:26:34 -0700 (PDT)
Date:   Mon, 12 Aug 2019 12:26:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH iproute2] tc: Fix block-handle support for filter
 operations
Message-ID: <20190812102633.GC2428@nanopsycho>
References: <20190812101706.15778-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812101706.15778-1-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 12, 2019 at 12:17:06PM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>Commit e991c04d64c0 ("Revert "tc: Add batchsize feature for filter and
>actions"") reverted more than it should and broke shared block
>functionality. Fix this by restoring the original functionality.
>
>To reproduce:
>
># tc qdisc add dev swp1 ingress_block 10 ingress
># tc filter add block 10 proto ip pref 1 flower \
>	dst_ip 192.0.2.0/24 action drop
>Unknown filter "block", hence option "10" is unparsable
>
>Fixes: e991c04d64c0 ("Revert "tc: Add batchsize feature for filter and actions"")
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Thanks Ido!
