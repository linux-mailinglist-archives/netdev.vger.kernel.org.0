Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF83E43A997
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhJZBLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236036AbhJZBLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 21:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3363760F70;
        Tue, 26 Oct 2021 01:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635210565;
        bh=PplSwj1D/+d4njY9xgxBdzELzY6cEHPbJJda4XP/gJA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lM6jUvvyc+yELts1PIjK9q8jiV8mcO387l+UWFlKT8v45CcsoTi3OEYH2iEc0nfhi
         ARzEzCWXdK5tAOVclD2DpJ+uDU0d5pt+JuB9Md1bttQWA7zNqYJsb4WFU71Rj2bSDv
         rM7bA0K4vcH2c/rzkzqk/+lleSXfi1/XoW2Veo29loTOu+5EBNRwtBnisrcpQIETGf
         4iuTz+Z3mCqvEJLNkEKwf1LpPyOj6uR6Eo6X+FnuWvPf7Qx0EvzwxKLoSF4gUeCKaq
         1260+bPpDfLsQWxhM5YBr42h483iEJ1MFJHsrerx99QxvJC8I+jjazBGDTZBWZDbJi
         HUzfv2qVqzc0A==
Date:   Mon, 25 Oct 2021 18:09:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rakesh Babu <rsaladi2@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Nithin Dabilpuram <ndabilpuram@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Subject: Re: [net PATCH 2/2] octeontx2-af: Display all enabled PF VF
 rsrc_alloc entries.
Message-ID: <20211025180924.4e072ea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025190045.7462-3-rsaladi2@marvell.com>
References: <20211025190045.7462-1-rsaladi2@marvell.com>
        <20211025190045.7462-3-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 00:30:45 +0530 Rakesh Babu wrote:
> Fixes: f7884097141b ("octeontx2-af: Formatting debugfs entry
> rsrc_alloc.")
> Fixes: 23205e6d06d4 ("octeontx2-af: Dump current resource provisioning
> status")

Fixes tag should not be line wrapped. Please fix.
