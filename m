Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D5C417615
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346015AbhIXNmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:42:15 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:58658 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345220AbhIXNmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 09:42:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632490835; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=w/k+I7HfFvhqlZux9IhYFca8nsZzRvy3CVRfH5poRYQ=; b=agTtrbBzTB2PlEUFswe7rdRnGANDypbvuYnVcDwolly9niiMeOA3KZv5bHAPi0/C2r/4cfN4
 VjWkH4SbWtQ8HuSwZrabxNHm/qL/nz19WKgpRebXf9esB4yIZ3lurD39kW2iY++WCe3PQzml
 w5J05VR+FxIB3lh/CpUDyFLfiZw=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 614dd538e0480a7d6fa0bdfb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 24 Sep 2021 13:40:08
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7EA34C43618; Fri, 24 Sep 2021 13:40:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2A78EC4338F;
        Fri, 24 Sep 2021 13:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 2A78EC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH] [v16] wireless: Initial driver submission for pureLiFi LiFi Station
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20210924132655.57406-1-srini.raju@purelifi.com>
Date:   Fri, 24 Sep 2021 16:40:01 +0300
In-Reply-To: <20210924132655.57406-1-srini.raju@purelifi.com> (Srinivasan
        Raju's message of "Fri, 24 Sep 2021 14:26:06 +0100")
Message-ID: <87pmsyrt1q.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.
>
> LiFi is a mobile wireless technology that uses light
> rather than radio frequencies to transmit data.
>
> 802.11 bb is focused on introducing necessary changes to
> IEEE 802.11 Stds to enable communications in the light medium
>
> This driver implementation has been based on the zd1211rw driver.
>
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management.
>
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture.
>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
>
> ---
> v16:
>  - Fixed atomic variable misuses
>  - Fixed comments spacing
>  - Removed static variables used
>  - Moved #defines to header file
>  - Removed doxygen style comments
>  - Removed magic numbers and cleanup code
>  - Fixed warning reported by kernel test robot

Just FYI I'm not going to review this version, I'll wait for the version
with the new band.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
