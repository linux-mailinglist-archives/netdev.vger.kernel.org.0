Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40FD2357FC
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHBPQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:16:17 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:14844 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726325AbgHBPQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 11:16:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596381376; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=uqeT3t/7MSJQMb1ZDXca/5my9A+b02m3EYD9qcMgMi8=;
 b=BOBLlMwbG4EpUjyucd09gdGQRNGKuG+r2sERGdr7qYPyl9qxHnGC41Bb8SV15VdRKUWpOhfR
 lbYE+o+aWUV9481rU+zSECd5LeKaBOsPKcWlrZnR8HYkRcYcIV2NDpbCd66B7IVgdLvx2x1P
 XcaobLE1N3D1Niu0sDrNsPQfTL4=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n16.prod.us-west-2.postgun.com with SMTP id
 5f26d8b5ba6d142d1c3be76b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 02 Aug 2020 15:16:05
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E24BBC43391; Sun,  2 Aug 2020 15:16:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5738DC433C9;
        Sun,  2 Aug 2020 15:16:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5738DC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2x00: Replace HTTP links with HTTPS ones
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200718100240.98593-1-grandmaster@al2klimov.de>
References: <20200718100240.98593-1-grandmaster@al2klimov.de>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     stas.yakovlev@gmail.com, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200802151604.E24BBC43391@smtp.codeaurora.org>
Date:   Sun,  2 Aug 2020 15:16:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Alexander A. Klimov" <grandmaster@al2klimov.de> wrote:

> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

Patch applied to wireless-drivers-next.git, thanks.

348cb5dc4d70 ipw2x00: Replace HTTP links with HTTPS ones

-- 
https://patchwork.kernel.org/patch/11671879/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

