Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB04286283
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgJGPqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbgJGPqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 11:46:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D37C0613D2
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 08:46:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id n18so2768921wrs.5
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 08:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YzPiSX7AQ1L9YnXrnLU91iAOqoFafCUH8YuU1FCjhMc=;
        b=HmuQOSO5fQzzPoNooQ98zkg3PTY6swd4ETESnICsiJr6LKNVV0WEsV8kBq9p+YJSZl
         14LLqkPF7gSHmgpFN3Rv7Wid+GDiKlRXAQqkDDRLkcL8D3b3nX+R243/oeNaHvpaGCsw
         HCXmyxlDIFx4qPL3IxeI9ZLisjCcZC/HKgGSHoTT2hEdLXjjSbbsoEjPEgcMGtSwDnmS
         p+NrMcNj/QklFSMbPoX2hLQOSlbEjBKBTsiEx4nNGYXKCJC7HWv1493vmlE9QYCls3Fp
         VjGyamtXkRoQKfKsziofoTvhBEy92/v2Bbt8RbwTmLGvzaiINVBHBn92Z1BBiCF+V7Ha
         TrZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YzPiSX7AQ1L9YnXrnLU91iAOqoFafCUH8YuU1FCjhMc=;
        b=ClmZtBXT0eSNPMsIseHqLNtY++1+BTcV//KAecu8CeLXPmYM4JE5sVCVvQ0rDSbjK8
         h5JKZO4aSgbYsENnPz5DgTxKrRuhp+Znv25Mg9MD6cvsQlcOLuA8FupiD0raCHXRdtun
         5KZJQWzX9F+qJQWbVQQIMCYUABfSLbLDl/DBLk/H9rxYSEu7VyNid+uLHNys2kRvxDME
         QSpdmqIL7Okk90n7HOMHrEP7TNtn0XHFIJ5984RvUhaFgz8aHhArp7xBGc4THdBJknJc
         z1nzNFbpK96Oi5JEwBz847K10JSQxmHENWzV0DJpXY1CDcUKrOC+97UCo3skHwMewfhi
         DPrg==
X-Gm-Message-State: AOAM533ysVSAuk56aNwz1zqTP6TlQPUy6GJTXmzndEv5uYTbokOJGf2a
        XlwOVGZwrO1/3hvoMAi5lQugPQ==
X-Google-Smtp-Source: ABdhPJwAUva8Y6sfFj4UDNguAWXZjtX41JdpwwGKDeXgg/qMbYOvETz04L0/DLuh/b5zsSxQC9ixew==
X-Received: by 2002:adf:91a4:: with SMTP id 33mr4521604wri.170.1602085579687;
        Wed, 07 Oct 2020 08:46:19 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p21sm3253767wmc.28.2020.10.07.08.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 08:46:19 -0700 (PDT)
Date:   Wed, 7 Oct 2020 17:46:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>, f@nanopsycho
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 04/16] devlink: Add reload stats
Message-ID: <20201007154618.GB3064@nanopsycho>
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
 <1602050457-21700-5-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602050457-21700-5-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 07, 2020 at 08:00:45AM CEST, moshe@mellanox.com wrote:
>Add reload stats to hold the history per reload action type and limit.
>
>For example, the number of times fw_activate has been performed on this
>device since the driver module was added or if the firmware activation
>was performed with or without reset.
>
>Add devlink notification on stats update.
>
>Expose devlink reload stats to the user through devlink dev get command.
>
>Examples:
>$ devlink dev show
>pci/0000:82:00.0:
>  stats:
>      reload:
>        driver_reinit 2 fw_activate 1 fw_activate_no_reset 0
>pci/0000:82:00.1:
>  stats:
>      reload:
>        driver_reinit 1 fw_activate 0 fw_activate_no_reset 0
>
>$ devlink dev show -jp
>{
>    "dev": {
>        "pci/0000:82:00.0": {
>            "stats": {
>                "reload": {
>                    "driver_reinit": 2,
>                    "fw_activate": 1,
>                    "fw_activate_no_reset": 0
>                }
>            }
>        },
>        "pci/0000:82:00.1": {
>            "stats": {
>                "reload": {
>                    "driver_reinit": 1,
>                    "fw_activate": 0,
>                    "fw_activate_no_reset": 0
>                }
>            }
>        }
>    }
>}
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
