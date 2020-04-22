Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97AF1B490D
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgDVPpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgDVPpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:45:07 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0885FC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:45:06 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id o185so1286754pgo.3
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4DD+JVncwTmAEStKVyfZ9DUvU0ojagsIv/+reSGEIz4=;
        b=onWM4lZSxHfxp/5tYXdSXP04Tby/zNCZwh5VYHG6ZVgwnubWXcBKfypMuCCNdUeYKI
         m9RdQuYM3mHFXHTAwLLgMGws9SwOtPlaALSB0JatV+7GI3daY9H4leFEmR+PEAsDI+3Q
         BBwJXv9ickyjH/zlOhFqF/6p1iNYZZ427+8PDqTc+/O9DCXvV+ermoe98/4233Iqw5te
         dzCeyBj5jNbsz6hdb8k1mqc0AwkoXSXa/3n1ACu2n6oBk+U86x6xd38/jAnAi58818yr
         X3XVTiXkXex1wYg+JqFvTVZpM9Bnbk1heBILmn71I7eeDDbZ+B6pkHssaEmVRK1h4v2I
         xclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4DD+JVncwTmAEStKVyfZ9DUvU0ojagsIv/+reSGEIz4=;
        b=Je2oDC/GdZvzqDD1jumyZ3UTxlfKL6X9y3prIOaePx5xdkju+0jXG/s7FgxwJtswJ9
         D7RRJTnNC1obYhQgYxdKob1VY2FEsTnydZdgiZHXnxGTzLUhzLzHtTX6/IrVSNXvmf75
         kAuRZz/Qv0Ehm0L6qJNQS5WlB3212APrdNAtnYMyrGcm74bb3GKhtgpwJHhG4gTXL66w
         GVdlEgHLLdNGU2O3CxENHg8EESHKSeuQ0U4KsetPW6tsMU+7tztjwh3oEVjw8ZtDYpBg
         2uYme4emckBIZ9l5ewCpV8P0onqYmTBuGd6cYRCP8kZu8WH9Z5AMzfkq1YcsI2irLGyc
         MjqA==
X-Gm-Message-State: AGi0PuZgR2t3mxzgmJ4OIwpdIl0mfKTOzX/LTnCRSB3k0J5icEMgnc5W
        HWFPzJ7k+6retPYETpYEXNKhAxaq18U=
X-Google-Smtp-Source: APiQypI3xui7pZaNMdQ8A7/VjYyl7WlPMmst8JwhwBfYWYmzKTVvJom5zH0hFSusEE+w5C+2EfeIeQ==
X-Received: by 2002:a63:7884:: with SMTP id t126mr7179312pgc.45.1587570303868;
        Wed, 22 Apr 2020 08:45:03 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s74sm5603419pgc.50.2020.04.22.08.45.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 08:45:03 -0700 (PDT)
Date:   Wed, 22 Apr 2020 08:44:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Re: [Bug 207401] New: vrf fwmark socket
Message-ID: <20200422084459.0d31a65b@hermes.lan>
In-Reply-To: <bug-207401-100@https.bugzilla.kernel.org/>
References: <bug-207401-100@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like user error, not a bug.

On Wed, 22 Apr 2020 12:37:04 +0000
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=207401
> 
>             Bug ID: 207401
>            Summary: vrf fwmark socket
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.5.11
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: 1455793380@qq.com
>         Regression: No
> 
> add rule:
> #ip ru a fwmark 10000 table 10000 pref 900
> 
> and then add vrf and salve interface
> #ip link add vrf-1 type vrf table 10
> #ip link set dev vrf-1 up
> #ip link set dev ens19 master vrf-1
> 
> write a program socket bind mark 10000 to match the rule
> setsockopt(entry->fd, SOL_SOCKET, SO_MARK, &mark, sizeof(mark));
> 
> add ip and add route in table 10000
> # ip a a 5.5.5.5/24 dev ens20
> # ip r a 5.5.5.0/24 dev ens20 scope link table 10000 
> if I set src addr, then can't add this route 
> 
> visit the server,success
> #curl --interface 5.5.5.100
> but if I use the mark, my program can't visit the server
> kernel can't find my socket? return RST!
> 

