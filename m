Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9F7365D26
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhDTQUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232174AbhDTQUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 12:20:11 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAB41613C3;
        Tue, 20 Apr 2021 16:19:39 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lYt69-008WwX-Eq; Tue, 20 Apr 2021 17:19:37 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [PATCH] ptp: Don't print an error if ptp_kvm is not supported
Date:   Tue, 20 Apr 2021 17:19:34 +0100
Message-Id: <161893556834.531653.9445809886940905685.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420132419.1318148-1-jonathanh@nvidia.com>
References: <20210420132419.1318148-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: jonathanh@nvidia.com, richardcochran@gmail.com, linux-tegra@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jianyong.wu@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 14:24:19 +0100, Jon Hunter wrote:
> Commit 300bb1fe7671 ("ptp: arm/arm64: Enable ptp_kvm for arm/arm64")
> enable ptp_kvm support for ARM platforms and for any ARM platform that
> does not support this, the following error message is displayed ...
> 
>  ERR KERN fail to initialize ptp_kvm
> 
> For platforms that do not support ptp_kvm this error is a bit misleading
> and so fix this by only printing this message if the error returned by
> kvm_arch_ptp_init() is not -EOPNOTSUPP. Note that -EOPNOTSUPP is only
> returned by ARM platforms today if ptp_kvm is not supported.

Applied to kvm-arm64/ptp, thanks!

[1/1] ptp: Don't print an error if ptp_kvm is not supported
      commit: a86ed2cfa13c5175eb082c50a644f6bf29ac65cc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


