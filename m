Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D9212F2BD
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 02:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgACBh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 20:37:28 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:62390 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbgACBh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 20:37:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578015447; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=BIkC8TGDTtb25luxTx2OTLtc+r/j75Se8xqph41KguU=;
 b=G6XZ9Ojs3LunjVOWzAJH+6prGyyHA6j69Xhw2TIqbZrhMmMOUXGEbb4OaRLHEsBU3JgHGGIN
 qFYESWpwwBB4D1gEp5a3kbK+G6z5xHY6UGOW5hzhIaYOwfL0549sZIAcgDUeNdxWyWVvlTjn
 cxvV65pQfnRVbYFeezQzRKIQuvw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e0e9ad7.7f61c7275ed8-smtp-out-n01;
 Fri, 03 Jan 2020 01:37:27 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1D9F7C433A2; Fri,  3 Jan 2020 01:37:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: wgong)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CBD83C433CB;
        Fri,  3 Jan 2020 01:37:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 03 Jan 2020 09:37:26 +0800
From:   Wen Gong <wgong@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH] net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
In-Reply-To: <20200102.162249.948673283541180133.davem@davemloft.net>
References: <20191231093242.6320-1-wgong@codeaurora.org>
 <20200102.162249.948673283541180133.davem@davemloft.net>
Message-ID: <297b94fe2eb5a20c75c2095e9640a495@codeaurora.org>
X-Sender: wgong@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-03 08:22, David Miller wrote:

> I don't think this is correct.
> 
> The 'hdr' was already "pushed" earlier in this file.
> 
> Here we are padding the area after the header, which is being "put".
> 
> I'm not applying this.  If you still think it is correct, you must 
> explain
> in detail why it is and add that description to the commit log message.
> 
> Thank you.

Thanks David.
I will add more description and send patch v2.
