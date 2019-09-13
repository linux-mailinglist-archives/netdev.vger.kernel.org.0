Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC3DB22FE
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 17:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390952AbfIMPHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 11:07:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389880AbfIMPHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 11:07:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 584DA60767; Fri, 13 Sep 2019 15:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568387227;
        bh=nM0m64M+U4PgSysi9mFISXqSJW1Dxue3D6672lamj4k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pIuI2bidydmzrgHJmDeR4tifLa25wRqVRzrJliCORZk36yBIX7m6NtgmHeDECB9SV
         hWFLKJdeitr/1gDYC6+8lj9CR+A1snplmpkQzdV6lmEsZCiaEfT9mItmQBrFt5x5NF
         ThUkRa7aGbj8Mz/X/bY1pwuc6Udo31VpCVnmJ7kA=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2FC08602F8;
        Fri, 13 Sep 2019 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568387226;
        bh=nM0m64M+U4PgSysi9mFISXqSJW1Dxue3D6672lamj4k=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CsoGNqj+uua0YTo6fQb63fi9EiAIYsRv05G5lt5A+8xgy1G5zcn5Ndi//6R3tHa9n
         nB9rECfgobogY5jisDv5ZCUfYqPQphHkDgTjq3yK9BxcnxyrMpe7/+/pUq8kYYtru+
         KeYp6BC172wDl4qmIO3JIF3FtwpA2ARxRoJf/gkI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2FC08602F8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] rtlwifi: rtl8192ce: replace
 _rtl92c_evm_db_to_percentage with generic version
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190910190422.63378-2-straube.linux@gmail.com>
References: <20190910190422.63378-2-straube.linux@gmail.com>
To:     Michael Straube <straube.linux@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190913150707.584DA60767@smtp.codeaurora.org>
Date:   Fri, 13 Sep 2019 15:07:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael Straube <straube.linux@gmail.com> wrote:

> Function _rtl92c_evm_db_to_percentage is functionally identical
> to the generic version rtl_evm_db_to_percentage, so remove
> _rtl92c_evm_db_to_percentage and use the generic version instead.
> 
> Signed-off-by: Michael Straube <straube.linux@gmail.com>

3 patches applied to wireless-drivers-next.git, thanks.

1335ad27bd07 rtlwifi: rtl8192ce: replace _rtl92c_evm_db_to_percentage with generic version
622c19ed3607 rtlwifi: rtl8192cu: replace _rtl92c_evm_db_to_percentage with generic version
3a1f85798e9f rtlwifi: rtl8192de: replace _rtl92d_evm_db_to_percentage with generic version

-- 
https://patchwork.kernel.org/patch/11140005/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

