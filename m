Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C903B368945
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbhDVXP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:15:28 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:41062 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhDVXP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 19:15:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619133292; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=N7TteeMprNdBzrsfv1/f4K2TTEyfbtiJBOBuVFzXl04=;
 b=JFt7KSQAN6egrEzBnojwpQx5u2j+3jfnVoqAllBHAh3PfVE/Twm2kigCG8kus3+1P/ZRj0vS
 zLXd5ceqFDZb0As78h3byQ/+Vr6GXwZEBo8a8uCDQkqBWZsaRovuxxXaxVir4Ep1vemIhF1z
 8BJNjbG+LDJrdn8pb91jCANcuQ4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6082036b74f773a664c5ab3c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 23:14:51
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 71DB0C433F1; Thu, 22 Apr 2021 23:14:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 061D0C433F1;
        Thu, 22 Apr 2021 23:14:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 22 Apr 2021 17:14:49 -0600
From:   subashab@codeaurora.org
To:     Alex Elder <elder@ieee.org>
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/3] net: qualcomm: rmnet: Enable Mapv5
In-Reply-To: <ed00501e-d558-a47f-5444-b1a5a895d6db@ieee.org>
References: <1619121731-17782-1-git-send-email-sharathv@codeaurora.org>
 <ed00501e-d558-a47f-5444-b1a5a895d6db@ieee.org>
Message-ID: <8ada4250d370acfb995cfa68b72de091@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-22 14:14, Alex Elder wrote:
> On 4/22/21 3:02 PM, Sharath Chandra Vurukala wrote:
>> This series introduces the MAPv5 packet format.
>> 
>>    Patch 0 documents the MAPv4/v5.
>>    Patch 1 introduces the MAPv5 and the Inline checksum offload for 
>> RX/Ingress.
>>    Patch 2 introduces the MAPv5 and the Inline checksum offload for 
>> TX/Egress.
> 
> Was this supposed to be version 5?
> 
> I already reviewed version 4.
> 
> Please post version 5.  I am going to ignore this series.
> 
> 					-Alex
> 

What are you talking about?

Patchwork shows that Sharath has posted upto v3 so far.

https://patchwork.kernel.org/project/netdevbpf/list/?submitter=197703&state=%2A&archive=both
