Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA8EEAB5C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfJaIJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:09:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43694 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJaIJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:09:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EB4666092F; Thu, 31 Oct 2019 08:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509368;
        bh=DyKIEnNbAakV7eKhtidXMXJonTBlaMKelRuwfRzjZUQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NxN2TZIoyOkQTYL6MI/d1OHPHXpxBH4kbINmaau7FJ8H6m4WeCbl5N1Bt/pqndq35
         I4QXUP2+1S7XZj99S5GpuxAYg928h9uu5vD+Gi5OrFX7yz8jtdAgYP88kRdq7ayebg
         g9YrG+SVZWMlXad8RVtbsUUS8vKORfsbM+PYICEg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5359060907;
        Thu, 31 Oct 2019 08:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509368;
        bh=DyKIEnNbAakV7eKhtidXMXJonTBlaMKelRuwfRzjZUQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XkOqPUHxYC1LE8JMSB4qvVikfzSu79o0X3jOLp+XglMFHdnE6xnW+NMH8gQezblpT
         nPRWwPfUkb5nf7utoM5dmHJlf78g9j7cvQpT/g8BYHSFmOuYrSzP8bnYmxy6wqJDjn
         347JZULjEUueu4uIjE5pnmpY3b3avC7baQp0HaEo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5359060907
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8821ae: Drop condition with no effect
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191029131624.GA17391@saurav>
References: <20191029131624.GA17391@saurav>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, Larry.Finger@lwfinger.net,
        gustavo@embeddedor.com, colin.king@canonical.com,
        saurav.girepunje@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191031080928.EB4666092F@smtp.codeaurora.org>
Date:   Thu, 31 Oct 2019 08:09:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saurav Girepunje <saurav.girepunje@gmail.com> wrote:

> As the "else if" and "else" branch body are identical the condition
> has no effect. So drop the "else if" condition.
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

4b15f83adaf1 rtlwifi: rtl8821ae: Drop condition with no effect

-- 
https://patchwork.kernel.org/patch/11217859/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

