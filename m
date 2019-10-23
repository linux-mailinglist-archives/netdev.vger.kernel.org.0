Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E95E2086
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407260AbfJWQZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:25:39 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:57578 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389149AbfJWQZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:25:39 -0400
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:fe80::5400:ff:fe0c:dfa0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id CFB2060CD4E;
        Wed, 23 Oct 2019 18:25:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1571847935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T8zzS7fQ1+h8Dch7o2XgPzxblvYJzj9a0o53CwTbiaY=;
        b=jnyA/zUOIOvhANewA4/U/XLZ/Yg3a6p75ZDGpruHbTgVE0VI+z43o04fM9QZWleV0efy7t
        wakILwZ4dlR90ml71qd+e8CMJa1hltGwsfHZiM/TRJN9xDLrbq+Q5/4hHoIwQmYQewf3mI
        tqSHWB4vLQInidp3POEexp11AoVST2E=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Oct 2019 18:25:35 +0200
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: mt76x2e hardware restart
In-Reply-To: <20191023085039.GB2461@localhost.localdomain>
References: <deaafa7a3e9ea2111ebb5106430849c6@natalenko.name>
 <c6d621759c190f7810d898765115f3b4@natalenko.name>
 <9d581001e2e6cece418329842b2b0959@natalenko.name>
 <20191012165028.GA8739@lore-desk-wlan.lan>
 <f7695bc79d40bbc96744a639b1243027@natalenko.name>
 <96f43a2103a9f2be152c53f867f5805c@natalenko.name>
 <20191016163842.GA18799@localhost.localdomain>
 <20191023085039.GB2461@localhost.localdomain>
Message-ID: <a2f0be152fc9ed53ea10b8e260c23faf@natalenko.name>
X-Sender: oleksandr@natalenko.name
User-Agent: Roundcube Webmail/1.3.10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

On 23.10.2019 10:50, Lorenzo Bianconi wrote:
> I think I spotted the SG issue on mt76x2e. Could you please:
> - keep pcie_aspm patch I sent
> - remove the debug patch where I disabled TX Scatter-Gather on mt76x2e
> - apply the following patch

Thanks for the patch. So far so good, I was able to start AP, connect to 
it and conduct a couple of simple speed tests.

I'll use it more today and will let you know in case something breaks.

-- 
   Oleksandr Natalenko (post-factum)
