Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45598B2C0
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfHMIoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:44:11 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41328 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbfHMIoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 04:44:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id j16so4707371wrr.8
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 01:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LQm4Ic45ZrafypeUw0NSICsZTlTAIlQ4K8mIS4UymOE=;
        b=jEaftarh5PuYiFBQXYcOcRol5xh9LoQIjAAYaePZYurYMja6nJIlTPGGNHM0NPTTI1
         QLtR7YjN5SIOto9B7daIY0ldApNl656CY8WiWicKMePrzFAuKU+QiD+a6Qe0pJVewesO
         lB8bDQ2fpvEJZMQRlj+NdL4dX9jQ4yxav6P1ztUiI6CUi/LDcSeSEtK6kRQ8F7DonSzc
         Z58+8ydLZ/TFACi/6hN0FOVgwVYMJ/aqp8T6WEw0VIlr4j7rVfL3kTNn5hckBfIH/dzp
         XskR3FJ24y8GJ+YrwdL5ffiRWD3hZ1p6gMcPPrEYqEYe/FTStbcYVwm3Oo3eJGyHJDSD
         CU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LQm4Ic45ZrafypeUw0NSICsZTlTAIlQ4K8mIS4UymOE=;
        b=a0RKsd2T9VUXWrRWzXzUbz4TuY6m1Opwy6Dx6HAhTIWeFCTMqdGpqwWFBA8J1zI8fU
         5IoR1qqd+dsaJb/9UinPBC37Oujh19Ii7jIH9iiG7nVEhvH0RSHPMMf6XtpeEt26CEbr
         kUOnTwGZgzHldEt/xKV9zzX4V++bwDmJGnyQVl0PZRHQXo9m9NEePLLoCPr0zdfLS4Cz
         QMy1A6A+oOyOq82AcpaQyklILhG+ku8gNI27eou7L6jukA1DwVYcD50Xe94kbdRiZ2LY
         K7VvABOcgsaUjAjDChwitosEhVqhWETC9HhkzJLWTL7aaG8LmQY6wn0TE+xRTvOz6QDj
         BIgw==
X-Gm-Message-State: APjAAAUuoJwccsC/aqCOIowl7S1o/YcURNihKSmcpE/860PM8o+9aohM
        31NrIYvSTK9AYLWrXCIU1/fRQw==
X-Google-Smtp-Source: APXvYqycsijrJtW9JKuHhSXaY5AeayNxMdtzUJbkv0F5SE/WMhy6NVp0+Vs458ECcPI9O2D7zXHcqg==
X-Received: by 2002:adf:f94a:: with SMTP id q10mr42163343wrr.341.1565685849209;
        Tue, 13 Aug 2019 01:44:09 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id c15sm58977735wrb.80.2019.08.13.01.44.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 01:44:08 -0700 (PDT)
Date:   Tue, 13 Aug 2019 10:44:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 2/4] devlink: Add devlink trap set and
 show commands
Message-ID: <20190813084407.GN2428@nanopsycho>
References: <20190813083143.13509-1-idosch@idosch.org>
 <20190813083143.13509-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813083143.13509-3-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 10:31:41AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>The trap set command allows the user to set the action of an individual
>trap. Example:
>
># devlink trap set netdevsim/netdevsim10 trap blackhole_route action trap
>
>The trap show command allows the user to get the current status of an
>individual trap or a dump of all traps in case one is not specified.
>When '-s' is specified the trap's statistics are shown. When '-v' is
>specified the metadata types the trap can provide are shown. Example:
>
># devlink -jvps trap show netdevsim/netdevsim10 trap blackhole_route
>{
>    "trap": {
>        "netdevsim/netdevsim10": [ {
>                "name": "blackhole_route",
>                "type": "drop",
>                "generic": true,
>                "action": "trap",
>                "group": "l3_drops",
>                "metadata": [ "input_port" ],
>                "stats": {
>                    "rx": {
>                        "bytes": 0,
>                        "packets": 0
>                    }
>                }
>            } ]
>    }
>}
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
