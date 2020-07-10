Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B18721B153
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 10:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgGJI2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 04:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgGJI2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 04:28:46 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4091C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 01:28:45 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id o4so2729305lfi.7
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 01:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:to:cc:subject:from:date:message-id
         :in-reply-to;
        bh=GrjbxWMAKXfbAtZgrBEXxSVKyG6N19KJkG4uDcoEJNQ=;
        b=lfSexOPM4y/x28CEOvkvvFIIl24KYR1wyTFuV3itnehGwF1cgYQuJtEYJo8UEqtw9R
         R8/HjjrKi+v3DaOgHEnOZArHkiXFaOgJ2HUtzWl3V+MgLg6kynSvowsScS1bNcMCafSY
         EUcsKg3DpOsOXqcymJ6mx3b4lpAkwJoycaUIxo9v1urfRw2shvokb1YpmLS+LyYr7ufc
         AvTUFpgJbm5POLsKM9yXlB+1wSBwu8t6AjMd1GRwe+NzSEIGOS7uu83gQnT0GTpW5160
         eAkX7k0iDwC7f/f9qv4TnqiDVeQsDS1MTm9IlCu1xXchxeEAm+3y89GdKDVyNbkmo7Zp
         TEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:to:cc:subject:from
         :date:message-id:in-reply-to;
        bh=GrjbxWMAKXfbAtZgrBEXxSVKyG6N19KJkG4uDcoEJNQ=;
        b=IGU/wBwchuEqImYmTkDXklQ8C1Xyyjl7lz2ip6kTxO3+uShUlEg50gdgVoL6ZaJyVq
         rCLNgiOmSCZCJzM2fIKQG+nxmC6b16+wg4Y4ZpujurVFN6Qn5fXqR4e/8ASpgZ/fiUbn
         L2DrzRtd64wV1YWsnxuyQLelrtZ7YUwkkhxuNRbxVCU9/Bo8xbc3S6gRxDS+hj45c2tt
         XsmheXAyOdeCDknJRIVgJi6da9Uf7lHTrc/1mPSKll3x/tA7f/7Ai6DnGZqLUfp7Ww3V
         ckipk/4IO98UXYBc00buXSOd+j4wjOKxb5ZTHgTGqJXswUE8XVjc2sz7NJ51TkvPxHz2
         MW7w==
X-Gm-Message-State: AOAM533tDXE9sM7k4kWNLhIlPOl6WxwN1qHxpM8DrMcgaIo+2tTnVtn4
        Ke9BSF0zq9nuTQ10QOl0pQMgZ2jKB3bZ6w==
X-Google-Smtp-Source: ABdhPJzPtzX/963oqWdy0ZvPlHn6vjOHkSGmyC1YGP0Za4Zcc6ZdksDCyfP/m3RW0BjKPGupkM0ygQ==
X-Received: by 2002:a19:f20a:: with SMTP id q10mr43151888lfh.89.1594369724159;
        Fri, 10 Jul 2020 01:28:44 -0700 (PDT)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id 2sm1898355lfr.48.2020.07.10.01.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 01:28:43 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To:     "Vladimir Oltean" <olteanv@gmail.com>
Cc:     <netdev@vger.kernel.org>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
Subject: Re: MDIO Debug Interface
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
Date:   Fri, 10 Jul 2020 09:51:44 +0200
Message-Id: <C42S3ZZ1E08V.CJ83S0R5R8CY@wkz-x280>
In-Reply-To: <20200709221800.yqnvepm3p57gfxym@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Jul 10, 2020 at 3:18 AM CEST, Vladimir Oltean wrote:
> I will let the PHY library maintainers comment about implementation
> design choices made by mdio-netlink. However, I want to add a big "+1"
> from my side for identifying the correct issues in the existing PHY
> ioctls and doing something about it. I think the mainline kernel needs
> this.
> Please be aware that, if your mdio-netlink module, or something
> equivalent to it, lands in mainline, QEMU/KVM is going to be one of its
> users (for virtualizing an MDIO bus). So this is going to be more than
> just for debugging.
> And, while we're at it: context switches from a VM to a host are
> expensive. And the PHY library polls around 5 MDIO registers per PHY
> every second. It would be nice if your mdio-netlink module had some sort
> of concept of "poll offload": just do the polling in the kernel side and
> notify the user space only of a change.

The current flow is:

1. User: Send program to kernel.
2. Kernel: Verify program.
3. Kernel: Lock bus.
4. Kernel: Execute program.
5. Kernel: Unlock bus.
6. User: Read back status, including the output buffer.

(3, 5) is what allows for doing complex operations in a race free
manner. (4) is capped with a timeout to make sure that userspace can't
monopolize the bus. A "poll offload" would have to yield (i.e. unlock)
the bus in between poll cycles. Certainly doable, but it complicates
the model a bit.

> Thanks,
> -Vladimir

