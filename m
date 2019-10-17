Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C43ADB7FB
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437149AbfJQTra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:47:30 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35904 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389032AbfJQTra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:47:30 -0400
Received: by mail-lf1-f65.google.com with SMTP id u16so2857212lfq.3
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 12:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zYGMJ+5PSGcdhjynebhBJhlpuCtpM8ZplePlhSfxjME=;
        b=Q3/Kxif9xGcx9fh2rCVwvpAC5PCK+TIvubfg+KB42sTWAn9NMBF+I+aG60WiLAWpP6
         j2LaN3VCsgzq3jip+eEEiOV1kDXIqmU08kLNBPN4sh9unoCSGd76OBidkglQJFwd0OHG
         YBHtHrztf/j63vRwprhC4YXCRjndHenbrb+NCx4FSyHowOJR+R4HhfkQf/rUQRY9YolT
         cyPqoKOJKBwGxJ0hwx/YrM7XAhxE2dOWPM0zPfVBZ84Dfvfk/axJoxOrhzS/i/btvEV9
         P2jZL0R8KBzR+4g7c2xFNqk5IuVjnDB9pkj60u9QiCzOkqwm/xyeESZNr5at2WTvzLIC
         ID2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zYGMJ+5PSGcdhjynebhBJhlpuCtpM8ZplePlhSfxjME=;
        b=O2oHpsbU8Ne011cQgn93C8oWB7piuqC9jcQ3qFRElcAbHFLP1sKa7nQuanEfxOJutx
         E29rIg8geyG8K6aPPB8CE9mXYWI517j8I/JRd+TZFObnaKBxHw3MXv+PYfw4QjWOZ9yp
         fjIjC38gVCRQoIrHSY8fLEm6IEii+yKytifNTCr3+KyBBJI6bot9Y+IRXJcukZq7QygM
         RaViGFhamwJZK88WTneFnMhDSCfXETiRVS6XIC8zOnbVk7ToTB4O0cJFQS59/nzizUzt
         rU7u+gnQOxeARwy2uHPP8urqHfULe8+Js/zQK9fCwLTiEQ9d3X/Mrpr885VKNaF2bsQQ
         0tFg==
X-Gm-Message-State: APjAAAWYUgqZZgi+vXit9iOgUGGCF3OgAtOAOY2NetWlCjpivRUKgxZd
        zOcdr/Dpz2fyFkplx1FLRGhUbgnARyA=
X-Google-Smtp-Source: APXvYqx8PbIJTWdvtFe2hKfutM9I0amUKD1ekLbBKOuaVfQLJhzUlRtGuo6sma4UBDt0W3puEzM4Hg==
X-Received: by 2002:a19:f712:: with SMTP id z18mr3168396lfe.166.1571341648082;
        Thu, 17 Oct 2019 12:47:28 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t8sm2778254ljd.18.2019.10.17.12.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 12:47:27 -0700 (PDT)
Date:   Thu, 17 Oct 2019 12:47:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191017124721.6b5a6427@cakuba.netronome.com>
In-Reply-To: <20191017192055.23770-3-andrew@lunn.ch>
References: <20191017192055.23770-1-andrew@lunn.ch>
        <20191017192055.23770-3-andrew@lunn.ch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 21:20:55 +0200, Andrew Lunn wrote:
> Some of the marvell switches have bits controlling the hash algorithm
> the ATU uses for MAC addresses. In some industrial settings, where all
> the devices are from the same manufacture, and hence use the same OUI,
> the default hashing algorithm is not optimal. Allow the other
> algorithms to be selected via devlink.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
