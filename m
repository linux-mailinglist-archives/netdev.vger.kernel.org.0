Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7F5439119
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhJYI0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:26:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:34534 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhJYI03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 04:26:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635150247; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=a7lPy/Ge5ljGmtAC7FnQTdV9CVFWdMFCh42zxhHl1rw=; b=s238OhLM3pOg1xnVql9widI+IZwdkmSCrrUVlc0XZAOBF4ozXzU8Xl+uxreOFJiwpS35qaCy
 r6R4n1FdVNxAirKlyH+HjGAZ/IHYluYq+qZKCpHPFEwITXOF+CLPxxdfnplntu6Cq52nHBhA
 0NZq4i3segFZ5RsnPEMaV3qKLV4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 617669998e67b5f04e00a32e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Oct 2021 08:23:53
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6237FC43617; Mon, 25 Oct 2021 08:23:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7895FC4338F;
        Mon, 25 Oct 2021 08:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 7895FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Benjamin Li <benl@squareup.com>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wcn36xx: Switch on Antenna diversity feature bit
References: <20211022235738.2970167-1-benl@squareup.com>
        <20211022235738.2970167-2-benl@squareup.com>
Date:   Mon, 25 Oct 2021 11:23:43 +0300
In-Reply-To: <20211022235738.2970167-2-benl@squareup.com> (Benjamin Li's
        message of "Fri, 22 Oct 2021 16:57:37 -0700")
Message-ID: <87h7d5ecmo.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Li <benl@squareup.com> writes:

> From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>
> Switches on Antenna diversity feature bit.

The commit log should answer to the question "why?":

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_log_does_not_answer_why

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
