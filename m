Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF273D6F8A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 08:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbhG0Get (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 02:34:49 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:61227 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234226AbhG0Ges (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 02:34:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627367689; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=bvh0zvaZP6NDyHuSMjU3Ge7sFz/R6SOdS01NkH+cFQ4=; b=MemaEKhUNuJa1ztOfpSk7t0y7d6ZmBCsQiA9RbmFFDikGt8H3+wo8nSTKHe2/XKc6k0gybOS
 dtxiGspZyt+14at604YGFERnRiNwv2OeiggL3l+Kv7aes83O0DdBFdQz5w7SzfRiypJJJNQW
 akOQty+VWxa6LG0xNpI5V3UuouA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60ffa8fae31d882d18c8e0c5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 27 Jul 2021 06:34:34
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B8CA4C43143; Tue, 27 Jul 2021 06:34:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 81261C433D3;
        Tue, 27 Jul 2021 06:34:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 81261C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Len Baker <len.baker@gmx.com>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Brian Norris <briannorris@chromium.org>,
        Pkshih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtw88: Remove unnecessary check code
References: <20210718084202.5118-1-len.baker@gmx.com>
Date:   Tue, 27 Jul 2021 09:34:26 +0300
In-Reply-To: <20210718084202.5118-1-len.baker@gmx.com> (Len Baker's message of
        "Sun, 18 Jul 2021 10:42:02 +0200")
Message-ID: <87eebkgt8t.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Len Baker <len.baker@gmx.com> writes:

> The rtw_pci_init_rx_ring function is only ever called with a fixed
> constant or RTK_MAX_RX_DESC_NUM for the "len" argument. Since this
> constant is defined as 512, the "if (len > TRX_BD_IDX_MASK)" check
> can never happen (TRX_BD_IDX_MASK is defined as GENMASK(11, 0) or in
> other words as 4095).
>
> So, remove this check.
>
> Signed-off-by: Len Baker <len.baker@gmx.com>

Are everyone ok with this version?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
