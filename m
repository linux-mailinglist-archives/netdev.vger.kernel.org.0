Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71962209C3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgGOKU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:20:29 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:35484 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728683AbgGOKU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 06:20:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594808428; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=KTzJMBs9HCG+sSAIrBVz5xZyu4LzPrPBKllsE/vh7ds=;
 b=V/jhTGBSVU5BLFL/pvIYYbyATkB7qF+q9tN8xEVxl+ucKX17okYRWD0GZzce8kKIEdtbucji
 gxCSKg2xhXpENuNyeIo0Tw3O8V5j3VriaqNVp0ihAIHyVq4F0eIHpsea/CaBY1Sn9o1uWp4a
 EJPJtg9bO1ecAiwqYOfQyt+knpM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f0ed85c1012768490cdfcde (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 10:20:12
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6B907C433CA; Wed, 15 Jul 2020 10:20:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 61DF2C433C9;
        Wed, 15 Jul 2020 10:20:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 61DF2C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 7/9] intersil: fix wiki website url
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200605154112.16277-8-f.suligoi@asem.it>
References: <20200605154112.16277-8-f.suligoi@asem.it>
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
Message-Id: <20200715102012.6B907C433CA@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 10:20:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flavio Suligoi <f.suligoi@asem.it> wrote:

> In some Intesil files, the wiki url is still the old
> "wireless.kernel.org" instead of the new
> "wireless.wiki.kernel.org"
> 
> Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>

Fails to apply:

fatal: corrupt patch at line 97
error: could not build fake ancestor
Applying: intersil: fix wiki website url
Patch failed at 0001 intersil: fix wiki website url
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11589909/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

