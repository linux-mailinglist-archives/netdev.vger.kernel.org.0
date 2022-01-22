Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78852496DA1
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 20:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbiAVTZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 14:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiAVTZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 14:25:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CF6C06173B;
        Sat, 22 Jan 2022 11:25:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE4B0B80AC2;
        Sat, 22 Jan 2022 19:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BB2C004E1;
        Sat, 22 Jan 2022 19:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642879542;
        bh=T14ZJxplnXDkpWORF/kRigWSDcpL53ooIUxDtGNS154=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PuyckjzZovpFg24aswb1T4MvFgnixLjC0PHSxQjXLmGQnPTUNcIpou8x1iGDsRfMx
         r0y73kufripzVhKwGUEY2xcX1PUimKpQjgR3gIIVuqUSTpnPJA8wq8JZxLWbNVuyFD
         zeLAaSUKeIYRDK46oFDpeCNp1yd7+iFi6VojCtgiY4ECzEFkDNqEY/mX7+oy3jkgxP
         Vkt1jMvXrN76ZeizBmwCTercy0LG6C+HcX/2sVbzGz7NnFaIF7r+tCrzbpr5UiWx2i
         2/aCQpGaHOFkgQ1trhlhLDJVy65evJEfmNtmVOY2e5VlDnKa0Ef/d9qyKgMyQWg3W3
         1j3waB9xroEXA==
Date:   Sat, 22 Jan 2022 14:25:41 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 001/116] Bluetooth: Fix debugfs entry leak
 in hci_register_dev()
Message-ID: <YexaNfF3ygH0L/Hw@sashalap>
References: <20220118024007.1950576-1-sashal@kernel.org>
 <20220118171327.GA16013@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220118171327.GA16013@duo.ucw.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 06:13:27PM +0100, Pavel Machek wrote:
>Hi!
>
>Is there a git tree with the autosel patches or other automated way to
>access them? It would help the review.

Not currently, happy to push them out if folks are interested.

You can always pick them off of the mailing list with lei :)


-- 
Thanks,
Sasha
