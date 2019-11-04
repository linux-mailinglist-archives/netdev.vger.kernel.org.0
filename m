Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A47EE48B
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 17:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfKDQVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 11:21:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33844 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfKDQVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 11:21:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AE8A160300; Mon,  4 Nov 2019 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572884461;
        bh=mAwYNNw6CkSSmB+D5DesrCl5qikS8Btrviv8uSniBiw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RYthr5rFb1fViuvMm/4B9R0j0qAFTI/Ut4fOf3sk9TFqrTh263EL/tbRbS0e4zT1T
         oLnn6dQ3+4J/S/fugiA4dLMERpyiO/Fqkmny8lQAbV0sd0o/ulJe+V49c4qweCMeJl
         1AVQSxZHxoFy0jlmtmNoOhV67R456+Uhux62E9tY=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 174A660300;
        Mon,  4 Nov 2019 16:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572884460;
        bh=mAwYNNw6CkSSmB+D5DesrCl5qikS8Btrviv8uSniBiw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mtvTztmhvQZDJ1BHqKrPMUgw+OjXuX6xk4VIr7zrnutzmGDoFdptWnhqJJOfrZtCH
         i/AQrLFUzysUqWLzlMn/VX2gxu1YdC7fGc9Z0sAFPfjeGFHvf0I0NW7DCcfbp6Idsh
         aKzEpRYvE2LqrtHY3u4A47W/fWHYzGedB4kcdNbY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 174A660300
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <stas.yakovlev@gmail.com>, <simon.horman@netronome.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] wireless: remove unneeded variable and return 0
References: <1572684922-61805-1-git-send-email-zhongjiang@huawei.com>
Date:   Mon, 04 Nov 2019 18:20:56 +0200
In-Reply-To: <1572684922-61805-1-git-send-email-zhongjiang@huawei.com> (zhong
        jiang's message of "Sat, 2 Nov 2019 16:55:20 +0800")
Message-ID: <87a79b7guv.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> writes:

> The issue is detected with help of coccinelle.
>
> v2 -> v3:
>     Remove [PATCH 3/3] of series. Because fappend will use the
>     local variable.  

You really need to test your patches. If you submit patches without
build testing I'm not going to take such patches.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
