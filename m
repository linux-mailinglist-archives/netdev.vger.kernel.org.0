Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB792886C4
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbgJIKWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:22:13 -0400
Received: from fallback22.m.smailru.net ([94.100.176.132]:41790 "EHLO
        fallback22.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJIKWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 06:22:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:Subject; bh=YcSQ4rsmBfLfJBWniWKYCsnWwlWlYuVtOo+n0oO/a2k=;
        b=uS0fb6leUOaOyga1vKeGodM4P01km07R/kbT17bSYZtk6Ij2Q3GNDs7W0rUBdp0jrVJN674q0qsuipsreg0qcwJ2Fo+Da+Cm56NyRJHsev7oGyl8N25GJGWT4Cy1r4XdO70z7AvHBLLUkNZMw9eJZYpUaXPAjkX3dCp7Bp7+pK8=;
Received: from [10.161.64.57] (port=41328 helo=smtp49.i.mail.ru)
        by fallback22.m.smailru.net with esmtp (envelope-from <abt-admin@mail.ru>)
        id 1kQpXM-0004FB-QH; Fri, 09 Oct 2020 13:22:09 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail3;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:Subject:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=YcSQ4rsmBfLfJBWniWKYCsnWwlWlYuVtOo+n0oO/a2k=;
        b=qd4Fb0UgTwXdpNg7JOObYlViQTotQmFZkzKKLCUXBSs7Qgx9J13LyY2c2zGJNvRc7SRVW0bf6WSMF49h2HLjPZPFj0/7kLL844rF2tmL4QUlv+/O881oeRfNWM++AcTYMzDTQz9VxLnemvXIpHtkcFFWOqmb78ECid3dHEqv1hc=;
Received: by smtp49.i.mail.ru with esmtpa (envelope-from <abt-admin@mail.ru>)
        id 1kQpXK-0002e3-MR; Fri, 09 Oct 2020 13:22:07 +0300
Subject: Re: Fw: [Bug 209427] New: Incorrect timestamp cause packet to be
 dropped
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>
References: <20200929103532.0ecbc3b3@hermes.local>
 <8e1a8be5-4123-ea86-80f2-16027cfa021c@gmail.com>
 <alpine.LFD.2.23.451.2009302010190.4321@ja.home.ssi.bg>
From:   Evgeny B <abt-admin@mail.ru>
Message-ID: <cbacae19-8a84-b7a9-8e92-1ca6b22b8b65@mail.ru>
Date:   Fri, 9 Oct 2020 13:22:03 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.23.451.2009302010190.4321@ja.home.ssi.bg>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9E98D7292067252302C0E76C52979D672675FED68DAFAF9FC182A05F538085040B1353DCE880ADEF9C3C0663F9D064B92A2D0DDB3017CBC5D2DED7A9D51D4EAA7
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE741C7AE487E378FE7EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637A0C281720337EDEA8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FC2A3BA7DEE59E60A7A00F360CEAE07222728236DEAE86F2AF389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C015BBC38BE64FE4678941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C3E478A468B35FE767117882F4460429728AD0CFFFB425014EFE57002F862A6B6676E601842F6C81A19E625A9149C048EE4B6963042765DA4B043FB282AF95FB6BD8FC6C240DEA76429449624AB7ADAF37B2D370F7B14D4BC40A6AB1C7CE11FEE368E4D7E803FA7AD56136E347CC761E07C4224003CC8364767A15B7713DBEF166A7F4EDE966BC389F9E8FC8737B5C2249A19B99133A7DFEF1089D37D7C0E48F6CCF19DD082D7633A0E7DDDDC251EA7DABAAAE862A0553A39223F8577A6DFFEA7C1E0780EE7D76B22F43847C11F186F3C5E7DDDDC251EA7DABCC89B49CDF41148F53FDB0A1CE3EC88B3B503F486389A921A5CC5B56E945C8DA
X-C8649E89: C9F3308B376ADA62007398E4665261F3F82E61ED4C5020DADD3A7F250DC433D00D985D1D7D6130E1
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojZW/7Ea6+LmFP66aIomxEVA==
X-Mailru-Sender: 6CA451E36783D72110B49B6400E2460DF69968408DA9838227B1E1C4B0FF5409281C8A37A933478C413F1E1E6E684AF678274A4A9E9E44FD6F84805CEB291A2816580BC561049AF767EA787935ED9F1B
X-Mras: Ok
X-7564579A: 646B95376F6C166E
X-77F55803: 6242723A09DB00B4033B2E76A2A2E7F3D7C40938B5608F3039AD8672D1456623049FFFDB7839CE9E0091B5866B8777F80339FBF5C0F9CCDAFF56373C44000E25400C2A9CF0F0AA1A
X-7FA49CB5: 0D63561A33F958A50FE13C2791D718076F569FEE3F07EDC81F96E23A033C91878941B15DA834481FA18204E546F3947C4B6F6234D9065C97F6B57BC7E64490618DEB871D839B7333395957E7521B51C2545D4CF71C94A83E9FA2833FD35BB23D27C277FBC8AE2E8BAA867293B0326636D2E47CDBA5A96583D99E6B68E862FF7A9735652A29929C6C4AD6D5ED66289B5278DA827A17800CE7A8D7235C252B30C7D32BA5DBAC0009BE395957E7521B51C20B4866841D68ED3567F23339F89546C55F5C1EE8F4F765FCB46939A4ECED1D9D75ECD9A6C639B01BBD4B6F7A4D31EC0BC0CAF46E325F83A522CA9DD8327EE493B89ED3C7A628178133F64B4C514AF25EC4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F2AF38021CC9F462D574AF45C6390F7469DAA53EE0834AAEE
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojZW/7Ea6+LmGxtNJilOvtyQ==
X-Mailru-MI: 800
X-Mailru-Sender: A5480F10D64C9005989B929F85CCF0954350F4CECF5A06B70DD0A3C66087E3B68C2DD0A86F9CB7FA7935DC82BA25C6A53DDE9B364B0DF2896BB46F87D5A2245C28CBA8FA03A0F3E1AE208404248635DF
X-Mras: Ok
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just realized all my messages were bounced by mail server, this is 
last try


This fix works, however they should be applied for each of ipvs_xmit 
functions (e.g. ip_vs_nat_xmit(), ip_vs_dr_xmit(), etc.)

I look forward to seeing the patch in ml-5.x

Thank you!


On 9/30/2020 8:17 PM, Julian Anastasov wrote:
> 	Hello,
>
> On Wed, 30 Sep 2020, Eric Dumazet wrote:
>
>> On 9/29/20 7:35 PM, Stephen Hemminger wrote:
>>>
>>> then I noticed that in some cases skb->tstamp is equal to real ts whereas in
>>> the regular cases where a packet pass through it's time since kernel boot. This
>>> doesn't make any sense for me as this condition is satisfied constantly
>>>
>>> net/sched/sch_fq.c:439
>>> static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
>>>                                      const struct fq_sched_data *q)
>>> {
>>>          return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
>>> }
>>>
>>> Any ideas on what it can be?
>>>
>> Thanks for the detailed report !
>>
>> I suspect ipvs or bridge code needs something similar to the fixes done in
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=de20900fbe1c4fd36de25a7a5a43223254ecf0d0
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=41d1c8839e5f8cb781cc635f12791decee8271b7
>>
>> The reason for that is that skb->tstamp can get a timestamp in input path,
>> with a base which is not CLOCK_MONOTONIC, unfortunately.
>>
>> Whenever a packet is forwarded, its tstamp must be cleared.
>>
>> Can you try :
>>
>> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
>> index b00866d777fe0e9ed8018087ebc664c56f29b5c9..11e8ccdae358a89067046efa62ed40308b9e06f9 100644
>> --- a/net/netfilter/ipvs/ip_vs_xmit.c
>> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
>> @@ -952,6 +952,8 @@ ip_vs_prepare_tunneled_skb(struct sk_buff *skb, int skb_af,
>>   
>>          ip_vs_drop_early_demux_sk(skb);
>>   
>> +       skb->tstamp = 0;
>> +
> 	Should be after all skb_forward_csum() calls in ip_vs_xmit.c
>
>>          if (skb_headroom(skb) < max_headroom || skb_cloned(skb)) {
>>                  new_skb = skb_realloc_headroom(skb, max_headroom);
>>                  if (!new_skb)
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>
