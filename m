Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AE847FDBF
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 15:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhL0OGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 09:06:45 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:55287 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237016AbhL0OGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 09:06:44 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 7721D202A099;
        Mon, 27 Dec 2021 15:06:42 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 7721D202A099
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1640614002;
        bh=yAH4rcsrFmP3VdV5raZyRcOdJnOE/9Nar4aaT8EA57o=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=wFLt8odRisTEnySyrIzWGLWZtvEZDQRFfAVPALY7ntSoo36Nm9FU5esj2gzu7amT1
         VN8gPHiLzpEtNeGnzYdHhTWVfqoxh+IjwwACiDpzvfMqsrKH9Glu7n1Bwwjpw7v1FX
         XbfT/zYaZqTs4XTp/lWZHYs7im5biGRlKhmXY31jyWUCuJh2O69TzETqCyMr2yW+Gm
         BHB5beEF2H2dRpvPF3Iv3uvs18sp/k+p/us9CJ0YLiLSalwZywYhvAUcum7DOskLSt
         /zkw+dXerRQ1litqyuwi+JBG3enduUHwPjhIyfMN6Rs8i1yoEvBNbXmKjFJ0sW6Zdh
         BtzIig6d31ljw==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 6D35F60606A5B;
        Mon, 27 Dec 2021 15:06:42 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hZU-VbNCOFcl; Mon, 27 Dec 2021 15:06:42 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 5495560309F42;
        Mon, 27 Dec 2021 15:06:42 +0100 (CET)
Date:   Mon, 27 Dec 2021 15:06:42 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org
Message-ID: <751671897.247201108.1640614002305.JavaMail.zimbra@uliege.be>
In-Reply-To: <Ychq4ggTdpVG24Zp@shredder>
References: <20211224135000.9291-1-justin.iurman@uliege.be> <YcYJD2trOaoc5y7Z@shredder> <331558573.246297129.1640519271432.JavaMail.zimbra@uliege.be> <Ychiyd0AgeLspEvP@shredder> <462116834.246327590.1640523548154.JavaMail.zimbra@uliege.be> <Ychq4ggTdpVG24Zp@shredder>
Subject: Re: [PATCH net-next v2] ipv6: ioam: Support for Queue depth data
 field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF95 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Queue depth data field
Thread-Index: wTVy0jFpVgbQC/mhmb/yW883zAIEDg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dec 26, 2021, at 2:15 PM, Ido Schimmel idosch@idosch.org wrote:
> On Sun, Dec 26, 2021 at 01:59:08PM +0100, Justin Iurman wrote:
>> On Dec 26, 2021, at 1:40 PM, Ido Schimmel idosch@idosch.org wrote:
>> > On Sun, Dec 26, 2021 at 12:47:51PM +0100, Justin Iurman wrote:
>> >> On Dec 24, 2021, at 6:53 PM, Ido Schimmel idosch@idosch.org wrote:
>> >> > Why 'qlen' is used and not 'backlog'? From the paragraph you quoted it
>> >> > seems that queue depth needs to take into account the size of the
>> >> > enqueued packets, not only their number.
>> >> 
>> >> The quoted paragraph contains the following sentence:
>> >> 
>> >>    "The queue depth is expressed as the current amount of memory
>> >>     buffers used by the queue"
>> >> 
>> >> So my understanding is that we need their number, not their size.
>> > 
>> > It also says "a packet could consume one or more memory buffers,
>> > depending on its size". If, for example, you define tc-red limit as 1M,
>> > then it makes a lot of difference if the 1,000 packets you have in the
>> > queue are 9,000 bytes in size or 64 bytes.
>> 
>> Agree. We probably could use 'backlog' instead, regarding this
>> statement:
>> 
>>   "It should be noted that the semantics of some of the node data fields
>>    that are defined below, such as the queue depth and buffer occupancy,
>>    are implementation specific.  This approach is intended to allow IOAM
>>    nodes with various different architectures."
>> 
>> It would indeed make more sense, based on your example. However, the
>> limit (32 bits) could be reached faster using 'backlog' rather than
>> 'qlen'. But I guess this tradeoff is the price to pay to be as close
>> as possible to the spec.
> 
> At least in Linux 'backlog' is 32 bits so we are OK :)
> We don't have such big buffers in hardware and I'm not sure what
> insights an operator will get from a queue depth larger than 4GB...

Indeed :-)

> I just got an OOO auto-reply from my colleague so I'm not sure I will be
> able to share his input before next week. Anyway, reporting 'backlog'
> makes sense to me, FWIW.

Right. I read that Linus is planning to release a -rc8 so I think I can
wait another week before posting -v3.
