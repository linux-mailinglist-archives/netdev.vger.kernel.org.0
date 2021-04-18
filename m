Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC4F3633DD
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 07:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbhDRFy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 01:54:59 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:14611 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231555AbhDRFy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 01:54:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618725271; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=GUuUGywy2mH+60y9PKNoI/P0xG2sd/9arcB7KOwkpPg=;
 b=PO+taF7L7cCf5Zz19SoPOk4FdQpR7iV0IzxqWQjEeKzpjGNXLP4sX68G1zrnRT1GnqMFHHDF
 t+nOlHqNPj3VOAcvNu2Rbjgd1UmgaGJtuVBWVpERsh+v2hhNGGbUqbVkn5HsIt/sOp3q23Rq
 2M4G3/zEO2C/L0Z6qWapxk5JUVg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 607bc9962cbba88980ac24b3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 18 Apr 2021 05:54:30
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D5B49C4323A; Sun, 18 Apr 2021 05:54:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 571D6C433D3;
        Sun, 18 Apr 2021 05:54:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 571D6C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] marvell: libertas_tf: fix error return code of
 if_usb_prog_firmware()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210305033115.6015-1-baijiaju1990@gmail.com>
References: <20210305033115.6015-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, lee.jones@linaro.org,
        colin.king@canonical.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210418055429.D5B49C4323A@smtp.codeaurora.org>
Date:   Sun, 18 Apr 2021 05:54:29 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> When check_fwfile_format() fails, no error return code of
> if_usb_prog_firmware() is assigned.
> To fix this bug, ret is assigned with -EINVAL as error return code.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Someone needs to review this.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210305033115.6015-1-baijiaju1990@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

