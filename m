Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A55A512914
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 09:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfECHt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 03:49:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60034 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfECHt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 03:49:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7559861132; Fri,  3 May 2019 07:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556869766;
        bh=FR4AcNxKg1NOcAXJFdFeJqXyuj3S0d0qMINeLGaMFdo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MpJw0NrVx87e9I8YeA7QSfECP8iYm70cRic1YX8ilfwy8F5cFMtPnLr5Cb6E6II5B
         HAr/4ct+DJVw+kqpc8n/o1xlN0ZncQId2I/GUNZvuoiDdm1c0xmKoJViWVJnbLHAz8
         aCqnE1beFWVEcUe7+6MPkjvDFou6XMnewjEXlgPg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 50D376119F;
        Fri,  3 May 2019 07:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556869765;
        bh=FR4AcNxKg1NOcAXJFdFeJqXyuj3S0d0qMINeLGaMFdo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YSIjN9a8ZFcwL4dIOC7/OFAnwFzYWU6br3JI3RdqAiFz107iS+aADHj9FPSJXOicd
         57AlXNvNsfMJVTAPqeJB7uz1PQJwHHG5X0pwCez+ejWGRfpU9CCKu76MqAudzOos/6
         CH9dr9o4FSdDWrwPL8/sHu3OKYIB1JfFP6M6EUqA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 50D376119F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     jes.sorensen@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: Re: [RFC PATCH 1/2] rtl8xxxu: Add rate adaptive related data
References: <20190503072146.49999-1-chiu@endlessm.com>
        <20190503072146.49999-2-chiu@endlessm.com>
Date:   Fri, 03 May 2019 10:49:22 +0300
In-Reply-To: <20190503072146.49999-2-chiu@endlessm.com> (Chris Chiu's message
        of "Fri, 3 May 2019 15:21:45 +0800")
Message-ID: <874l6ckmf1.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> writes:

> Add wireless mode, signal strength level, and rate table index
> to tell the firmware that we need to adjust the tx rate bitmap
> accordingly.

Please read Developer's Certificate of Origin and add Signed-off-by to
the commit logs:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#signed-off-by_missing

-- 
Kalle Valo
