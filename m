Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C2AAB317
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403977AbfIFHRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:17:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46650 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388342AbfIFHRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 03:17:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DB78D60850; Fri,  6 Sep 2019 07:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567754231;
        bh=+SsJ26Vq1jMBdCexWKLadMh+XLJUUN3QS+Dutxsq8UE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nZ2Dzch0GIA9bM15XwqNwlmpuuQoAt0Gpq32S0SbBnKr/313eWaSDdQ2lUGf2h6M1
         Wfb+kSOYGmHDPDud3hxbV0wGPUKdPn3wsqeULr5UNg7MmfodenPZYswtyuvOUCU6fD
         iUz1H4cmERfpPoQABt9l4aQborqsppmFL907FdzI=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (37-130-177-42.bb.dnainternet.fi [37.130.177.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 951DA60159;
        Fri,  6 Sep 2019 07:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567754231;
        bh=+SsJ26Vq1jMBdCexWKLadMh+XLJUUN3QS+Dutxsq8UE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nZ2Dzch0GIA9bM15XwqNwlmpuuQoAt0Gpq32S0SbBnKr/313eWaSDdQ2lUGf2h6M1
         Wfb+kSOYGmHDPDud3hxbV0wGPUKdPn3wsqeULr5UNg7MmfodenPZYswtyuvOUCU6fD
         iUz1H4cmERfpPoQABt9l4aQborqsppmFL907FdzI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 951DA60159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: [PATCH] rtl8xxxu: add bluetooth co-existence support for single antenna
References: <20190903053735.85957-1-chiu@endlessm.com>
        <CAB4CAwc5OBUWFThh__FedmG=fR-_1_GxUuiAb0J5yfU8c1aTfg@mail.gmail.com>
Date:   Fri, 06 Sep 2019 10:17:05 +0300
In-Reply-To: <CAB4CAwc5OBUWFThh__FedmG=fR-_1_GxUuiAb0J5yfU8c1aTfg@mail.gmail.com>
        (Chris Chiu's message of "Fri, 6 Sep 2019 10:44:10 +0800")
Message-ID: <874l1p28su.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> writes:

> Gentle ping. Cheers.

Please edit your quotes. Including the full patch in quotes makes my use
of patchwork horrible:

https://patchwork.kernel.org/patch/11127227/

-- 
Kalle Valo
