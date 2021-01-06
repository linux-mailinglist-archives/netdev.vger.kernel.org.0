Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06262EBCEA
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 12:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbhAFLAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 06:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbhAFLAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 06:00:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F21121D93;
        Wed,  6 Jan 2021 10:59:22 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Tian Tao <tiantao6@hisilicon.com>, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, will@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] arm64: traps: remove duplicate include statement
Date:   Wed,  6 Jan 2021 10:59:18 +0000
Message-Id: <160993073707.13790.2068661682116598870.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1609139108-10819-1-git-send-email-tiantao6@hisilicon.com>
References: <1609139108-10819-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Dec 2020 15:05:08 +0800, Tian Tao wrote:
> asm/exception.h is included more than once. Remove the one that isn't
> necessary.

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: traps: remove duplicate include statement
      https://git.kernel.org/arm64/c/3fb6819f411b

-- 
Catalin

