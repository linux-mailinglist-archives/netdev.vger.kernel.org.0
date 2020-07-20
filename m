Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4079922735D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 01:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgGTX6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 19:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgGTX6b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 19:58:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6681422B4D;
        Mon, 20 Jul 2020 23:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595289511;
        bh=ofuO8bN6/cRkRgNet/39F7F1IMvB3XkGwPG3fu/QxYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=00FQ84kHOeaZA3n1/B1opmFfxq4Tfj/kqoVRFeKWaAr6EWe/Aa/gxrIpdmnaOOsaJ
         SJ8fwKXR/23yoxD1tU7VtfkXVDCmngGc9gif1mAxeJyewo+0kjivgQmHgKNrATN8nJ
         GLk5li1NnCgZXKSRAGcT32XwA8SN+sBd0Ud3k7Bs=
Date:   Mon, 20 Jul 2020 16:58:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Starovoytov <mstarovoitov@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 00/13] net: atlantic: various features
Message-ID: <20200720165829.3b5be70c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200720183244.10029-1-mstarovoitov@marvell.com>
References: <20200720183244.10029-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 21:32:31 +0300 Mark Starovoytov wrote:
> This patchset adds more features for Atlantic NICs:
>  * media detect;
>  * additional per-queue stats;
>  * PTP stats;
>  * ipv6 support for TCP LSO and UDP GSO;
>  * 64-bit operations;
>  * A0 ntuple filters;
>  * MAC temperature (hwmon).
> 
> This work is a joint effort of Marvell developers.

Looks good to me now, thanks

Acked-by: Jakub Kicinski <kuba@kernel.org>
