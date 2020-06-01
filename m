Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B1B1EA167
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 11:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgFAJ6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 05:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgFAJ6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 05:58:41 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A052FC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 02:58:40 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h5so4914343wrc.7
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 02:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XFEMzoz019ODy5s2eU+T5jJlAd9hAXukRZ9qRgFrgT4=;
        b=vBRMefVs74XvTlumtQUfFEqJEvqVbxJdWukkVLBSGtose6Vf5NB+qsCRmHqgT8bZ4H
         576QQ2ZOat6iKFwTpmodfsTrWciV5trzK+lMPA42G4lK6TLQXg6c0lZrERlaxYWPV9cz
         BOzbF1YrW5K9HovzHBKLymjgdCB2/x19V9LPW7jtFPbMKI31yNqgnldCyeHv+dH2gr3N
         Sm3ccibo7BOndai9Bpx1RYtgx05uiLZsulZKPRVIXs9Q8JVyM+qNtmvgFjHRJfupJBYu
         9jA49wLBIc4mZPjtuk1muCY6UJQtSQnZHAHg0imjIpMNtqa4gqo0Jp2oMmh/G7xvN845
         ZPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XFEMzoz019ODy5s2eU+T5jJlAd9hAXukRZ9qRgFrgT4=;
        b=jScSwxfuBGDgq2SZvbpEEW+/wWpsmk6GryPUtG0p3SAs1RAXCXnGUVOZuXZYCjQ5Fs
         1rQ2eKH2S3Hf6GJVcyJlYakan79pjyglVp6WoF1EVRpI9V33xgm62d8LCLLLEOPjLFSn
         +gUBFMROBoLtyZ/rsp6BnPXfp9zk18glPxLz/SW+uglRZfJW1RmfgJSSStqYnTWRYUaQ
         unLljIfZ52Ca5okl3nRlXQqzXOMi2Ejf+dYVbDby9fa7q5geJZv8yNMbJ8oRV9fn/oZu
         h3G4VsRsB406vLMHQp0gawzAX3GRn6ZrsZoauqsPZFJ8BERw798BMGTEPBGNT0IdfwGt
         3OxA==
X-Gm-Message-State: AOAM5303vVr4f6SR8QtErHM5mhC2SiYjSgt3AmcJihSIxAatUYtkb2lf
        2wNXXax372eV5OWkXCEBFELYnA==
X-Google-Smtp-Source: ABdhPJzt2u88WnasC//6LWkvRO4Yaom4FbJg9SjklYCxdSuQi+v91r2umrWHEg8U8+VrYQNwglX7aA==
X-Received: by 2002:adf:cd08:: with SMTP id w8mr17639596wrm.36.1591005519445;
        Mon, 01 Jun 2020 02:58:39 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id v7sm21941528wre.93.2020.06.01.02.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 02:58:39 -0700 (PDT)
Date:   Mon, 1 Jun 2020 11:58:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and
 'allow_live_dev_reset' generic devlink params.
Message-ID: <20200601095838.GK2282@nanopsycho>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 31, 2020 at 09:03:39AM CEST, vasundhara-v.volam@broadcom.com wrote:

[...]

> Documentation/networking/devlink/bnxt.rst          |  4 ++
> .../networking/devlink/devlink-params.rst          | 28 ++++++++++
> drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
> drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
> drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
> include/net/devlink.h                              |  8 +++
> net/core/devlink.c                                 | 10 ++++

Could you please cc me to this patchset? use scripts/maintainers to get
the cc list.

It is also customary to cc people that replied to the previous patchset
versions.


> 10 files changed, 175 insertions(+), 36 deletions(-)
>
>-- 
>1.8.3.1
>
