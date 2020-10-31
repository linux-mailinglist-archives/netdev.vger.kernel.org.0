Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA7C2A19A8
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgJaSft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbgJaSft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:35:49 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88D3820724;
        Sat, 31 Oct 2020 18:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604169348;
        bh=Q8x/IjgAMLh65nI0TGauln5zGUNdpZ1nwViLLSehyfo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2fZsT1DMLzsLKfjgT1XgTi/PelEjtg0uoVdquZifxDp/mwZ587dNlz9NXLiF1sS4f
         qs9AdHAWb2BOyWiajIB/ytXS3KYXK1UInQC6t4K0NMYhPrvq+tXGKf4N339B9dj5gB
         jrgJy/bam2G3hCUe05WokJvdPQxWjdWmo8MVHFg0=
Date:   Sat, 31 Oct 2020 11:35:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net: add functionality to net core
 byte/packet counters and use it in r8169
Message-ID: <20201031113547.21c1e305@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1fdb8ecd-be0a-755d-1d92-c62ed8399e77@gmail.com>
References: <1fdb8ecd-be0a-755d-1d92-c62ed8399e77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 18:28:52 +0100 Heiner Kallweit wrote:
> This series adds missing functionality to the net core handling of
> byte/packet counters and statistics. The extensions are then used
> to remove private rx/tx byte/packet counters in r8169 driver.

Applied, thanks!
