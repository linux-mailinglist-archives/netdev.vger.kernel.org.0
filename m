Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FAA167D47
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 13:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgBUMTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 07:19:10 -0500
Received: from mail-out.elkdata.ee ([185.7.252.64]:54224 "EHLO
        mail-out.elkdata.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbgBUMTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 07:19:10 -0500
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Feb 2020 07:19:08 EST
Received: from mail-relay2.elkdata.ee (unknown [185.7.252.69])
        by mail-out.elkdata.ee (Postfix) with ESMTP id 79CAC372A95;
        Fri, 21 Feb 2020 14:11:38 +0200 (EET)
Received: from mail-relay2.elkdata.ee (unknown [185.7.252.69])
        by mail-relay2.elkdata.ee (Postfix) with ESMTP id 74F028309AA;
        Fri, 21 Feb 2020 14:11:38 +0200 (EET)
X-Virus-Scanned: amavisd-new at elkdata.ee
Received: from mail-relay2.elkdata.ee ([185.7.252.69])
        by mail-relay2.elkdata.ee (mail-relay2.elkdata.ee [185.7.252.69]) (amavisd-new, port 10024)
        with ESMTP id Dv7M9TrqqmTv; Fri, 21 Feb 2020 14:11:36 +0200 (EET)
Received: from mail.elkdata.ee (unknown [185.7.252.68])
        by mail-relay2.elkdata.ee (Postfix) with ESMTP id 23BB88309AC;
        Fri, 21 Feb 2020 14:11:36 +0200 (EET)
Received: from mail.meie.biz (21-182-190-90.sta.estpak.ee [90.190.182.21])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: leho@jaanalind.ee)
        by mail.elkdata.ee (Postfix) with ESMTPSA id 1926560BF52;
        Fri, 21 Feb 2020 14:11:36 +0200 (EET)
Received: by mail.meie.biz (Postfix, from userid 500)
        id 004D3B7C6A4; Fri, 21 Feb 2020 14:11:35 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kraav.com; s=mail;
        t=1582287096; bh=233+khcaWZ9tc+fOJUrTd3ddqOMhHE2+qhQGuN3aNAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=UW9yvUDehx6+hgJ8hn7C3g7CkIUDQXX+wFiPw4NZl4JxVDC5KEeKEgTpW5r9CdN1I
         vvVxs1mWp/EcaAVhxI8t8FwvsSeyqBbP/r22IeZbsAZjmK0CKFUqDRPuPgyeBztocv
         JU6PfccIGMZkX6xRZZI3xd//0RRqcyu8YHWO6qCY=
Received: from papaya (papaya-vpn.meie.biz [192.168.48.157])
        by mail.meie.biz (Postfix) with ESMTPSA id B1A03B7C69C;
        Fri, 21 Feb 2020 14:11:35 +0200 (EET)
Authentication-Results: mail.meie.biz; dmarc=fail (p=none dis=none) header.from=kraav.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kraav.com; s=mail;
        t=1582287095; bh=233+khcaWZ9tc+fOJUrTd3ddqOMhHE2+qhQGuN3aNAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Y+/xdoNoetHFP/OmkiU8wXTTBx8klll0NqDNHDnTV5d3FdVOxam8VhhY15v7FQheB
         0CGV7Fu0AQGWbpOw40gpUihxAO5OtQYfJR8EF01Rk44Irj2zcWO0hT/SCv/Ux5dCVg
         4qs44UD+K8giTSQFOiu+XWEAuhNX7AK91Nf08ZiE=
Received: (nullmailer pid 12685 invoked by uid 1000);
        Fri, 21 Feb 2020 12:11:35 -0000
Date:   Fri, 21 Feb 2020 14:11:35 +0200
From:   Leho Kraav <leho@kraav.com>
To:     "Jan Alexander Steffens (heftig)" <jan.steffens@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: restore support for Killer Qu C0 NICs
Message-ID: <20200221121135.GA9056@papaya>
References: <20191224051639.6904-1-jan.steffens@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191224051639.6904-1-jan.steffens@gmail.com>
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.500000, version=1.2.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 06:16:39AM +0100, Jan Alexander Steffens (heftig) wrote:
> Commit 809805a820c6 ("iwlwifi: pcie: move some cfg mangling from
> trans_pcie_alloc to probe") refactored the cfg mangling. Unfortunately,
> in this process the lines which picked the right cfg for Killer Qu C0
> NICs after C0 detection were lost. These lines were added by commit
> b9500577d361 ("iwlwifi: pcie: handle switching killer Qu B0 NICs to
> C0").
> 
> I suspect this is more of the "merge damage" which commit 7cded5658329
> ("iwlwifi: pcie: fix merge damage on making QnJ exclusive") talks about.
> 
> Restore the missing lines so the driver loads the right firmware for
> these NICs.

This seems real, as upgrading 5.5.0 -> 5.5.5 just broke my iwlwifi on XPS 7390.
How come?
