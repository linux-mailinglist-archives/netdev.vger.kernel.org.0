Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA9842A081
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 11:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhJLJCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 05:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232578AbhJLJCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 05:02:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6D7760E54;
        Tue, 12 Oct 2021 09:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634029240;
        bh=TVj9dloozAyW16amMZxZwPSuRXoQgPT1QTvMuSQGFX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QC9WQeY+nVU75Hp+bftVBJ68Qsrc7UbaMkO8RAHotlG+QFh1ouPAmwWDHpi4t8m2u
         hqysN2IEoNEXRtQFevKnS+QaoCYSHsSNdtwM5GHqXIGA/PlrQHny77emzrZ94kCpF4
         DtHpKnX7DTg57ZQXGtaM2zmYTMfL5qmile3rdSErZkZSW1d+ixUcLWznEuajkkoDbp
         fU8f5fyRbVmTnez/PTmCb9sBuMv8Es7cea95Is/QVQmhPpLHBINrM1tMpxDvuTmVEm
         4Gg/F7PzGR/Ey9rK4T7tb4WUDupD2h0FBwzH76LGC5gKhVn6tOKXbNvyGaYkDtC5LH
         //xj60vru9/1Q==
Received: by pali.im (Postfix)
        id 905885BC; Tue, 12 Oct 2021 11:00:37 +0200 (CEST)
Date:   Tue, 12 Oct 2021 11:00:37 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] mwifiex: Add quirk resetting the PCI bridge on MS
 Surface devices
Message-ID: <20211012090037.v3w4za5hshtm253f@pali>
References: <20211011165301.GA1650148@bhelgaas>
 <fee8b431-617f-3890-3ad2-67a61d3ffca2@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fee8b431-617f-3890-3ad2-67a61d3ffca2@v0yd.nl>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 12 October 2021 10:48:49 Jonas Dreßler wrote:
> 1) Revert the cards firmware in linux-firmware back to the second-latest
> version. That firmware didn't report a fixed LTR value and also doesn't
> have any other obvious issues I know of compared to the latest one.

FYI, there are new bugs with new firmware versions for 8997 sent by NXP
to linux-firmware repository... and questions what to do with it. Seems
that NXP again do not respond to any questions after new version was
merged into linux-firmware repo.

https://lore.kernel.org/linux-firmware/edeb34bc-7c85-7f1d-79e4-e3e21df86334@gk2.net/

So firmware revert also for other ex-Marvell / NXP chips is not
something which could not happen.
