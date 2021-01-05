Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1602EA92F
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbhAEKuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:50:08 -0500
Received: from foss.arm.com ([217.140.110.172]:52536 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729103AbhAEKuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 05:50:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39E871FB;
        Tue,  5 Jan 2021 02:49:22 -0800 (PST)
Received: from e107158-lin (unknown [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F50B3F70D;
        Tue,  5 Jan 2021 02:49:21 -0800 (PST)
Date:   Tue, 5 Jan 2021 10:49:18 +0000
From:   Qais Yousef <qais.yousef@arm.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-crypto@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] crypto: Rename struct device_private to
 bcm_device_private
Message-ID: <20210105104918.h774oukd23ve5m3v@e107158-lin>
References: <20210104230237.916064-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210104230237.916064-1-jolsa@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/05/21 00:02, Jiri Olsa wrote:
> Renaming 'struct device_private' to 'struct bcm_device_private',
> because it clashes with 'struct device_private' from
> 'drivers/base/base.h'.
> 
> While it's not a functional problem, it's causing two distinct
> type hierarchies in BTF data. It also breaks build with options:
>   CONFIG_DEBUG_INFO_BTF=y
>   CONFIG_CRYPTO_DEV_BCM_SPU=y
> 
> as reported by Qais Yousef [1].
> 
> [1] https://lore.kernel.org/lkml/20201229151352.6hzmjvu3qh6p2qgg@e107158-lin/
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  drivers/crypto/bcm/cipher.c | 2 +-
>  drivers/crypto/bcm/cipher.h | 4 ++--
>  drivers/crypto/bcm/util.c   | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

FWIW, I did reproduce this on v5.9 and v5.10 kernels too, worth adding a fixes
tag for stable to pick it up? v5.8 built fine when I tried.

Anyway, the patch looks good to me, thanks for the fix!

Tested-by: Qais Yousef <qais.yousef@arm.com>

Cheers

--
Qais Yousef
