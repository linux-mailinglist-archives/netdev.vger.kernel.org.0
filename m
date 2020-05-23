Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FF21DFAD2
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 21:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387867AbgEWT5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 15:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387593AbgEWT5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 15:57:16 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BFFC061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 12:57:14 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 124so421290pgi.9
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 12:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jvC/xylAGop8ot4wxFDd8uyY/ZNsoNYZvJNvbpx1fV8=;
        b=Rq88C1srxKHjibZ9I57daO4FMtllHmKPNRzOFKAsG/gFXSFa+aL6kqL/1ZCMy9/yRH
         /XgRhnORhhxuSNqHnIc4Hq9f4K87I3XHWtrKSa4uzIWCIaccYBgDgJK3cbzT5bVrWYk1
         Dmt9HM3/lY+GB1LkbHm1hJJDBynmzEy9YzWNk2skshuzgD+kDMjObEMq3KlHkJ5mG3eZ
         qEQqbpoo0nNx5cog3EH4dx4chOtljPsc07xMKJOf7CWRfnR7aI9W9jbY3D6/YUDW0jE6
         vl0yiWWZ3xLdeVkWN3ltp8HB7d1oGmTHGdRqyqit8qp20L89NiK2EpB0ZEQ+gio7uhgC
         dD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jvC/xylAGop8ot4wxFDd8uyY/ZNsoNYZvJNvbpx1fV8=;
        b=kmS1gbzdi+N0qY3CgMc/xrEP3a4kAUVE2cw2v+AIF30/plr8yP+59auc/blCDZ2P2r
         Bp6pki2m5dE/vG94/5r+vwYpYlowh7uP5bZA55PMv56HGrX/7ZOpKpMvl979bKwOciT1
         TOFXoOvBlC09VOmhVv5FfevL2bi8iusAK80i0uyrvMkBmCQ5HMU25bVqTRS69ut6xn16
         XzucevIFCHo5nu6m4yV2YBXqi/1QtsCrJYAGJU7UDm8wFLMmwtLWLVdT6aUxEtoUN341
         zXI7+pM53LeBJQSs7LIKMH+Do24FXbrdW10H3qF00yy8aCYOMqVASxY7zH8fmCENtP7a
         W2jg==
X-Gm-Message-State: AOAM531lSx+66D/pUQBwGSXq+7slzEE8F7KBY5a1yV+hYICQ0OnvS1hQ
        OhhWtqOS/QARL+WWOJcCeJpiffDqzmvN6w==
X-Google-Smtp-Source: ABdhPJzWYjPuz2uSK3HO5FXHhq7pJ2d8aNYlMhSjs4/ZtKL0lF7AaemN9BahUxr1uWlIX2aZNigH8A==
X-Received: by 2002:a63:f54f:: with SMTP id e15mr19516125pgk.111.1590263834175;
        Sat, 23 May 2020 12:57:14 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f21sm9664211pfn.71.2020.05.23.12.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 12:57:13 -0700 (PDT)
Date:   Sat, 23 May 2020 12:57:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix various coding-style issues and improve printk()
 usage
Message-ID: <20200523125705.0e3b2e60@hermes.lan>
In-Reply-To: <20200523160644.GA17787@mx-linux-amd>
References: <20200523160644.GA17787@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 May 2020 18:06:44 +0200
Armin Wolf <W_Armin@gmx.de> wrote:

> + *
> + * Authors and other copyright holders:
> + * 1992-2000 by Donald Becker, NE2000 core and various modifications.
> + * 1995-1998 by Paul Gortmaker, core modifications and PCI support.
> + * Copyright 1993 assigned to the United States Government as represented
> + * by the Director, National Security Agency.
> + *
> + * This software may be used and distributed according to the terms of
> + * the GNU General Public License (GPL), incorporated herein by reference.
> + * Drivers based on or derived from this code fall under the GPL and must
> + * retain the authorship, copyright and license notice.  This file is not
> + * a complete program and may only be used when the entire operating
> + * system is licensed under the GPL.
> + *
> + * The author may be reached as becker@scyld.com, or C/O
> + * Scyld Computing Corporation
> + * 410 Severn Ave., Suite 210
> + * Annapolis MD 21403
> + *

The GPL boilerplate is no longer necessary use SPDX instead.
