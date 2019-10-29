Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213A0E8B74
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 16:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389843AbfJ2PHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 11:07:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52158 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389520AbfJ2PHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 11:07:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4F6D56079D; Tue, 29 Oct 2019 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572361672;
        bh=PUi0TnV0ZUkx5WjneOzdJHo4q0wVk5Vjn1TlfRNP7xY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=G4v6Q6M6pvohiM+NtPkxsIGBmW8SdQK+nPdbMxQgAWDeBG8tqD4xjjhaQGqPlnQrL
         1sWccxuqVKD57kF/TmEs/M/tZt/7Z00XmF7SJmpONnziyitHLGhKhBvGE3W+d7tUO/
         Lt1NiwS4MtWHRBhKolKQ8EK0li8Eqyl2H5r6evy4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ABD376079D;
        Tue, 29 Oct 2019 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572361671;
        bh=PUi0TnV0ZUkx5WjneOzdJHo4q0wVk5Vjn1TlfRNP7xY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=V2NRj/uuLkM2g2ITLisZUZafcQj6Z+43LrN1bFwopuqy/VEoY4HQPSkCxIznzFFbZ
         5JHdQ0B6EaKlZFvD5FSPAm8/Ggzm2Ulaj5hPGR2IEIYMD60KxKubO+7KMcmafFKhaE
         Ywd1T/uvS8iNfD+AD7f+V84kqxfjbr00dZLAekM0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ABD376079D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, saurav.girepunje@hotmail.com
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8192c:Drop condition with no effect
References: <20191028184654.GA26755@saurav>
Date:   Tue, 29 Oct 2019 17:07:46 +0200
In-Reply-To: <20191028184654.GA26755@saurav> (Saurav Girepunje's message of
        "Tue, 29 Oct 2019 00:16:54 +0530")
Message-ID: <874kzr4mkd.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saurav Girepunje <saurav.girepunje@gmail.com> writes:

> As the "else if" and "else" branch body are identical the condition
> has no effect. So drop the "else if" condition.
>
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Thanks, I see these patches in patchwork now.

But then you submit a new version of a patch, please mark it as "[PATCH v2]":

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

This is for future submissions, no need to resend because of this.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
