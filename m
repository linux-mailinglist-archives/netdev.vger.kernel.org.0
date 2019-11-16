Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C90FEB2D
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 08:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKPHvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 02:51:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57380 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfKPHvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 02:51:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4914860B19; Sat, 16 Nov 2019 07:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573890692;
        bh=J4/5SmH7WQjMPE4cUQsszpAvti15y8WoBXfa60GmGpU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kPEPqrqL4fxHj42vKVDIUyxsMBEhlRXGgNATHxZs78xeLQ3YbLWwA68HEgnBFAvFN
         /aZ7/rfAWn15XWp9W91sAjrez1YIzUULQwnkxkvnDqvTPLt9TIo8liTnB8tJUWGchk
         UuzM7NWlXuQdUL9loPDfdmiMd5J2MmT+h7UmSX64=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (176-93-0-138.bb.dnainternet.fi [176.93.0.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0C52D60FF9;
        Sat, 16 Nov 2019 07:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573890689;
        bh=J4/5SmH7WQjMPE4cUQsszpAvti15y8WoBXfa60GmGpU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cxJdee/YyWWQvzPHvV2y0FnLdb9o7RapXWa8Q0eGwFXi39JiUqNwKOleWpelto+Tm
         7XKG5YJru7K9VuyZ44fUClZdO9L8qJ9Ik+gkEIa1NCQLiWKNBLTbu9nWjXMjIC0RGa
         MYuinSQt30eX4/mPA2ZaAnqdV491Z3ABHVWCftCM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0C52D60FF9
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <stas.yakovlev@gmail.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH -next 1/2] ipw2x00: remove set but not used variable 'reason'
References: <1573890083-33761-1-git-send-email-zhengbin13@huawei.com>
        <1573890083-33761-2-git-send-email-zhengbin13@huawei.com>
Date:   Sat, 16 Nov 2019 09:51:25 +0200
In-Reply-To: <1573890083-33761-2-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Sat, 16 Nov 2019 15:41:22 +0800")
Message-ID: <87y2wguuma.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin <zhengbin13@huawei.com> writes:

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/intel/ipw2x00/ipw2200.c: In function ipw_wx_set_mlme:
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:6805:9: warning: variable reason set but not used [-Wunused-but-set-variable]
>
> It is introduced by commit 367a1092b555 ("ipw2x00:
> move under intel vendor directory"), but never used, so remove it.

No it's not, as the commit title says it's only moving files to a
different location. I'll remove that sentence from the commit log.

-- 
Kalle Valo
