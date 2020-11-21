Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD22BBC49
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 03:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgKUCiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:38:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgKUCiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 21:38:01 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7869922254;
        Sat, 21 Nov 2020 02:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605926280;
        bh=0KXvF7jYROSqAgfdlzJo4/GcWlgUDKpt7dfuctvL9aE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0hfH8foqpwqUSVWZeX1K3Ycdqd4QMTM5u0v59rNCzAUG0x9HNYkBwWHOGQr+30Bd+
         SqFWxH5ecF1/nawGWzneuP5oND5vL70GiI+ri5ore5gRgLL2UtmTsdzvUbqB/uzoLJ
         X1aW4pajnbDu3oWv0wLOvhPqsb7GEmEWwjUZiS8Y=
Date:   Fri, 20 Nov 2020 18:37:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: use dev_err_probe in rtl_get_ether_clk
Message-ID: <20201120183759.68ee76d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b0c4ebcf-2047-e933-b890-8a20e4bdb19f@gmail.com>
References: <b0c4ebcf-2047-e933-b890-8a20e4bdb19f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 22:00:11 +0100 Heiner Kallweit wrote:
> Tiny improvement, let dev_err_probe() deal with EPROBE_DEFER.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
