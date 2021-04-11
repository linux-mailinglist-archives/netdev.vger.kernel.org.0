Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA5735B631
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 18:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbhDKQsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 12:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235388AbhDKQsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 12:48:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FC1E60FE5;
        Sun, 11 Apr 2021 16:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618159685;
        bh=K5hqZRx/Y1HCim0TLPHPChzSDtuu6u1LJ7yJg1qhHvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ex+9QeWPWdF5V9HiJZPvdZ7ygMN9Bg5+Q1DkixgYY2ErOmfg2c082TYdbCuolYf4+
         eq7fcqhlQeoe4pZvl5QHqzRRqmt3583oU3nN7b2BDLdkI5UVpB5cdF3mXf5ePt1WKl
         wKquhUiPXRzjaH05RMCYJr0WtLu7aHZE0pp84K+/XyzwENbOT6unz9zRQ4EkW8We0x
         S0q61NHpmgCfs6lK3xP9uCHCLM7PT0LCSlWIAoaHusT33NUsG+HH9vq0SrxHvj+M6z
         LDqsEnzlAZHMHxaJh8dLpF1FVBK1MIl6LhajP3DBaHAO2cMFws6AozVl3a2FZ+ETkN
         vK2c1Ezmjdc2A==
Date:   Sun, 11 Apr 2021 12:48:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hauke@hauke-m.de,
        f.fainelli@gmail.com, davem@davemloft.net
Subject: Re: [PATCH stable-5.4 0/2] net: dsa: lantiq_gswip: backports for
 Linux 5.4
Message-ID: <YHMoRAAVSKvfF6b9@sashalap>
References: <20210411102344.2834328-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210411102344.2834328-1-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 12:23:42PM +0200, Martin Blumenstingl wrote:
>Hello,
>
>This backports two patches (which could not be backported automatically
>because the gswip_phylink_mac_link_up function is different in Linux 5.4
>compared to 5.7 and newer) for the lantiq_gswip driver:
>- commit 3e9005be87777afc902b9f5497495898202d335d upstream.
>- commit 4b5923249b8fa427943b50b8f35265176472be38 upstream.
>
>This is the first time that I am doing such a backport so I am not
>sure how to mention the required modifications. I added them at the
>bottom of each patch with another Signed-off-by. If this is not correct
>then please suggest how I can do it rights.

Hey Martin,

Your backport works, but I'd rather take 5b502a7b2992 ("net: dsa:
propagate resolved link config via mac_link_up()") along with the
backport instead. This means that we don't diverge from upstream too
much and will make future backports easier.

I've queued up these 3 commits to 5.4, thanks!

-- 
Thanks,
Sasha
