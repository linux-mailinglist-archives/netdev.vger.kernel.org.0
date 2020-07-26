Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD4622E1E8
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 20:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgGZSLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 14:11:39 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22921 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgGZSLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 14:11:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595787098; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=dkeTWaUqQPIijBo2b2trYUH4UirL83EHI+atIYwWFzE=; b=eSn0mChU2LjbKtmg4Pj7qLsUKsoHgZ3eRIzVSaHi+++HjQ5WTws+Wd1gpuyDB6zUO6RWlSzc
 rH2dukq2wDC208IM7N2xoRbjqJmOBtccTSihKfdPVtFvX/VJgcncm8r/IHCBzS4MySFoE4LD
 zl+YIoylwn4+iyB62T/Q/UZn77c=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n11.prod.us-west-2.postgun.com with SMTP id
 5f1dc75235f3e3d3168ebf01 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 26 Jul 2020 18:11:30
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C6F6FC43391; Sun, 26 Jul 2020 18:11:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 09F83C433C9;
        Sun, 26 Jul 2020 18:11:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 09F83C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] iwlwifi: yoyo: don't print failure if debug firmware is missing
References: <20200625165210.14904-1-wsa@kernel.org>
        <20200726152642.GA913@ninjato>
Date:   Sun, 26 Jul 2020 21:11:25 +0300
In-Reply-To: <20200726152642.GA913@ninjato> (Wolfram Sang's message of "Sun,
        26 Jul 2020 17:26:42 +0200")
Message-ID: <87y2n6404y.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wolfram Sang <wsa@kernel.org> writes:

> On Thu, Jun 25, 2020 at 06:52:10PM +0200, Wolfram Sang wrote:
>> Missing this firmware is not fatal, my wifi card still works. Even more,
>> I couldn't find any documentation what it is or where to get it. So, I
>> don't think the users should be notified if it is missing. If you browse
>> the net, you see the message is present is in quite some logs. Better
>> remove it.
>> 
>> Signed-off-by: Wolfram Sang <wsa@kernel.org>
>> ---
>
> Any input on this? Or people I should add to CC?

This was discussed on another thread:

https://lkml.kernel.org/r/87mu3magfp.fsf@tynnyri.adurom.net

Unless Intel folks object I'm planning to take this to
wireless-drivers-next.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
