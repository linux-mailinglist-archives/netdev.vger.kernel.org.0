Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B5A3959D4
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 13:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhEaLpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 07:45:20 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:37916 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbhEaLpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 07:45:19 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id C4353200BBB4;
        Mon, 31 May 2021 13:43:37 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be C4353200BBB4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622461417;
        bh=IPjoCvNMWdhahyBQSI8nvl29LqQAcN4kdhU4xW9QAio=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=sRiSml6MJwJskSpTVyG3cDYPAWbnlTJU3A/nbfpdPDuGb4BDr06xSeDtRQK21kc23
         zOX3HzZ4nDsmu8OAtJ4Bzv1RVr3/YR0WTaTCOlODuAkFk9dKkchRzmDWhjaZQf3NQ5
         w96o1HmSePooVSvASWKAI5UmRmMV+x7mneJJcNsmDGUTo9ZqhQ8+YdkL+30ElbUTzV
         o0Md3fOcQ4vgVwzrLJXxrygKr0UI4dM9L+H3mkFlUJHc/ECHwidh8LEBqGK1Qzo0zm
         +J6GSEZOTJQHldTd9favfnjx9Q4gNhHDdBjfkeJrK/sFBqGfwFTqRsXhbrgXFSxzYx
         ka/N4qQSh8iQA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id BA65F6008D58C;
        Mon, 31 May 2021 13:43:37 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GRGqg3w9gVNA; Mon, 31 May 2021 13:43:37 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id A44166008D40D;
        Mon, 31 May 2021 13:43:37 +0200 (CEST)
Date:   Mon, 31 May 2021 13:43:37 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Message-ID: <915310398.35293280.1622461417600.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210530130212.327a0a0c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20210527151652.16074-1-justin.iurman@uliege.be> <20210527151652.16074-3-justin.iurman@uliege.be> <20210529140555.3536909f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <1678535209.34108899.1622370998279.JavaMail.zimbra@uliege.be> <20210530130212.327a0a0c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Subject: Re: [PATCH net-next v4 2/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Data plane support for Pre-allocated Trace
Thread-Index: LL2E99po/E/GdNNmlz8xoGO/YCJOsg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >> A per-interface sysctl ioam6_enabled is provided to process/ignore IOAM
>> >> headers. Default is ignore (= disabled). Another per-interface sysctl
>> >> ioam6_id is provided to define the IOAM (unique) identifier of the
>> >> interface. Default is 0. A per-namespace sysctl ioam6_id is provided to
>> >> define the IOAM (unique) identifier of the node. Default is 0.
>> > 
>> > Last two sentences are repeated.
>> 
>> One describes net.ipv6.conf.XXX.ioam6_id (per interface) and the
>> other describes net.ipv6.ioam6_id (per namespace). It allows for
>> defining an IOAM id to an interface and, also, the node in general.
> 
> I see it now, please rephrase.

Will do.

> 
>> >> @@ -929,6 +932,50 @@ static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
>> >>  	return false;
>> >>  }
>> >>  
>> >> +/* IOAM */
>> >> +
>> >> +static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
>> >> +{
>> >> +	struct ioam6_trace_hdr *trace;
>> >> +	struct ioam6_namespace *ns;
>> >> +	struct ioam6_hdr *hdr;
>> >> +
>> >> +	/* Must be 4n-aligned */
>> >> +	if (optoff & 3)
>> >> +		goto drop;
>> >> +
>> >> +	/* Ignore if IOAM is not enabled on ingress */
>> >> +	if (!__in6_dev_get(skb->dev)->cnf.ioam6_enabled)
>> >> +		goto ignore;
>> >> +
>> >> +	hdr = (struct ioam6_hdr *)(skb_network_header(skb) + optoff);
>> >> +
>> >> +	switch (hdr->type) {
>> >> +	case IOAM6_TYPE_PREALLOC:
>> >> +		trace = (struct ioam6_trace_hdr *)((u8 *)hdr + sizeof(*hdr));
>> >> +		ns = ioam6_namespace(ipv6_skb_net(skb), trace->namespace_id);
>> > 
>> > Shouldn't there be validation that the header is not truncated or
>> > malformed before we start poking into the fields?
>> 
>> ioam6_fill_trace_data is responsible (right after that) for checking
>> the header and making sure the whole thing makes sense before
>> inserting data. But, first, we need to parse the IOAM-Namespace ID to
>> check if it is a known (defined) one or not, and therefore either
>> going deeper or ignoring the option. Anyway, maybe I could add a
>> check on hdr->opt_len and make sure it has at least the length of the
>> required header (what comes after is data).
> 
> Right, don't we also need to check hdr->opt_len vs trace->remlen?

Indeed, I'll add a check for both.

> 
> BTW the ASCII art in patch 1 looks like node data is filled in in order

I agree, this one could be quite confusing without the related paragraph in the draft that explains it. Two possibilities here: (a) add the paragraph in the patch description to remove ambiguity; or (b) revert indexes in the ASCII art (from n to 0). Thoughts?

> but:
> 
> +	data = trace->data + trace->remlen * 4 - trace->nodelen * 4 - sclen * 4;
> 
> Looks like we'd start from the last node data?

Correct, it works as a stack from bottom (end of the pre-allocated space) to top (start of the pre-allocated space).
