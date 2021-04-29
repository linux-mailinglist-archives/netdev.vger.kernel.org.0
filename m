Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C58A36ED3E
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 17:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240655AbhD2PTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 11:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233420AbhD2PS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 11:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DB13613F8;
        Thu, 29 Apr 2021 15:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619709490;
        bh=PIULz0KfwhvgUzyTQSuU5ykSLh8rvEuC0ze8uuWHiKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JnZ3M1Yn8/fc2AA1KQByKYb5HsUr03ybAh/wlLVbFVngV22jrETKJx0rmZSrINNn/
         Y/GqRuWRs7JLM80unD+ZWPTHhqdSYHCG2iAgerK413fojufkcR2+w+sPP/foZOCqE0
         TzFDsT5PbXAzPb+jS90EuipKLyEUw1Cd1tuOFpq9iE4EaOmUZF92sf2B5p6vC389Gz
         AGfxqp/XTPDKYSqwap+5qKeA+MdAQlJIzWfmuMpPGA1lnAJK+8Y1iyiOCDrPSWm4cJ
         kRz/swNNJNDZ4juAHshflTfGCVjZOKln6s5A+dO/kZZacvPfKVMkca6Omnklwo7U9Z
         cUizrTsJJVGbg==
Date:   Thu, 29 Apr 2021 08:18:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2021-04-23
Message-ID: <20210429081809.7c75db47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c801ab6d-538e-836e-4857-3802f4793ab4@nbd.name>
References: <20210423120248.248EBC4338A@smtp.codeaurora.org>
        <20210428172411.78473936@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c801ab6d-538e-836e-4857-3802f4793ab4@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Apr 2021 06:54:45 +0200 Felix Fietkau wrote:
> On 2021-04-29 02:24, Jakub Kicinski wrote:
> > On Fri, 23 Apr 2021 12:02:48 +0000 (UTC) Kalle Valo wrote:  
> >> mt76: debugfs: introduce napi_threaded node  
> > 
> > Folks, why is the sysfs knob not sufficient?  
> Because mt76 has to use a dummy netdev for NAPI, which does not show up
> in sysfs.

Ah, the ephemeral nature of wireless netdevs. Makes sense.
