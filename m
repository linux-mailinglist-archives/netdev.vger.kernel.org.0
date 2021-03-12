Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69063398D2
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 22:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhCLVD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 16:03:57 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:10819 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234723AbhCLVDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 16:03:42 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615583022; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=wJrgzOmpU1yLw4Bp3fBDFkdv/DSbLiF6I2QMOSBsXtI=; b=CTtFBUl0ZCW5iZWU/YRiYVP0he3W/Wci/kPb1dVWB3mx9Se8Nbl5QZqtMplSq/JT4W6Tft2L
 gsUob6UTcTvT8pCj/hC6w3MPD7/q8ns1eEexU+kvX4f7dbzFPmE3XpfxdPIWlpV569L4ABf9
 fnAmI1kZ+yVGumq2nuzyIrTX2sY=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 604bd72d4db3bb68018a0ea3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 12 Mar 2021 21:03:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E22E1C433CA; Fri, 12 Mar 2021 21:03:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C6FFFC433CA;
        Fri, 12 Mar 2021 21:03:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C6FFFC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] wireless/nl80211: fix wdev_id may be used uninitialized
References: <20210312163651.1398207-1-jarod@redhat.com>
Date:   Fri, 12 Mar 2021 23:03:35 +0200
In-Reply-To: <20210312163651.1398207-1-jarod@redhat.com> (Jarod Wilson's
        message of "Fri, 12 Mar 2021 11:36:51 -0500")
Message-ID: <87lfasaxug.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> writes:

> Build currently fails with -Werror=maybe-uninitialized set:
>
> net/wireless/nl80211.c: In function '__cfg80211_wdev_from_attrs':
> net/wireless/nl80211.c:124:44: error: 'wdev_id' may be used
> uninitialized in this function [-Werror=maybe-uninitialized]

Really, build fails? Is -Werror enabled by default now? I hope not.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
