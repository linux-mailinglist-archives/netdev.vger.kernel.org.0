Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDB6102E88
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 22:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfKSVqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 16:46:55 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44412 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727621AbfKSVqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 16:46:53 -0500
Received: by mail-lj1-f196.google.com with SMTP id g3so25061741ljl.11
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 13:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ICYtlnCeLJofRfJ+FtTYaL+WUe838oUbdr/BrLYFdT4=;
        b=IO/LiaKf8HMA61Ot+7Jiro58LcHPQHNHQ8BfxZOaZwN5yXfkkBLCve9IgrGV8sMXcx
         ZCY4LdcAikpm+IgpRZG5fLLDqePSx/oZSmLJqCDrwOBfgU3fwcqZJWgBvsOOc2AWk7Ad
         KZbm1rqpuw5YiJHzxj36XMi0PdK4/yk1a5M1OIlvlC46ZwHvcjWc/X6ufbXFu467VGMJ
         KGTjHM1ZWbIhmkO3rAR59rCdQRmz4e1hOBWFf5/uDW2obYmNg46oNYdWuzFJraptwNge
         oHRIb3WhMY6J+WUzHaexAif4yBnRtLPQp3jJRbzRt8OKC4Q75kud/C3rz7eiAI5SJv5o
         VzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ICYtlnCeLJofRfJ+FtTYaL+WUe838oUbdr/BrLYFdT4=;
        b=bIWhO5QYni5Y7/WRcdAeg+d9Fm54g8ASRFkaM6+2D3ynTQfXJQYs6NEZjd6nOkp5Bq
         TbeAQRXHpTDRi9vyPFdUbtpA+oodCvdhZtY6aZk8KGiXIvaHEmDnyT3Hu+lJKcLFRKY5
         ELLHuTzR9R4UlKRNAIc31fIaugmqWnm7RuFnpHLFWUq+dBMHjGHnI3gLSm2/NR3m4zi4
         hSUFiuG1K51mYuhoUWuHcWY5e0vvuRo8WH1DCkjIyZeFYpY92XhCPXCNSL6XJqlTTDdm
         FA2mYDU4GPT9wsTGr0FVrUitBc1iye4mGjZgjUZbRDSpl2GdYY02j/wTR6mzqNZK1iLU
         h+5g==
X-Gm-Message-State: APjAAAVpXOa4dARTprTLtvfR47fmI3BJxC6uPoJkz9Ptj1FJZ40YzMSo
        VH8NDcBa/YQnf8CtNF5/3jNPyw==
X-Google-Smtp-Source: APXvYqz2p3XvEMRkOB60K4stxh+28qZGd9abauo55cqTA7h+VSev2N3GW8tBWC4guqECrcPu4Cf/cw==
X-Received: by 2002:a2e:884c:: with SMTP id z12mr5642618ljj.41.1574200011211;
        Tue, 19 Nov 2019 13:46:51 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k17sm9110830ljj.89.2019.11.19.13.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 13:46:50 -0800 (PST)
Date:   Tue, 19 Nov 2019 13:46:38 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v2 00/15] octeontx2-af: SSO, TIM HW blocks and other
 config support
Message-ID: <20191119134638.6814285a@cakuba.netronome.com>
In-Reply-To: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 16:47:24 +0530, sunil.kovvuri@gmail.com wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> SSO HW block provides packet (or work) queueing, scheduling and
> synchronization. Also supports priorities and ordering. TIM or the
> timer HW block enables software to schedule SSO work for a future time.
> 
> This patch series adds support for SSO and TIM HW blocks, enables them
> to be configured and used by RVU PF/VF devices or drivers.
> 
> Also added support for
> - Backpressure configuration.
> - Pause frames or flow control enabling/disabling.
> - Added a shared data structure between firmware and RVU admin function
>   (AF) which will be used to get static information like interface MAC
>   addresses, link modes, speeds, autoneg support etc.
> - FEC (Forward error correction) config support for CGX.
> - Retrieve FEC stats, PHY EEPROM etc from firmware
> - Retrieving CGX LMAC info and to toggle it.
> - Added debug prints for each of error interrupts raised by NIX,
>   NPA and SSO blocks. These will help in identifying configuration
>   and underlying HW functionality issues.

Please CC people who gave you reviews on new version of the patches.
Especially if you didn't bother to address/answer it.

This driver doesn't seem to function in ways which are familiar in
the upstream Linux kernel.

As I asked in my review of patch 4 in v1, please provide us with
accurate description of how does a system with a octeontx2 operate.
Best in the form of RST documentation in the Documentation/ directory,
otherwise it's very hard for upstream folks to review what you're doing.

Thank you.
