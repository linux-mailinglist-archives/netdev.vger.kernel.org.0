Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28AC116049E
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 16:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgBPPwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 10:52:44 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:22785 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728361AbgBPPwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 10:52:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581868359; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=mTPpxjIgsi8/gxj4KKOu5w05+hJqvJScCCYGAArHYzI=; b=HoxXQ82YVT/h2+frm5Cf9L0hKpytv0uPNfX/b2g0Y+Hv8jq70SdPeOq6P7vfEwSPHM6C249a
 IrnjTS5Cu6bnYHrLJKjCDUBPyh7tXCyfSWcpfBv8yiXX4qTvAYnFg8gOPjz+Rx/Zb3utLR9n
 ySQuf2SNrzLMFeo0loXCNSjAnCE=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e496546.7f59f49b2b90-smtp-out-n02;
 Sun, 16 Feb 2020 15:52:38 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E65FDC4479F; Sun, 16 Feb 2020 15:52:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 81D30C43383;
        Sun, 16 Feb 2020 15:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 81D30C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     David Miller <davem@davemloft.net>, dcbw@redhat.com,
        kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] Migrate QRTR Nameservice to Kernel
References: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
        <34daecbeb05d31e30ef11574f873553290c29d16.camel@redhat.com>
        <20200213153007.GA26254@mani>
        <20200213.074755.849728173103010425.davem@davemloft.net>
        <20200214091156.GD6419@Mani-XPS-13-9360>
Date:   Sun, 16 Feb 2020 17:52:33 +0200
In-Reply-To: <20200214091156.GD6419@Mani-XPS-13-9360> (Manivannan Sadhasivam's
        message of "Fri, 14 Feb 2020 14:41:56 +0530")
Message-ID: <87zhdiv8am.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ linux-wireless

Hi Dave & Dan,

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:

> On Thu, Feb 13, 2020 at 07:47:55AM -0800, David Miller wrote:
>> From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>> Date: Thu, 13 Feb 2020 21:00:08 +0530
>> 
>> > The primary motivation is to eliminate the need for installing and starting
>> > a userspace tool for the basic WiFi usage. This will be critical for the
>> > Qualcomm WLAN devices deployed in x86 laptops.
>> 
>> I can't even remember it ever being the case that wifi would come up without
>> the help of a userspace component of some sort to initiate the scan and choose
>> and AP to associate with.
>> 
>> And from that perspective your argument doesn't seem valid at all.
>
> For the WiFi yes, but I should have added that this QRTR nameservice is being
> used by modems, DSPs and some other co-processors for some offloading tasks.
> So currently, they all depend on userspace ns tool for working. So migrating
> it to kernel can benefit them all.

So the background of this is to get QCA6390[1] (a Qualcomm Wi-Fi 6 PCI
device) supported in ath11k without additional dependencies to user
space. Currently Bjorn's QRTR user space daemon[2] needs to be running
for ath11k to even be able to boot the firmware on the device.

In my opinion a wireless driver should be "self contained", meaning that
it should be enough just to update the kernel and install the firmware
images to /lib/firmware and nothing else should be needed. But without
Mani's patches a user with QCA6390 on her laptop would need to fetch and
install the QRTR daemon (as I doubt distros have it pre-installed)
before getting Wi-Fi working on the laptop. But without Wi-Fi trying to
fetch anything from the internet is annoying, so not a very smooth user
experience.

I assume Dave above refers to iw, wpasupplicant and hostapd but I
consider them very different from QRTR. iw, wpasupplicant and hostapd
are generic wireless user space components using the generic
nl80211/wext interfaces and they work with _all_ upstream drivers. They
are also pre-installed by distros so it's basically plug and go for the
user to get Wi-Fi running.

Also from high level design point of view I don't like the idea that
wireless drivers would start to having vendor specific user components,
like Qualcomm, Marvell, Intel and other vendors having their own daemons
running in addition of generic wireless components (iw/wpas/hostapd).
That would be a quite mess trying to handle backwards compatibility and
all other stable kernel/user space interface requirements.

So to have a smooth out of box experience for ath11k users, I consider
that we need QRTR in the kernel and that's why need Mani's patches[3].

[1] https://www.qualcomm.com/products/fastconnect-6800

[2] https://github.com/andersson/qrtr/

[3] https://patchwork.ozlabs.org/cover/1237353/

    https://patchwork.ozlabs.org/patch/1237355/

    https://patchwork.ozlabs.org/patch/1237354/
    
-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
