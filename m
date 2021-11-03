Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6656443AA4
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhKCA6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhKCA6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 20:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EA0061073;
        Wed,  3 Nov 2021 00:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635900941;
        bh=j1uFTRgMamxbv0IZhp13qGNR+gqIVaeJXd0FjonuOwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HZXHqeIYUp/TZjxVZogjbhpGCQ6pKDCpl1wxmq1zgaQJb3iLLnNavFCqMmUSq/4rO
         M+xtPH1JFWuUzTfqOTnXExBIpuWqYPKW8Qi8qvD315SwCUOju8l0yIZiwePau3ev7A
         i8+Rk3Ho5ho/Wad5kuVUhDcALoAArs8FEFNxWzu1YALJJ411tEW1+NF1fwf1LMeHGd
         5++HxK95oJm9NEUhaOSUWaHsCVP/8QRVC1qmN2FmqS5bsylM6vYYw3/Q736Y9OGL1v
         jgZdyfuFHy+cIZYzqwV+G1d14mXKddrhckifvTk9saupRUEuvDpy5Pz4VHqjoyC6yS
         e6s6a7kRwJmBg==
Date:   Tue, 2 Nov 2021 17:55:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] mctp: handle the struct sockaddr_mctp_ext
 padding field
Message-ID: <20211102175537.0a004f77@kicinski-fedora-PC1C0HJN>
In-Reply-To: <ebab61afcbcd91441c4a5395612a4f1eca691bae.1635788968.git.esyr@redhat.com>
References: <cover.1635788968.git.esyr@redhat.com>
        <ebab61afcbcd91441c4a5395612a4f1eca691bae.1635788968.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Nov 2021 18:54:53 +0100 Eugene Syromiatnikov wrote:
> +static bool mctp_sockaddr_ext_is_ok(const struct sockaddr_mctp_ext *addr)
> +{
> +	return !addr->__smctp_pad0[0]
> +	       && !addr->__smctp_pad0[1]
> +	       && !addr->__smctp_pad0[2];

&& at the end of the previous line please. Checkpatch will point those
out to you.

> +}
