Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77B7E17A9
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404254AbfJWKQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:16:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53868 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403810AbfJWKQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:16:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 10E1C61282; Wed, 23 Oct 2019 10:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571825814;
        bh=tS28jUJhwHH2gy1huRdTOg7DLGrPTLou2VFpUP+xrr4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DlvVzDAHTKuNxc8am8S9BNY532beF7zvBcVuYZGq3u4fN668cBXsGoHReODnjKzkH
         nBnTpr49Kll5jXte09NftMry1siH/Ix7AnjXD0rxhDjILxY9QIzXoh577Ba1i81TaS
         mqmiBLIdrRHidVp0HRsmYvr9ZhbVvpHRtFafkIfg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4A53C6126F;
        Wed, 23 Oct 2019 10:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571825809;
        bh=tS28jUJhwHH2gy1huRdTOg7DLGrPTLou2VFpUP+xrr4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LVDf3tcxlr0PG/Y2JkbhrqpnBSzHRcKgL0zg3A44qao1jnvzhrrWkOchQT86dDkZ0
         PMb9JT5wbyPweXhsZ1U/kTkUdOc1ac4nFQwo92HdNCA5k50PP4amgE8Y62GGIA3H2V
         XpFtD0q+mY5ipz0ht9Df5ls9yR4RJ/kRBu+1eB5M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4A53C6126F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtl8xxxu: remove set but not used variable 'rate_mask'
References: <20191023075342.26656-1-yuehaibing@huawei.com>
        <CAB4CAwek7u3_U9T_314P7qK2o7ReKQ0EVvYTkyzrORZjhdSRnA@mail.gmail.com>
Date:   Wed, 23 Oct 2019 13:16:43 +0300
In-Reply-To: <CAB4CAwek7u3_U9T_314P7qK2o7ReKQ0EVvYTkyzrORZjhdSRnA@mail.gmail.com>
        (Chris Chiu's message of "Wed, 23 Oct 2019 18:10:50 +0800")
Message-ID: <87sgnjeph0.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> writes:

> On Wed, Oct 23, 2019 at 3:54 PM YueHaibing <yuehaibing@huawei.com> wrote:
>>
>> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4484:6:
>>  warning: variable rate_mask set but not used [-Wunused-but-set-variable]
>>
>> It is never used since commit a9bb0b515778 ("rtl8xxxu: Improve
>> TX performance of RTL8723BU on rtl8xxxu driver")
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
> Singed-off-by: Chris Chiu <chiu@endlessm.com>

In the future please use Reviewed-by:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#using-reported-by-tested-by-reviewed-by-suggested-by-and-fixes

Signed-off-by is supposed to be used when you are sending a patch and
Acked-by is used by the driver maintainer, in this case Jes.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
