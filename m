Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779281AD827
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 10:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgDQIDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 04:03:23 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:21921 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729166AbgDQIDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 04:03:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587110602; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=u3586iFRwcYPsbJjaSDkiDP7IdnytFfQnBeWLZSw2rs=; b=BD4q/K0JpNekcKKkr0F6eNOpajfJKz4qYulCg4xyJdpsUZADW9Zy7r3XwLsWCGyiya6aypQv
 bTp/zJpR0n58Ga3R4E+TU3QiqmXrVW0flNP2PkmLb7yZratTTk2jqs5VQx3FuIrXJRb6Mwe7
 b8A2n2LGqXpcToF2akJTsZ5tDOQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e9962bc.7fe90db55848-smtp-out-n01;
 Fri, 17 Apr 2020 08:03:08 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 449FDC4478F; Fri, 17 Apr 2020 08:03:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 71443C433BA;
        Fri, 17 Apr 2020 08:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 71443C433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Rorvick <chris@rorvick.com>
Subject: Re: [PATCH wireless-drivers v3] iwlwifi: actually check allocated conf_tlv pointer
References: <20200417074558.12316-1-sedat.dilek@gmail.com>
Date:   Fri, 17 Apr 2020 11:03:03 +0300
In-Reply-To: <20200417074558.12316-1-sedat.dilek@gmail.com> (Sedat Dilek's
        message of "Fri, 17 Apr 2020 09:45:58 +0200")
Message-ID: <87pnc6pmiw.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> writes:

> From: Chris Rorvick <chris@rorvick.com>
>
> Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
> conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
> ("iwlwifi: dbg: move debug data to a struct") but does not implement the
> check correctly.
>
> Fixes: 71bc0334a637 ("iwlwifi: check allocated pointer when allocating conf_tlvs")
> Tweeted-by: @grsecurity
> Message-Id: <20200402050219.4842-1-chris@rorvick.com>
> Signed-off-by: Chris Rorvick <chris@rorvick.com>
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>

Thanks, looks good to me. I'll just remove the Message-Id tag, it's not
really needed in this case.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
