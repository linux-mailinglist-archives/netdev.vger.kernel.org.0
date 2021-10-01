Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E18B41EC66
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354101AbhJALkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:40:32 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:57663 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354096AbhJALkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:40:31 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 11F48200E1E7;
        Fri,  1 Oct 2021 13:38:45 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 11F48200E1E7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633088325;
        bh=SWed+HLpwvmxNRkQ1IwGGvfLbyfQc6MYWr5mCAnWMwo=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=s+IHiq/KJIZSAkp/K+1D2HhawRVeqhz+r4b1U0msu4KyZ0X+ds0q0MA/focQZlaI9
         fbpohKIbVv31Lmil7bu3loaEjzAnSkAd1yshORsG+g/Gslf8X29M2h1twv3E+sh88N
         BwXEEcouTq+XykllCSV2nZPiKnH5f5Ud3odDWswb4VMfxe5dB24pgtGFbjLzh6eyJ9
         NPPnrMFLJle3sQrFG4IGB78CZo25gHJms77MBa8naumqYi3bSOEtlKR7tVSJ5ukKnZ
         zRXNktetkCtgvdSu/uIKF1TZ5m8fgRJAaz3Xr3gw2j33fKVv8xK+dBY6di+Kc7vkCa
         zutOhEobJyNWw==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 07C6E60225260;
        Fri,  1 Oct 2021 13:38:45 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ieLnZJG9ZFv7; Fri,  1 Oct 2021 13:38:44 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id E4FFD6008D70D;
        Fri,  1 Oct 2021 13:38:44 +0200 (CEST)
Date:   Fri, 1 Oct 2021 13:38:44 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Message-ID: <625451834.109328801.1633088324880.JavaMail.zimbra@uliege.be>
In-Reply-To: <0ce98a52-e9fe-9b5c-68ca-f81c88e021ab@gmail.com>
References: <20210928190328.24097-1-justin.iurman@uliege.be> <20210928190328.24097-2-justin.iurman@uliege.be> <16630ce5-4c61-a16b-8125-8ec697d6c33e@gmail.com> <2092322692.108322349.1633015157710.JavaMail.zimbra@uliege.be> <0ce98a52-e9fe-9b5c-68ca-f81c88e021ab@gmail.com>
Subject: Re: [PATCH net-next 1/2] ipv6: ioam: Add support for the ip6ip6
 encapsulation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [139.165.223.37]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF92 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Add support for the ip6ip6 encapsulation
Thread-Index: /W2LFMfLKOhWM9rl0KYG9+xfke+lQg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>>>  static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
>>>> -	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_trace_hdr)),
>>>> +	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct
>>>> ioam6_iptunnel_trace)),
>>>
>>> you can't do that. Once a kernel is released with a given UAPI, it can
>>> not be changed. You could go the other way and handle
>>>
>>> struct ioam6_iptunnel_trace {
>>> +	struct ioam6_trace_hdr trace;
>>> +	__u8 mode;
>>> +	struct in6_addr tundst;	/* unused for inline mode */
>>> +};
>> 
>> Makes sense. But I'm not sure what you mean by "go the other way". Should I
>> handle ioam6_iptunnel_trace as well, in addition to ioam6_trace_hdr, so that
>> the uapi is backward compatible?
> 
> by "the other way" I meant let ioam6_trace_hdr be the top element in the
> new ioam6_iptunnel_trace struct. If the IOAM6_IPTUNNEL_TRACE size ==
> ioam6_trace_hdr then you know it is the legacy argument vs sizeof
> ioam6_iptunnel_trace which is the new.

OK, I see. The problem is ioam6_trace_hdr must be the last entry because of its last field, which is "__u8 data[0]". But, anyway, I could still apply the same kind of logic with the size.

>>> Also, no gaps in uapi. Make sure all holes are stated; an anonymous
>>> entry is best.
>> 
>> Would something like this do the trick?
>> 
>> struct ioam6_iptunnel_trace {
>> 	struct ioam6_trace_hdr trace;
>> 	__u8 mode;
>> 	union { /* anonymous field only used by both the encap and auto modes */
>> 		struct in6_addr tundst;
>> 	};
>> };
> 
> By anonymous filling of the holes I meant something like:
> 
> struct ioam6_iptunnel_trace {
>	struct ioam6_trace_hdr trace;
>	__u8 mode;
>	__u8 :8;
>	__u16 :16;
> 
>	struct in6_addr tundst;
> };
> 
> Use pahole to check that struct for proper alignment of the entries as
> desired (4-byte or 8-byte aligned).

By reading your example, I'm not sure we're talking about the same thing. Actually, do you refer to the fact that the ioam6_trace_hdr field must be 8n-aligned? If so, I don't see any static way to do that (i.e., by adding anonymous fields as you did) since it depends on the size of the data field I mentioned above.  The size can either be 8n-aligned already, or 4n-aligned in which case we add a PadN (1 2 0 0) at the end of the data field.
