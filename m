Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE5919EA0F
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 10:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgDEIpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 04:45:01 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:49556 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbgDEIpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 04:45:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586076300; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=YD+6B7bB8KDIMzLCo6S03UdZ+WXtGN9oqNBfZxnj7PU=; b=WseyDcEVh4sefHTKiIZiJ//HNIlOAy6p2zxT5sHyD8oJFrjIwtNMw8/A3vmmPn3gesXAI19a
 VtrPGl923Fmw0zAGNSLLQ7Y+T7++HNhAjxKIn1UbTRQqMh+RLeY0gntfu5/n7H/11rdDq/Xz
 i6pU013g0CcjU39wmhfH8A7/5Zg=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e899a8b.7fc9721a2538-smtp-out-n05;
 Sun, 05 Apr 2020 08:44:59 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A02E7C43637; Sun,  5 Apr 2020 08:44:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BC38AC433F2;
        Sun,  5 Apr 2020 08:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BC38AC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chris Rorvick <chris@rorvick.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] iwlwifi: actually check allocated conf_tlv pointer
References: <20200402050219.4842-1-chris@rorvick.com>
Date:   Sun, 05 Apr 2020 11:44:53 +0300
In-Reply-To: <20200402050219.4842-1-chris@rorvick.com> (Chris Rorvick's
        message of "Thu, 2 Apr 2020 00:02:19 -0500")
Message-ID: <87mu7qfhiy.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Rorvick <chris@rorvick.com> writes:

> Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
> conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
> ("iwlwifi: dbg: move debug data to a struct") but does not implement the
> check correctly.
>
> Tweeted-by: @grsecurity
> Signed-off-by: Chris Rorvick <chris@rorvick.com>

I'll add:

Fixes: 71bc0334a637 ("iwlwifi: check allocated pointer when allocating conf_tlvs")

> ---
> In this wasn't picked up?

Luca, can I take this directly?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
