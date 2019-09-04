Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F7EA824C
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 14:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfIDMXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 08:23:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35615 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfIDMXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 08:23:10 -0400
Received: by mail-wm1-f68.google.com with SMTP id n10so3497632wmj.0
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 05:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mwTu9NnUddEvoIodAL9Zpm9sjc6JRhJd7PwPcmFJA7c=;
        b=YYTfmb53iUNPUb1NfDEZui5GXuzE6/ivQ3nUA7TJbfEYor+sv7HGKBN2hwYV4mKEcT
         yOfIeEbWXVsEfCZ3Tjknw2xDnWvIe1BQ8af+H+w/+TGtf/aWdoc/gBcgZdKJZcR7Clfs
         WxEdsSV+larQua+pv4uD1kMrRBf+LZOYOOSyKCLsxWCnmSsN3TvDiOVujptOtVp87PYE
         bHy5IXPXP9FYalDpMysIrzBAm0M/zaFjxurH5vT9oVUocvHWHOpe8w/GroDfjS7jHI9d
         twsrHmt4CnGve7SmoIUnzU6DCVEmZGkJJf2hMLRpDW987/VzHn31aKCxlui5doKyp+QH
         xrSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mwTu9NnUddEvoIodAL9Zpm9sjc6JRhJd7PwPcmFJA7c=;
        b=UsL4R/3vXbE6zGwaFDH48VSm6tbvrxFHPO0AAE74ZQTtXaY2nyhdsX+grDdxtM2qu4
         QqZIb3hh3TcpnIyIQ/Usgfo7v8SlkyuaVTuMmT6Yb11j/ruWeBFaslZFr1J4lpT8MvZd
         vDrExMLGDxjH9sB1nCMvKM4gRqdj1FcEVsRmyI4aFcGfFV1Jcby+/X1EEVAV+LMCuIlF
         KaBoGSNkm53iKVfy2xikzPBE8prdWAjrIoY5Y1Mxgd04sD1hDJeEAxUHxsMvKY4HcXOF
         MBSjTMBqxIallkHLAt/sK70Bdqj//VOoDrScNVgDCpel+arljpWc52AAwdEhhu31ySQn
         HnFA==
X-Gm-Message-State: APjAAAU0bxfjGUGRq0sHox4eCKmT87HE5E3R/+Dyyi5RxiRt3+adXuan
        Aem8bNRVi0ud7VWUTOKCzwY=
X-Google-Smtp-Source: APXvYqxVvPAEdpZMGNhpTh16Xblit04YElTQ9yYUaJ2BncOf67xgczWHYCcPT8LvUh42r3GejZGcAQ==
X-Received: by 2002:a1c:ef14:: with SMTP id n20mr4340774wmh.89.1567599787162;
        Wed, 04 Sep 2019 05:23:07 -0700 (PDT)
Received: from [192.168.8.147] (206.165.185.81.rev.sfr.net. [81.185.165.206])
        by smtp.gmail.com with ESMTPSA id n7sm16685705wrx.42.2019.09.04.05.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 05:23:06 -0700 (PDT)
Subject: Re: Is bug 200755 in anyone's queue??
To:     Mark KEATON <mark.keaton@raytheon.com>,
        Steve Zabele <zabele@comcast.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "shum@canndrew.org" <shum@canndrew.org>,
        "vladimir116@gmail.com" <vladimir116@gmail.com>,
        "saifi.khan@strikr.in" <saifi.khan@strikr.in>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "on2k16nm@gmail.com" <on2k16nm@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <010601d53bdc$79c86dc0$6d594940$@net>
 <20190716070246.0745ee6f@hermes.lan> <01db01d559e5$64d71de0$2e8559a0$@net>
 <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
 <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com>
 <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
 <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
 <00aa01d5630b$7e062660$7a127320$@net>
 <4242994D-E2CF-499A-848A-7B14CE536E33@raytheon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c3b83305-82a5-f3c8-2602-1aed2e9b51ca@gmail.com>
Date:   Wed, 4 Sep 2019 14:23:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4242994D-E2CF-499A-848A-7B14CE536E33@raytheon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/4/19 2:00 PM, Mark KEATON wrote:
> Hi Willem,
> 
> I am the person who commented on the original bug report in bugzilla.
> 
> In communicating with Steve just now about possible solutions that maintain the efficiency that you are after, what would you think of the following:  keep two lists of UDP sockets, those connected and those not connected, and always searching the connected list first. 

This was my suggestion.

Note that this requires adding yet another hash table, and yet another lookup
(another cache line miss per incoming packet)

This lookup will slow down DNS and QUIC servers, or any application solely using not connected sockets.


The word 'quick' you use is slightly misleading, since a change like that is a trade off.
Some applications might become faster, while others become slower.

Another issue is that a connect() can follow a bind(), we would need to rehash sockets
from one table to another. (Or add another set of anchors in UDP sockets, so that sockets can be in all the hash tables)


 If the connected list is empty, then the lookup can quickly use the not connected list to find a socket for load balancing.  If there are connected sockets, then only those connected sockets are searched first for an exact match.
> 
> Another option might be to do it with a single list if the connected sockets are all at the beginning of the list.  This would require the two separate lookups to start at different points in the list.
> 
> Thoughts?
> 
> Thanks!
> Mark
> 
> 
>> On Sep 4, 2019, at 6:28 AM, Steve Zabele <zabele@comcast.net> wrote:
>>
>> Hi Willem,
>>
>> Thanks for continuing to poke at this, much appreciated!
>>
>>> As for the BPF program: good point on accessing the udp port when
>>> skb->data is already beyond the header.
>>
>>> Programs of type sk_filter can use bpf_skb_load_bytes(_relative).
>>> Which I think will work, but have not tested.
>>
>> Please note that the test code was intentionally set up to make testing as simple as possible. Hence the source addresses for the multiple UDP sessions were identical -- but that is not the general case. In the general case a connected and bound socket should be associated with exactly one five tuple (source and dest addresses, source and destination ports, and protocol.
>>
>> So a 'connect bpf' would actually need access to the IP addresses as well, not just the ports. To do this, the load bytes call required negative arguments, which failed miserably when we tried it.
>>
>> In any event, there remains the issue of figuring out which index to return when a match is detected since the index is not the same as the file descriptor value and in fact can change as file descriptors are added and deleted. If I understand the kernel mechanism correctly, the operation is something like this. When you add the first one, its assigned to the first slot; when you add the second its assigned to the second slot; when you delete the first one, the second is moved to the first slot) so tracking this requires figuring out the order stored in the socket array within the kernel, and updating the bpf whenever something changes. I don't know if it's even possible to query which slot a given 
>>
>> So we think handling this with a bpf is really not viable.
>>
>> One thing worth mentioning is that the connect mechanism here is meant to (at least used to) work the same as connect does with TCP. Bind sets the expected/required local address and port; connect sets the expected/required remote address and port -- so a socket file descriptor becomes associated with exactly one five-tuple. That's how it's worked for several decades anyway.
>>
>> Thanks again!!!
>>
>> Steve
>>
>> -----Original Message-----
>> From: Willem de Bruijn [mailto:willemdebruijn.kernel@gmail.com] 
>> Sent: Tuesday, September 03, 2019 1:56 PM
>> Cc: Eric Dumazet; Steve Zabele; Network Development; shum@canndrew.org; vladimir116@gmail.com; saifi.khan@strikr.in; Daniel Borkmann; on2k16nm@gmail.com; Stephen Hemminger
>> Subject: Re: Is bug 200755 in anyone's queue??
>>
>> On Fri, Aug 30, 2019 at 4:30 PM Willem de Bruijn
>> <willemdebruijn.kernel@gmail.com> wrote:
>>>
>>> On Fri, Aug 30, 2019 at 4:54 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>> On 8/29/19 9:26 PM, Willem de Bruijn wrote:
>>>>
>>>>> SO_REUSEPORT was not intended to be used in this way. Opening
>>>>> multiple connected sockets with the same local port.
>>>>>
>>>>> But since the interface allowed connect after joining a group, and
>>>>> that is being used, I guess that point is moot. Still, I'm a bit
>>>>> surprised that it ever worked as described.
>>>>>
>>>>> Also note that the default distribution algorithm is not round robin
>>>>> assignment, but hash based. So multiple consecutive datagrams arriving
>>>>> at the same socket is not unexpected.
>>>>>
>>>>> I suspect that this quick hack might "work". It seemed to on the
>>>>> supplied .c file:
>>>>>
>>>>>                  score = compute_score(sk, net, saddr, sport,
>>>>>                                        daddr, hnum, dif, sdif);
>>>>>                  if (score > badness) {
>>>>>  -                       if (sk->sk_reuseport) {
>>>>>  +                       if (sk->sk_reuseport && !sk->sk_state !=
>>>>> TCP_ESTABLISHED) {
>>>
>>> This won't work for a mix of connected and connectionless sockets, of
>>> course (even ignoring the typo), as it only skips reuseport on the
>>> connected sockets.
>>>
>>>>>
>>>>> But a more robust approach, that also works on existing kernels, is to
>>>>> swap the default distribution algorithm with a custom BPF based one (
>>>>> SO_ATTACH_REUSEPORT_EBPF).
>>>>>
>>>>
>>>> Yes, I suspect that reuseport could still be used by to load-balance incoming packets
>>>> targetting the same 4-tuple.
>>>>
>>>> So all sockets would have the same score, and we would select the first socket in
>>>> the list (if not applying reuseport hashing)
>>>
>>> Can you elaborate a bit?
>>>
>>> One option I see is to record in struct sock_reuseport if any port in
>>> the group is connected and, if so, don't return immediately on the
>>> first reuseport_select_sock hit, but continue the search for a higher
>>> scoring connected socket.
>>>
>>> Or do return immediately, but do this refined search in
>>> reuseport_select_sock itself, as it has a reference to all sockets in the
>>> group in sock_reuseport->socks[]. Instead of the straightforward hash.
>>
>> That won't work, as reuseport_select_sock does not have access to
>> protocol specific data, notably inet_dport.
>>
>> Unfortunately, what I've come up with so far is not concise and slows
>> down existing reuseport lookup in a busy port table slot. Note that it
>> is needed for both ipv4 and ipv6.
>>
>> Do not break out of the port table slot early, but continue to search
>> for a higher scored match even after matching a reuseport:
>>
>> "
>>   @@ -413,28 +413,39 @@ static struct sock *udp4_lib_lookup2(struct net *net,
>>                                     struct udp_hslot *hslot2,
>>                                     struct sk_buff *skb)
>> {
>> +       struct sock *reuseport_result = NULL;
>>        struct sock *sk, *result;
>> +       int reuseport_score = 0;
>>        int score, badness;
>>        u32 hash = 0;
>>
>>        result = NULL;
>>        badness = 0;
>>        udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
>>                score = compute_score(sk, net, saddr, sport,
>>                                      daddr, hnum, dif, sdif);
>>                if (score > badness) {
>> -                       if (sk->sk_reuseport) {
>> +                       if (sk->sk_reuseport &&
>> +                           sk->sk_state != TCP_ESTABLISHED &&
>> +                           !reuseport_result) {
>>                                hash = udp_ehashfn(net, daddr, hnum,
>>                                                   saddr, sport);
>> -                               result = reuseport_select_sock(sk, hash, skb,
>> +                               reuseport_result =
>> reuseport_select_sock(sk, hash, skb,
>>                                                        sizeof(struct udphdr));
>> -                               if (result)
>> -                                       return result;
>> +                               if (reuseport_result)
>> +                                       reuseport_score = score;
>> +                               continue;
>>                        }
>>                        badness = score;
>>                        result = sk;
>>                }
>>        }
>> +
>> +       if (badness < reuseport_score)
>> +               result = reuseport_result;
>> +
>>        return result;
>> "
>>
>> To break out after the first reuseport hit when it is safe, i.e., when
>> it holds no connected sockets, requires adding this state to struct
>> reuseport_sock at __ip4_datagram_connect. And modify
>> reuseport_select_sock to read this. At least, I have not found a more
>> elegant solution.
>>
>>> Steve, Re: your point on a scalable QUIC server. That is an
>>> interesting case certainly. Opening a connected socket per flow adds
>>> both memory and port table pressure. I once looked into an SO_TXONLY
>>> udp socket option that does not hash connected sockets into the port
>>> table. In effect receiving on a small set of listening sockets (e.g.,
>>> one per cpu) and sending over separate tx-only sockets. That still
>>> introduces unnecessary memory allocation. OTOH it amortizes some
>>> operations, such as route lookup.
>>>
>>> Anyway, that does not fix the immediate issue you reported when using
>>> SO_REUSEPORT as described.
>>
>> As for the BPF program: good point on accessing the udp port when
>> skb->data is already beyond the header.
>>
>> Programs of type sk_filter can use bpf_skb_load_bytes(_relative).
>> Which I think will work, but have not tested.
>>
>> As of kernel 4.19 programs of type BPF_PROG_TYPE_SK_REUSEPORT can be
>> attached (with CAP_SYS_ADMIN). See
>> tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c for an
>> example that parses udp headers with bpf_skb_load_bytes.
>>
