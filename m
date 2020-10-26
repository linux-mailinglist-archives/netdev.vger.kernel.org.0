Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64B3299581
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790063AbgJZShH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790047AbgJZShH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 14:37:07 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A15E72076A;
        Mon, 26 Oct 2020 18:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603737427;
        bh=cwj6V4HBYdywk3l6aKwSUjZa6NVjtt3IihT4F5BjgMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PWsJRWpGI8O47ywBXeIwY84FdSCa8BSDhv4z/dr0vZVdGkdZztdH4M48qj3pESEzd
         ns0RalRHXaRTN9Ra1jc4dK7iDK+crlUlAW/drPDk1MW311gmUaHbmUweU+fZRS9sNi
         4cEgcyZhNTx5F8X89K8Kfgxk85IRhqNDZeFSO7bo=
Date:   Mon, 26 Oct 2020 11:37:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Colin King <colin.king@canonical.com>,
        David Laight <David.Laight@aculab.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsock: ratelimit unknown ioctl error message
Message-ID: <20201026113705.0cbad1d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201026182457.fy6uxrjgs5bpzmnr@steredhat>
References: <20201023122113.35517-1-colin.king@canonical.com>
        <20201023140947.kurglnklaqteovkp@steredhat>
        <e535c07df407444880d8b678bc215d9f@AcuMS.aculab.com>
        <20201026084300.5ag24vck3zeb4mcz@steredhat>
        <d893e3251f804cffa797b6eb814944fd@AcuMS.aculab.com>
        <20201026093917.5zgginii65pq6ezd@steredhat>
        <3e34e4121f794355891fd7577c9dfbc0@AcuMS.aculab.com>
        <20201026100112.qaorff6c6vucakyg@steredhat>
        <20201026105548.0cc911a8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201026182457.fy6uxrjgs5bpzmnr@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 19:24:57 +0100 Stefano Garzarella wrote:
> @Colin, can you send a v2 removing the error message and updating the 
> return value?

Not as a single patch, please, these are two different changes.
