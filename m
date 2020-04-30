Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F311BEFC2
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 07:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgD3FdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 01:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3FdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 01:33:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D787C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:33:13 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mq3so260480pjb.1
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=StF/utPDIXiuis/bsVOf+/7bGxcgGsePJud3zXAttD0=;
        b=fX4DEMgBDqY9TtYa6mt8EN9WmW1PRKTjnGTML3IDK01sMprEixUDriyWgX53lne+K4
         2w3hJZETfxoryRAWsZiDo/IHKRPrzgzCWM9vvfFG7BiDqWCSBhxY+8uRlqC0s9B2CV59
         eIh22MBjqIZiUoquT3kYPbHXHwll2mNhdOsN3+ZvvOG+tz1xqP+MOoLEMBzYymus8jco
         PDNfIJsTqGBdf5Q/GKMTtdqjcgr18KQkaxLiFFpIKRVYrTAFVT4sCosasJ+kCSj5eoJK
         J0YcGv68iQEuRBgC3CwnmpDqcA6N/5DNEuCdYUPrQRmuxKtNYqeYZE1QyKHNjf0ys/+e
         686w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=StF/utPDIXiuis/bsVOf+/7bGxcgGsePJud3zXAttD0=;
        b=r01JDGMX8TMCNGCE1UXkbUna99KGcjUN3OEa68nWx/mbCFDAcW0jl+Thifum5baU5m
         aGe6Vq9ez3XZMtAuPKsOISh8O3US62qzSpaA9ipVNXt/So+Iw4AJEjRNVXyLLDWSK83a
         4P48mBcPf2CGBQzynAud8iqzYXpPrpUa2TZglo/iViP0LGSRI/NrVUbT/2NLM3tQTQCi
         I4dGOx4a9BG0xmRNqFYD5gNuIOfYvyD5MaNXSMBiIPEeD6JtqXm98Hsc0H1TU2EmxjrN
         iVx6Sx1WZZvrDegsMqJrVe138a1DhK26One1qlIvv7keZIP/YXjykjuKSIcjlnqzPToT
         4W+w==
X-Gm-Message-State: AGi0PuYQ2oAME9v+Xw0uLhBqtwizOcepmHaK+jGCcztsAeIE4AO2nTvZ
        lUlbwPPtmW1c0N0I2/4pASCH2PGAOCyNcQ==
X-Google-Smtp-Source: APiQypIp5hvitjWiYHt68P3r6oyMBlWihYdxXuI7m50tFcjTvN32QS9Aamo/ODV7asxGTk3H5YDWfA==
X-Received: by 2002:a17:90a:150:: with SMTP id z16mr1000706pje.37.1588224792591;
        Wed, 29 Apr 2020 22:33:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j7sm2430341pfi.160.2020.04.29.22.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 22:33:12 -0700 (PDT)
Date:   Wed, 29 Apr 2020 22:33:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [iproute2 v3] devlink: add support for DEVLINK_CMD_REGION_NEW
Message-ID: <20200429223304.4723fa75@hermes.lan>
In-Reply-To: <20200428204323.1691163-1-jacob.e.keller@intel.com>
References: <20200428204323.1691163-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 13:43:24 -0700
Jacob Keller <jacob.e.keller@intel.com> wrote:

> Add support to request that a new snapshot be taken immediately for
> a devlink region. To avoid confusion, the desired snapshot id must be
> provided.
> 
> Note that if a region does not support snapshots on demand, the kernel
> will reject the request with -EOPNOTSUP.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Looks good applied.
