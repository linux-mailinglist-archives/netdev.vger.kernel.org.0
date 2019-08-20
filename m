Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD3795AB3
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbfHTJLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:11:05 -0400
Received: from first.geanix.com ([116.203.34.67]:33080 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729194AbfHTJLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 05:11:05 -0400
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 4CD5826D;
        Tue, 20 Aug 2019 09:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1566292259; bh=dmvxfghRb+CluZgXEcNklhxE/ZtMdJJHUrKJYR+0P3A=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Sq6ZPs1MPczAYn78teDURij3Vgq2btC93C3H942O4VmblwtDZKXPGr4LQyN1vbNtp
         W0XV0QhdKXeuwcBOkY+cZsBC0qC49hhQKp4IDwvSWeI2vbnNbLvUKqp4nuNOuH4S4w
         IkRjpTref7oDKrHRsWCBktWnQ1zzpO08bzG/sDItHfrwmXAhphffN0nzxjlnHxOfpJ
         NZz3l+sAxJkbJH8Vj5O3S9LF7xxe8hbsVfAhA0goKPQp/ejLQnnK6Tgf/GbYMTTyut
         19TjBDF+vXzF00nLT8xZihI7SVC4Wh44uuK/vDxlFSr3wUwfC+32C9nMjKzplAc4pp
         C0Cw/h7UnxzUA==
Subject: Re: [PATCH 2/2] dt-bindings: can: flexcan: add can wakeup property
To:     linux-can@vger.kernel.org, mkl@pengutronix.de
Cc:     Rob Herring <robh@kernel.org>, netdev@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
References: <20190409083949.27917-1-sean@geanix.com>
 <20190409083949.27917-2-sean@geanix.com> <20190429173930.GA11283@bogus>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <9e152f0d-fd1c-cb6f-2d9a-730804f8ec41@geanix.com>
Date:   Tue, 20 Aug 2019 11:10:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190429173930.GA11283@bogus>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 77834cc0481d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/04/2019 19.39, Rob Herring wrote:
> On Tue,  9 Apr 2019 10:39:49 +0200, Sean Nyekjaer wrote:
>> add wakeup-source boolean property.
>>
>> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
>> ---
>>   Documentation/devicetree/bindings/net/can/fsl-flexcan.txt | 2 ++
>>   1 file changed, 2 insertions(+)
>>
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
>
This doesn't seem to be applied. PATCH 1/2 in this series is applied.

In any case which repo does this patch belong to?

/Sean
