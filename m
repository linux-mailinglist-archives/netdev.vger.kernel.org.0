Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5749BE2A1E
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408488AbfJXFsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:48:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52904 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404449AbfJXFsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:48:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2F52060B6E; Thu, 24 Oct 2019 05:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896104;
        bh=9xfFYo0OwH9yxo1xzsgyupR8IvI/OSOKlVUq7Vey1jI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AJ9i8ntd0hXx7Q2uIyrff/OJ1aqWx+/IizHg5sJN7N0of+Kft5vaZlAkVRMaP4Vja
         ha95IbygbA6TeLJ042pAXZJrR0MOO8DcYlEXhtI8oM6gXnuzIG8HfgCI00j6IWpVc0
         IvzxJLJRj1bv+9YhUaBPXOHiBwEp5hNX92gJOPkE=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3CB2260B6E;
        Thu, 24 Oct 2019 05:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896102;
        bh=9xfFYo0OwH9yxo1xzsgyupR8IvI/OSOKlVUq7Vey1jI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=fDV7FIwv08wlJxfohk4iuWL8phzYJzhGOstoE/nfQ4LglDLPaGZRBnTeFbmZQQ1WR
         cMtLp+ORDIcrWyQCN444zgWYQbzuyXWZmxbRZ+LOMNaixGiEdJg9NAGmjrK9/UQnQ3
         Pi88kuLUmL7rHLUjU/ICEirSqPDdtRQ6sSVj09c8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3CB2260B6E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] adm80211: remove set but not used variables 'mem_addr'
 and 'io_addr'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191023073842.34512-1-yuehaibing@huawei.com>
References: <20191023073842.34512-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <yuehaibing@huawei.com>,
        <kstewart@linuxfoundation.org>, <allison@lohutok.net>,
        <info@metux.net>, <tglx@linutronix.de>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191024054824.2F52060B6E@smtp.codeaurora.org>
Date:   Thu, 24 Oct 2019 05:48:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/admtek/adm8211.c:1784:16:
>  warning: variable mem_addr set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/admtek/adm8211.c:1785:15:
>  warning: variable io_addr set but not used [-Wunused-but-set-variable]
> 
> They are never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

f64b06bd362a adm80211: remove set but not used variables 'mem_addr' and 'io_addr'

-- 
https://patchwork.kernel.org/patch/11205833/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

