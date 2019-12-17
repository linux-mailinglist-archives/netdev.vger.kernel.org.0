Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8AB123292
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfLQQeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:34:02 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45794 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbfLQQeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 11:34:02 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so5935870pgk.12
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 08:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ft1GYk/y8jCgUBo06Osu1DtVzvj7ZLOoenzt201JqVk=;
        b=OM2txkwaLeAlCObnPlC58dtcZQSSZ1uzrFM8PaqYgSwJ+zGQqa5TiWGrAS2H78qUMA
         4I39NC96NpU7t96jK47AaquRlsXjBiHUtJPMLI2cXB/XMMWHYGSAYWrY/oS1S7DEQBfQ
         BhMBh6deaaHhvJTBMSUvGSn4/AgoTlXRU1tn3v2kFSOzsZCy67bjQq6Wj+WmxAw2JLfF
         V1isTmETQgnCxxTKBGfg9Ou99/Gc783tFJBgZN3BkLvsClJ1pFb5+vdOj7kePar1+kuC
         Nx4B51L6YarrwtueJCnmNs/y1KDPp+9kEKdp/caEJCPw/R8FiLBdj/qbuZ4NJwdMwZf8
         LLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ft1GYk/y8jCgUBo06Osu1DtVzvj7ZLOoenzt201JqVk=;
        b=OnwaCBueClCMUlOOJzRjY9C/7BS/LvsmePsOfJ8LfH+joQ/7apzbee/mLTZnc/crR3
         0rxEdW1XIsIkM+btDVeVDFVo2Dh+WDJoy3V9EEMogDRjw5kukh6HDH9c8/PY0e1teWuk
         hCLZOCon3T9yJzYZd3C5h7A4pdRVImYLaymgSeeCri6luljs5bM/Xu9uIpNkfmZKcwZn
         Yl7b9p/HA67AVJKBTwBjssTEgdkKLGjyOYXoHzy0i5WOdgqlQuVsBl7IOSh3BTABXkGt
         04z+qOHWINZ/9Up2TAPCWL9F8rWCAdFFJNH53N0zZtoKBS9NyctkX2j0FgiKj0pW2v8s
         dtWg==
X-Gm-Message-State: APjAAAXPbswdUpjztZWk+qQlwA6vBXcjkOTVA81mM2i6oaGC6xfyWOvT
        qM2eI2wBuux+aH0khi9R+lhrQA==
X-Google-Smtp-Source: APXvYqxhOZ32P0IKzozVAlpT6zTyX3Gt9HIVDk5KR9Za2CSxN26IZN1nZbBHJDojacC/rGtMPNwPBA==
X-Received: by 2002:aa7:9d0e:: with SMTP id k14mr23209970pfp.157.1576600441783;
        Tue, 17 Dec 2019 08:34:01 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w38sm27658985pgk.45.2019.12.17.08.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 08:34:01 -0800 (PST)
Date:   Tue, 17 Dec 2019 08:33:53 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        ayal@mellanox.com, moshe@mellanox.com, jiri@mellanox.com
Subject: Re: [PATCH iproute2 0/3] Devlink health reporter's issues
Message-ID: <20191217083353.7690ab7f@hermes.lan>
In-Reply-To: <4a75df49-e3c9-7b67-a0da-94dda9b06465@gmail.com>
References: <20191211154536.5701-1-tariqt@mellanox.com>
        <20191216205351.1afb8c75@hermes.lan>
        <4a75df49-e3c9-7b67-a0da-94dda9b06465@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Dec 2019 08:08:31 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 12/16/19 9:53 PM, Stephen Hemminger wrote:
> > Applied, devlink really needs to get converted to same json
> > library as rest of iproute2.  
> 
> We have been saying that for too many releases. rdma has fixed its json
> support; devlink needs to the same.
> 
> Maybe it is time to stop taking patches.

Or add nagware patch :-)
