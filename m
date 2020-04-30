Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11041C0A40
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 00:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgD3WTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 18:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbgD3WTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 18:19:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ECEA205ED;
        Thu, 30 Apr 2020 22:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588285150;
        bh=+iaBUP93aB4PLHy5PhtG3qIwR8dB2cURmusx6PKiafk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pkr9T7sraiEqpsV+VjljWZMxnnFTKPaWIWD+zjiNvzOaSQdb+GFDJO8WQ3rQHK/19
         XQql7/QGLTcOaludni7t/xbiRWntZldHQWjKfO1rp+SVKqgxCNkOjTYI/l4M2HARDq
         Q9yvSp2249bo60pvRnkWY6QPCVheGk6WGk01/m4k=
Date:   Thu, 30 Apr 2020 15:19:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v2 net-next 08/17] net: atlantic: A2 driver-firmware
 interface
Message-ID: <20200430143019.3c3742d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200430080445.1142-9-irusskikh@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
        <20200430080445.1142-9-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Apr 2020 11:04:36 +0300 Igor Russkikh wrote:
> +	struct __attribute__ ((__packed__)) {

nit: checkpatch should warn that the kernel style prefers __packed

> +		u8 arp_responder:1;
> +		u8 echo_responder:1;
> +		u8 igmp_client:1;
> +		u8 echo_truncate:1;
> +		u8 address_guard:1;
> +		u8 ignore_fragmented:1;
> +		u8 rsvd:2;
> +
> +		u16 echo_max_len;
> +		u8 rsvd2;
> +	} ipv4_offload;
