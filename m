Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3FC13AFAA
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgANQlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:41:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38608 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgANQlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:41:05 -0500
Received: by mail-wr1-f66.google.com with SMTP id y17so12868748wrh.5
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ngd4qYhZ1zXUkRbvokq79C6x3EYSwls44VJ+DlmI8u4=;
        b=hNtMaUoA36PsyuNRsETTinpw/7/r6sjiYXC4LGeLgPDiR0Hj9Ek8toSM2sPkuRRjQT
         B5+pT3pPT7CTi+gmENWWwpOuNiionrdHDPV9RqYAkMsfU2OizhtZta6GhpLHBJVWhIkR
         ttn3rYeyiAV5XMu2WTadA+dtMCJUri7n+aQTKsSwKoGKzbddSoUWADrkxQecc2ESlxk/
         62BwxBW3Hm+9MUq71Jd4Z4CbKFpAxbU+5Hb8k1THfNS885fbZpzyNtp4RZtyaipRoetS
         IrjuLHj3zVSGAYFLEBCu6eOaSYhT4yOatsucPAmRtblzz9guL3Xpn6FIS+4h7c9+VEw0
         5cAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ngd4qYhZ1zXUkRbvokq79C6x3EYSwls44VJ+DlmI8u4=;
        b=lm1YensT7oyMnqHyaiA6xNMm1kKPBz5LzVtxIfyh1TOAGiaM9WwTGLmJtp6rZqd4CY
         7kZ420Mm90OH70NjsRi5dDISWQAQp0UJzQ9TRTlSG45hxPfvXzgLK9TyTC1kRTiw/5A/
         SFv/lhPICRZGADu8ylHMYsWyMyZByfyleB9O02HZ4D+U393p2j/VhYEULweZAqewQS1J
         7RAfeO1R52j5U3HbSSHb5W6Or7Cbts5nUBafGC4DEK+ZyRhOziR4DkCFPKAxAporQAa0
         u2rlIOrj0XlYZFw7atNU1ecsqqNAtMqm4PznShWV9sBv2PhyqU77f6pZHqrFWaEDo8pD
         TL0A==
X-Gm-Message-State: APjAAAWOSlUwo1cUk6hHtqTvqY4Jo1icMXjQ29EgnQRxzZHoL/WDFTx0
        M1oK0rajSNI/GfDorj9ew8Ezr/UqERimRQ==
X-Google-Smtp-Source: APXvYqxjoaffa79oKzg+eg0blUxg4MO8yh2bToqhn8BUY3YyAcY1bflN6BEOiaJxr9z5MXlgoAIdtA==
X-Received: by 2002:adf:f54d:: with SMTP id j13mr26562069wrp.19.1579020063632;
        Tue, 14 Jan 2020 08:41:03 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id b137sm20524429wme.26.2020.01.14.08.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 08:41:03 -0800 (PST)
Date:   Tue, 14 Jan 2020 17:41:02 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 06/10] mlxsw: spectrum_router: Set hardware
 flags for routes
Message-ID: <20200114164102.GO2131@nanopsycho>
References: <20200114112318.876378-1-idosch@idosch.org>
 <20200114112318.876378-7-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114112318.876378-7-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 14, 2020 at 12:23:14PM CET, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>Previous patches added support for two hardware flags for IPv4 and IPv6
>routes: 'RTM_F_OFFLOAD' and 'RTM_F_TRAP'. Both indicate the presence of
>the route in hardware. The first indicates that traffic is actually
>offloaded from the kernel, whereas the second indicates that packets
>hitting such routes are trapped to the kernel for processing (e.g., host
>routes).
>
>Use these two flags in mlxsw. The flags are modified in two places.
>Firstly, whenever a route is updated in the device's table. This
>includes the addition, deletion or update of a route. For example, when
>a host route is promoted to perform NVE decapsulation, its action in the
>device is updated, the 'RTM_F_OFFLOAD' flag set and the 'RTM_F_TRAP'
>flag cleared.
>
>Secondly, when a route is replaced and overwritten by another route, its
>flags are cleared.
>
>v2:
>* Convert to new fib_alias_hw_flags_set() interface
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
