Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E41D21ED38
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgGNJvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:51:11 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:35763 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgGNJvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 05:51:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594720269; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=dHOZ0Og//JCRtETsRCjH9YVR+seeMRizqUL3UEZLAgI=;
 b=gGu98TLNU+Uz3fozb7lkeydVu2ekYUt6uvfQRKoXE8l8q9Y1hXza5+tcom6pFwvcnT1Wi8JL
 avVbF0DeFqRHQtUfR10dYd+F2dv70y8SA2RIxyBJMtTu7J9hhYP74o3vexS1PyrpbWBDdkKX
 gknZKgM46DgSAvfvlAa3DrQ0VR8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n16.prod.us-west-2.postgun.com with SMTP id
 5f0d8003ee86618575bfe743 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 14 Jul 2020 09:50:59
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A7004C433AD; Tue, 14 Jul 2020 09:50:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 89E5EC433C8;
        Tue, 14 Jul 2020 09:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 89E5EC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] brcmfmac: Transform compatible string for FW loading
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200701112201.6449-1-matthias.bgg@kernel.org>
References: <20200701112201.6449-1-matthias.bgg@kernel.org>
To:     matthias.bgg@kernel.org
Cc:     arend.vanspriel@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, mbrugger@suse.com,
        netdev@vger.kernel.org, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, hante.meuleman@broadcom.com,
        linux-kernel@vger.kernel.org, hdegoede@redhat.com,
        wright.feng@cypress.com, matthias.bgg@kernel.org,
        brcm80211-dev-list@cypress.com, franky.lin@broadcom.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200714095058.A7004C433AD@smtp.codeaurora.org>
Date:   Tue, 14 Jul 2020 09:50:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

matthias.bgg@kernel.org wrote:

> From: Matthias Brugger <mbrugger@suse.com>
> 
> The driver relies on the compatible string from DT to determine which
> FW configuration file it should load. The DTS spec allows for '/' as
> part of the compatible string. We change this to '-' so that we will
> still be able to load the config file, even when the compatible has a
> '/'. This fixes explicitly the firmware loading for
> "solidrun,cubox-i/q".
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> Reviewed-by: Hans deGoede <hdegoede@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

29e354ebeeec brcmfmac: Transform compatible string for FW loading

-- 
https://patchwork.kernel.org/patch/11636153/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

