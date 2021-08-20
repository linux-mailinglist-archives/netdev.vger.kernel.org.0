Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1895A3F2CB5
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbhHTNCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240685AbhHTNCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60A9660F39;
        Fri, 20 Aug 2021 13:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629464528;
        bh=XmK3LL/kczQ8Z+mWS0jnuPNaTKva71BKQybVqIajn2U=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=aYMABfEHFn+7Kxh2/MCRF/AHSGEXnmm1wwYZV/SiISnuS7QAg8vC8A8gHUcJQHHJU
         jndvWKCbmKREp+Q+csliLWq1xfVo9N1ThE9t9PC3acSXLZUZd8ZV+43etboNIfFSU4
         elTORRr93PV1FUprfZYqHAQtChsRVKZLcib11SGIunO2FEuIUTOfXEmOzVFWIIAfpi
         Gpu4L7iSStDO8sT6ED1OTcs1Qu/7AmVe3IQTNXsGFPhv2pIFnV1eYeNYrTX8r8c+XZ
         KZt7w4RnLsX1Bh7LiMJY7mFit8tljzKmeylhW39zI5+LMFsGOrnGgg9dGOurKa5wA1
         /AbeTWLFaERiQ==
Date:   Fri, 20 Aug 2021 15:02:03 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Kees Cook <keescook@chromium.org>
cc:     linux-kernel@vger.kernel.org,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 55/63] HID: roccat: Use struct_group() to zero
 kone_mouse_event
In-Reply-To: <20210818060533.3569517-56-keescook@chromium.org>
Message-ID: <nycvar.YFH.7.76.2108201501510.15313@cbobk.fhfr.pm>
References: <20210818060533.3569517-1-keescook@chromium.org> <20210818060533.3569517-56-keescook@chromium.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021, Kees Cook wrote:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Add struct_group() to mark region of struct kone_mouse_event that should
> be initialized to zero.
> 
> Cc: Stefan Achatz <erazor_de@users.sourceforge.net>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied, thank you Kees.

-- 
Jiri Kosina
SUSE Labs

