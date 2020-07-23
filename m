Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918FC22A913
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgGWGoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:44:06 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:39081 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgGWGoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 02:44:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595486645; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=LYhJ3xqh2dtQszfT4fJ62buWqo7qkmtaNI13Ao98RiA=; b=VWTq4CTjTwt8hdGWNB71rjbRg9XFKknrmUuWJtIEOXq0kWDgYGlhrj22QgL6YcLOqJDFLztH
 nKHxSYkf2DPZJoKyMv7tSJmMZizuvQvsOc5UwgaggdAVL5YCN5HH3sisUtE2b7IJVBOKU+f4
 kkjiMX/uIDTeS2wdQUDIRFgsQkc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f1931b3e3bee12510a3db0e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 23 Jul 2020 06:44:03
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 10A7DC43395; Thu, 23 Jul 2020 06:44:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A009C433C9;
        Thu, 23 Jul 2020 06:44:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6A009C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] wil6210: Avoid the use of one-element array
References: <20200715215755.GA21716@embeddedor>
        <80fe7b75-a324-9af1-38a9-ee259b886d7e@embeddedor.com>
Date:   Thu, 23 Jul 2020 09:43:58 +0300
In-Reply-To: <80fe7b75-a324-9af1-38a9-ee259b886d7e@embeddedor.com> (Gustavo A.
        R. Silva's message of "Wed, 22 Jul 2020 13:27:40 -0500")
Message-ID: <87r1t2689d.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> Friendly ping: who can take this? :)

I'll take this if it's ok. I have been just busy due to vacation period.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
