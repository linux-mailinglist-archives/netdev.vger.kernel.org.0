Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914F9D3BA9
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfJKIxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:53:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42808 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfJKIxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 04:53:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7675C60791; Fri, 11 Oct 2019 08:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570784016;
        bh=B1nJDhxTQ/e2NJsYTGupIirDTTmjjX1VIfseAaQfZ/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gXsxcfYGoaC2vxdcadFn1AS6GsxbwHnsidqLrl5N2jFfcWBICI+Mg1ivqKl+oV0Da
         xyLl9nogWzDOIqjqYu55hgzsBE3QWE7ToLgWoVMtn6saRSBDUzDPPiBI3baFkkXYkP
         RREqUioClukQ6op3PX3N+LglvqdO0oyQKmlp/lwk=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BFFD3602DC;
        Fri, 11 Oct 2019 08:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570784016;
        bh=B1nJDhxTQ/e2NJsYTGupIirDTTmjjX1VIfseAaQfZ/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=c+cCrfoGz+vfkBX6an+T6ug2h3NSlEXITVrRMjvijVkmYV8vw/TDire3tlSehftnm
         DTPqearSyxR7YzXWNaEpeP6sKT8u4a4NupUngiv0k0gniJn6BL6fNA1yLALqMX3pIf
         pExhEBbW2a2o+ldD+qP7l01pG2a8Yld6c5Y4Dh+k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BFFD3602DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RESEND] rtlwifi: rtl8192ee: Remove set but not used
 variable 'err'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
References: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191011085336.7675C60791@smtp.codeaurora.org>
Date:   Fri, 11 Oct 2019 08:53:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin <zhengbin13@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

59f4567d228f rtlwifi: rtl8192ee: Remove set but not used variable 'err'

-- 
https://patchwork.kernel.org/patch/11180853/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

