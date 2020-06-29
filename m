Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9474820D0D5
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgF2Sg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:36:28 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:59599 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726974AbgF2Sg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:36:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1593455786; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=XYv2wjyZ4cUXa4PLkiPA2CT1EcbjbybXQayJN+4gDCQ=;
 b=UgQuBnIvRFgWm7H7jK542vz3/nPxa6eg2DpNcDP806gGdBattYppeNRmAMiDYFkTbetkrgVU
 PiQVv/8VThB3q+V0nRQ17cyy+jabXaRna+Qplot6EiOgG1A9zFIZy1TXRl7twA+Dq711HuQO
 IXGZsgwcDFhiqsz7QLB8BTs5MIA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n13.prod.us-west-2.postgun.com with SMTP id
 5ef9d56ff3deea03f319e92b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 29 Jun 2020 11:50:07
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 173B4C43395; Mon, 29 Jun 2020 11:50:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cjhuang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A66C2C433C6;
        Mon, 29 Jun 2020 11:50:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 29 Jun 2020 19:50:06 +0800
From:   cjhuang@codeaurora.org
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH] net: qrtr: free flow in __qrtr_node_release
In-Reply-To: <20200623.202629.352077396302165327.davem@davemloft.net>
References: <1592882523-12870-1-git-send-email-cjhuang@codeaurora.org>
 <20200623.202629.352077396302165327.davem@davemloft.net>
Message-ID: <f5754bde02e4026ace2ef4ca9fb8ae47@codeaurora.org>
X-Sender: cjhuang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-24 11:26, David Miller wrote:
> From: Carl Huang <cjhuang@codeaurora.org>
> Date: Tue, 23 Jun 2020 11:22:03 +0800
> 
>> @@ -168,6 +168,7 @@ static void __qrtr_node_release(struct kref *kref)
>>  	struct radix_tree_iter iter;
>>  	unsigned long flags;
>>  	void __rcu **slot;
>> +	struct qrtr_tx_flow *flow;
> 
> Please retain the reverse christmas tree ordering of local variables 
> here.

OK. Will send V2 for it.

> 
> Thanks.
