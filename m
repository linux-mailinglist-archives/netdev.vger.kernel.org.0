Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D28A23121D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgG1TDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:03:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728698AbgG1TDg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 15:03:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF1C522B4B;
        Tue, 28 Jul 2020 19:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595963016;
        bh=/yAs4dsGiZK9rDCfov87kPI1AkDKoK1gz21JHekBpoQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rTgPSoQjsMDWFSRfLv+zis9V3zDKC6aisByzqyrjrG/W22Zec5FCRks33jfQdWBcP
         nkgHCL7Ws4oN6isYJIgA6FvdWnibF+fQVmR10tUxdQT31411VLEANBIjv0b6nPlrzp
         LugoAyF13fcFm5VTSq6FkZHQYEgMKfuEhHL0zsbA=
Date:   Tue, 28 Jul 2020 12:03:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugfs
 stats
Message-ID: <20200728120334.28577106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728094812.29002-1-ioana.ciornei@nxp.com>
References: <20200728094812.29002-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 12:48:10 +0300 Ioana Ciornei wrote:
> This patch set adds debugfs controls for clearing the software and
> hardware kept counters.  This is especially useful in the context of
> debugging when there is a need for statistics per a run of the test.

No, come on, you know what we're going to say to a debugfs patch like
this...

Is there anything dpaa2-specific here?  We should be able to add a
common API for this.
