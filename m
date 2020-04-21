Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D371B204A
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 09:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDUHuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 03:50:32 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:23917 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgDUHuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 03:50:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587455431; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=kst1zyO2lCjRLxmPkLZYJ0AM8pU8DebCRu7H17+CtE0=;
 b=p5DDgu6lofezAuAkcM6izbqvuwvsSxhrXwvjSIMQWsAZKuHepCN/HEpaderSe6lU8iwhN/8S
 5gjOjz4CvQPBp3P4UeVg7uMxSNF+zaeWiLGLoOY2d2kBXFJxg9+feh8rj4uOR5KdSe5cdDIT
 Gk43eJ1N85NeIhxUzXQD50km5b8=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e9ea5c7.7f6ee29ba538-smtp-out-n02;
 Tue, 21 Apr 2020 07:50:31 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E9F6AC433BA; Tue, 21 Apr 2020 07:50:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 054C3C433CB;
        Tue, 21 Apr 2020 07:50:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 054C3C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless-drivers v3] iwlwifi: actually check allocated
 conf_tlv pointer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200417074558.12316-1-sedat.dilek@gmail.com>
References: <20200417074558.12316-1-sedat.dilek@gmail.com>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Rorvick <chris@rorvick.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200421075030.E9F6AC433BA@smtp.codeaurora.org>
Date:   Tue, 21 Apr 2020 07:50:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> wrote:

> From: Chris Rorvick <chris@rorvick.com>
> 
> Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
> conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
> ("iwlwifi: dbg: move debug data to a struct") but does not implement the
> check correctly.
> 
> Fixes: 71bc0334a637 ("iwlwifi: check allocated pointer when allocating conf_tlvs")
> Tweeted-by: @grsecurity
> Signed-off-by: Chris Rorvick <chris@rorvick.com>
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>

Patch applied to wireless-drivers.git, thanks.

a176e114ace4 iwlwifi: actually check allocated conf_tlv pointer

-- 
https://patchwork.kernel.org/patch/11494331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
