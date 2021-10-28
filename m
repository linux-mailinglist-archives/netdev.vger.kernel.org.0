Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CD343E219
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhJ1N3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:29:25 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:62706 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbhJ1N3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:29:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635427617; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=uHCxDRy0CnpAT24ZiF7PmTZGX6J9BLvsOGhtHcHUmSg=;
 b=hhELFzSnH46pn9F5TtTPeMYWM4Mb7zGMDlfttOuLUG8DDJCAj0LgIJ2TMCAvy21Jy+isrOQa
 u65xR/Gxm6DRdsfFKcDByoUCF8LUWrbfw754OvMotMcVkssgOLIKk08saOGmRkK05pz82t2+
 hDcc/W19lLqTMmhW30SMpI2w0eI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 617aa51ac8c1b282a5bcc43a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Oct 2021 13:26:50
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C7A82C4361A; Thu, 28 Oct 2021 13:26:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8FC82C4338F;
        Thu, 28 Oct 2021 13:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 8FC82C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/4] rtl8187: fix control-message timeouts
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211025120522.6045-4-johan@kernel.org>
References: <20211025120522.6045-4-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163542760369.5095.9529718902360790096.kvalo@codeaurora.org>
Date:   Thu, 28 Oct 2021 13:26:49 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> wrote:

> USB control-message timeouts are specified in milliseconds and should
> specifically not vary with CONFIG_HZ.
> 
> Fixes: 605bebe23bf6 ("[PATCH] Add rtl8187 wireless driver")
> Cc: stable@vger.kernel.org      # 2.6.23
> Signed-off-by: Johan Hovold <johan@kernel.org>

2 patches applied to wireless-drivers-next.git, thanks.

2e9be536a213 rtl8187: fix control-message timeouts
541fd20c3ce5 rsi: fix control-message timeout

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211025120522.6045-4-johan@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

