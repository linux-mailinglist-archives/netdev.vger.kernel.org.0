Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39788456054
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhKRQVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbhKRQVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:21:49 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E214AC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 08:18:48 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id x131so6508481pfc.12
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 08:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uzjJG+aHpPbokja5cQnMlsnEGGl3ej6QB7Sjo8SoijY=;
        b=oZa0VvLMFQTRH+uOAcQ2jPre5FwVy2AgvKX/m0zvaQ/68UxoNxoudNNdKt6GZFb7dJ
         eU/67yPKftCfhfDrAc85py9hvbWLKj5GsxmokpXa7HW+GAF8GuacD9lREivfzKAAfrgw
         biKJ77DUuSmDuz3C7mN+QPPpv49jCTEOWKmwfLB9o5TA8oeg+7vYEy2/oBKRLvm/NG4J
         t0W3Ba/fgNG+51UBSbLOAFCggv5CahM9u4UYHdsWDFrzEBgn2J2m0MZ7NyBdLStEeByd
         oAurqfhd7pxPo4S+Y/c+kCcVuoCCy+AJGmbi5PYnP1vXCfOJRTlRE5I7iojmgxIeBxhO
         92Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uzjJG+aHpPbokja5cQnMlsnEGGl3ej6QB7Sjo8SoijY=;
        b=sc0BSa4kJF5yjol+1oIRFjHip7TvwSTxAyotJpGiz8Yjn+vVAAAs+AlUXJZf7aHXy4
         po/o5qwAzLYCitG8M2Dj44aev02oHoSy01ZvitLFgOccmAGrgJdysGHOOUrsIOrmC3YW
         JymV+Ja56e7EOcqqvNXP0y4YA+D9B9+btqU1+1klwF+xm9V7wCGTzoPY84RLXCweLl36
         fme59gLYvKSrTwj8TCyHxllML4Y4oMymwK9pNGN6ikxGHsZw9sBAm688UsR6FXukq9KS
         L6pAZaEizd/nNWXuQgV9CF6gAVsENJN6hbo6ZVezTPWi2DgN3uZ98f0lR+iNVxBBgWY0
         86jw==
X-Gm-Message-State: AOAM531ApKHgnMV8KgVPX2nOui0YA3tF4e2nPOoIjPSipZGSUwrqVN6y
        onXvE59GsUKUGCjsGd/ha2RNXZ4PrglwLQ==
X-Google-Smtp-Source: ABdhPJzX3VlRSj7dgKU/mCgnF2VOiMcKue9MASKtSF851FtD+AiHPnphfSRHD1my96JSsBfMd4ltdQ==
X-Received: by 2002:a63:f942:: with SMTP id q2mr12095019pgk.97.1637252328402;
        Thu, 18 Nov 2021 08:18:48 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id i33sm121096pgi.71.2021.11.18.08.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 08:18:47 -0800 (PST)
Date:   Thu, 18 Nov 2021 08:18:44 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <dsahern@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next iproute2] vdpa: Remove duplicate vdpa UAPI
 header file
Message-ID: <20211118081844.19bb7a96@hermes.local>
In-Reply-To: <20211106064152.313417-1-parav@nvidia.com>
References: <20211106064152.313417-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 6 Nov 2021 08:41:52 +0200
Parav Pandit <parav@nvidia.com> wrote:

> vdpa header file is already present in the tree at
> vdpa/include/uapi/linux/vdpa.h and used by vdpa/vdpa.c.
> 
> As we discussed in thread [1] vdpa header comes from a different
> tree, similar to rdma subsystem. Hence remove the duplicate vdpa
> UAPI header file.
> 
> [1] https://www.spinics.net/lists/netdev/msg748458.html
> 
> Fixes: b5a6ed9cc9fc ("uapi: add missing virtio related headers")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> ---
>  include/uapi/linux/vdpa.h | 40 ---------------------------------------
>  1 file changed, 40 deletions(-)
>  delete mode 100644 include/uapi/linux/vdpa.h

Ok, but the vdpa.h needs to be kept updated, let me add that
subtree to my update-headers script.

The update headers script does 'make install_headers' in the
Linux kernel tree then clones them to iproute2.

I would prefer that Rdma and Vdpa do not have their own
headers. The future chance of version skew is too high.
For now, the tool will update all three locations.
