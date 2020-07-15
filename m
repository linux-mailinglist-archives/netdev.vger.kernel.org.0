Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3932209BB
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgGOKTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:19:41 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:31863 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgGOKTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 06:19:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594808380; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=s+17l8yWmlfyAoaYbRmoSrnduPrEF0i6PsWblwvSjLs=;
 b=uNjKpddhbXUAlu3dIPk4Q+AMzfhV9ouvhF5SFOMJe9QIBelzMyk7bHtwmnGa4cTwnuA4fqcO
 05JI1DxF6DBgzoS3xsXzAxztwdiiiLBn7I2OtAYva4fVxuZhosY3f7cWHSDtVDU6LLclhsbm
 3bd7JUwcXTU0Mey+UEhSeoo4S5Y=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n17.prod.us-west-2.postgun.com with SMTP id
 5f0ed82975eeb235f665a843 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 10:19:21
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 81C37C433B1; Wed, 15 Jul 2020 10:19:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8DA70C43391;
        Wed, 15 Jul 2020 10:19:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8DA70C43391
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/9] wireless: fix wiki website url in main Kconfig
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200605154112.16277-3-f.suligoi@asem.it>
References: <20200605154112.16277-3-f.suligoi@asem.it>
To:     Flavio Suligoi <f.suligoi@asem.it>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johan Hovold <johan@kernel.org>,
        Saurav Girepunje <saurav.girepunje@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Flavio Suligoi <f.suligoi@asem.it>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200715101920.81C37C433B1@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 10:19:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flavio Suligoi <f.suligoi@asem.it> wrote:

> The wiki url is still the old "wireless.kernel.org"
> instead of the new "wireless.wiki.kernel.org"
> 
> Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>

3 patches applied to wireless-drivers-next.git, thanks.

0ef2c2d1a9d0 wireless: fix wiki website url in main Kconfig
eb17a4f9acf1 atmel: fix wiki website url
8bd4147c4b17 broadcom: fix wiki website url

-- 
https://patchwork.kernel.org/patch/11589899/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

