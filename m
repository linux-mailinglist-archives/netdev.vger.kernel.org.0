Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE5B7A31A
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 10:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbfG3I3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:29:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34034 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbfG3I3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:29:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7E64D60364; Tue, 30 Jul 2019 08:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564475394;
        bh=menrHelllvoSAEob7qyUGOB6xMltFu26Q0XkIjqBajU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=D9vFOkQxB7BlpnKwz0K6RwAOXgt+9uBLjUfVy4WdzSFKYmom6lLrdElrAHDO47O9g
         EUNZfTPOM5GTtuWXXpS11ASRu/2jKyPubDLQBrrar923ofgB2rw73IJ24x+KKY+HT2
         GcMk+IONwZfiIEJv9iIamukhIgDy/ciIOiHCXXjU=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BDC4D60364;
        Tue, 30 Jul 2019 08:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564475393;
        bh=menrHelllvoSAEob7qyUGOB6xMltFu26Q0XkIjqBajU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=P64oKLBz9GLbt0NjsrO54/2n5VxDgP6IlXxSEXBRhJf/89J+hlxybTakdpGQaFTm/
         DeMhx4FPRRg1Be/AOddGQB4TaV+kQIBFPwcR4CL6XanEC/Pi19PNj9NDud5AvzhvsG
         NC71ZZV0bGxs4acBveXwR98UsHmXY8zj3lDk0+K0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BDC4D60364
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Enrico Weigelt\, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, amitkarwar@gmail.com,
        siva8118@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] drivers: net: wireless: rsi: return explicit error values
References: <1564413872-10720-1-git-send-email-info@metux.net>
Date:   Tue, 30 Jul 2019 11:29:49 +0300
In-Reply-To: <1564413872-10720-1-git-send-email-info@metux.net> (Enrico
        Weigelt's message of "Mon, 29 Jul 2019 17:24:32 +0200")
Message-ID: <87k1c0lybm.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Enrico Weigelt, metux IT consult" <info@metux.net> writes:

> From: Enrico Weigelt <info@metux.net>
>
> Explicitly return constants instead of variable (and rely on
> it to be explicitly initialized), if the value is supposed
> to be fixed anyways. Align it with the rest of the driver,
> which does it the same way.
>
> Signed-off-by: Enrico Weigelt <info@metux.net>
> ---
>  drivers/net/wireless/rsi/rsi_91x_sdio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

The prefix should be just "rsi:", I'll fix that.

-- 
Kalle Valo
