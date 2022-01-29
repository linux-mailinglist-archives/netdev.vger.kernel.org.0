Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD274A2E2F
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 12:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiA2LYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 06:24:51 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:38911 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiA2LYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 06:24:50 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 053AD200CD1B;
        Sat, 29 Jan 2022 12:24:48 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 053AD200CD1B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1643455488;
        bh=TvAxuc2eIVoVVcwzVbit/It7yxWS17cqjcXERjw9KxM=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=Np6+nQ4gbGKA51Gyk0xP5Mx1wcFWzU5pHtLdxrGGxS68whYrwdSfrKSv4NJifiojC
         ty7Jl5F3W69F5RXxmjl7LCYi7qhE/5e751LADWd0qD98qW42zn0xtnWkUpD02cmnnc
         zuOoRqbq/t3Y1wQN2Lo8463bYA3rFI39ck8Py0uA5qlGiSl8csekUH0QB5f9oAfbcW
         Ai9GLMNiOtR3+kgT3z38InBTzWTkHrDK2z8hPGsQZuXM2bFWlKJTmgs3ofz9FjwGHt
         4B4opVOOythBbXMv49i+kz06V6h1e1bmhSuCG5gumQ1zRJ87GrLomnem5woyyXgKhH
         kLhYWVjIHYMvQ==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id EEC786010ECE0;
        Sat, 29 Jan 2022 12:24:47 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MCyoVUhtj-8Z; Sat, 29 Jan 2022 12:24:47 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id D8CA06007DF30;
        Sat, 29 Jan 2022 12:24:47 +0100 (CET)
Date:   Sat, 29 Jan 2022 12:24:47 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Message-ID: <31581393.9071156.1643455487833.JavaMail.zimbra@uliege.be>
In-Reply-To: <20220128173121.7bb0f8b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220126184628.26013-1-justin.iurman@uliege.be> <20220126184628.26013-2-justin.iurman@uliege.be> <20220128173121.7bb0f8b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH net-next 1/2] uapi: ioam: Insertion frequency
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF96 (Linux)/8.8.15_GA_4026)
Thread-Topic: uapi: ioam: Insertion frequency
Thread-Index: /KQAm3mtUXGCfUqzavbopger1m5EcA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 29, 2022, at 2:31 AM, Jakub Kicinski kuba@kernel.org wrote:
> On Wed, 26 Jan 2022 19:46:27 +0100 Justin Iurman wrote:
>> Add the insertion frequency uapi for IOAM lwtunnels.
>> 
>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
>> ---
>>  include/uapi/linux/ioam6_iptunnel.h | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>> 
>> diff --git a/include/uapi/linux/ioam6_iptunnel.h
>> b/include/uapi/linux/ioam6_iptunnel.h
>> index 829ffdfcacca..462758cdba14 100644
>> --- a/include/uapi/linux/ioam6_iptunnel.h
>> +++ b/include/uapi/linux/ioam6_iptunnel.h
>> @@ -30,6 +30,15 @@ enum {
>>  enum {
>>  	IOAM6_IPTUNNEL_UNSPEC,
>>  
>> +	/* Insertion frequency:
>> +	 * "k over n" packets (0 < k <= n)
>> +	 * [0.0001% ... 100%]
>> +	 */
>> +#define IOAM6_IPTUNNEL_FREQ_MIN 1
>> +#define IOAM6_IPTUNNEL_FREQ_MAX 1000000
> 
> If min is 1 why not make the value unsigned?

The atomic_t type is just a wrapper for a signed int, so I didn't want
to have to convert from signed to unsigned. I agree it'd sound better to
have unsigned here, though.

>> +	IOAM6_IPTUNNEL_FREQ_K,		/* s32 */
>> +	IOAM6_IPTUNNEL_FREQ_N,		/* s32 */
> 
> You can't insert into the middle of a uAPI enum. Binary compatibility.

Is it really the middle? I recall adding the "mode" at the top (still
below the "_UNSPEC"), which I thought was correct at that time (and had
no objection). That's why I did the same here. Should I move it to the
end, then?

>>  	/* Encap mode */
>>  	IOAM6_IPTUNNEL_MODE,		/* u8 */
