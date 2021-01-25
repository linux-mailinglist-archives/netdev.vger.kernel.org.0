Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34058303413
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbhAZFOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:14:30 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:18669 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729405AbhAYOXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 09:23:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611584588; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=n6LnzX+9OwV112HZOi7kygONlFWnbReQdwO0xSe4hbU=;
 b=q6OY7hFGe4JcldSA1mzyQfOrGdAxwwdnXQjbjBzsuz7LuxudSiJIvU2j8SAi4pTz7dgPozMo
 9Z7dLdVzjqTHETd9/X4MMfcy4bL++cnODVjFa5du0j+Aoe+A4yFKW4xUjKzfHfZmSvsmKHPp
 2dyQcWWObXvSEQ062hA8Yczu9Sw=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 600ed42b5677aca7bdc0eb78 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Jan 2021 14:22:35
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 26373C43461; Mon, 25 Jan 2021 14:22:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BFE08C433CA;
        Mon, 25 Jan 2021 14:22:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BFE08C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/5] rtlwifi: rtl_pci: fix bool comparison in expressions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210110121525.2407-2-yashsri421@gmail.com>
References: <20210110121525.2407-2-yashsri421@gmail.com>
To:     Aditya Srivastava <yashsri421@gmail.com>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        lukas.bulwahn@gmail.com, yashsri421@gmail.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210125142235.26373C43461@smtp.codeaurora.org>
Date:   Mon, 25 Jan 2021 14:22:35 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aditya Srivastava <yashsri421@gmail.com> wrote:

> There are certain conditional expressions in rtl_pci, where a boolean
> variable is compared with true/false, in forms such as (foo == true) or
> (false != bar), which does not comply with checkpatch.pl (CHECK:
> BOOL_COMPARISON), according to which boolean variables should be
> themselves used in the condition, rather than comparing with true/false
> 
> E.g., in drivers/net/wireless/realtek/rtlwifi/ps.c,
> "if (find_p2p_ie == true)" can be replaced with "if (find_p2p_ie)"
> 
> Replace all such expressions with the bool variables appropriately
> 
> Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>

5 patches applied to wireless-drivers-next.git, thanks.

d8cbaa3de403 rtlwifi: rtl_pci: fix bool comparison in expressions
f7c76283fc5f rtlwifi: rtl8192c-common: fix bool comparison in expressions
64338f0dfd6a rtlwifi: rtl8188ee: fix bool comparison in expressions
33ae4623d544 rtlwifi: rtl8192se: fix bool comparison in expressions
9264cabc1204 rtlwifi: rtl8821ae: fix bool comparison in expressions

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210110121525.2407-2-yashsri421@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

