Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685F866B4DF
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 00:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjAOX6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 18:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjAOX6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 18:58:38 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE412CC27
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 15:58:35 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id m7so810421ilh.7
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 15:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nmXehuDx2Dw4AYU/FQM4t1NGahLAaHGd5zW1WzvYQSg=;
        b=PkN/ocfprm+9auktaP2EFuMHm4hfCduyAZjXJmSFVWQAy/jaZzQoRhPt1A5mrz6rFj
         mOwyy/1O5qURtOmeRmeLvy/AEQDrlAnGFxb1iCzqje6+Lo/R12XRaeylzp49q87Fj2aw
         9BNGzyjmc7fq/s40kzb2+a1Kz2bbKSlTYvoeRaDB63qJuheN1rcTnboMWolgdYsNfrOh
         LfbqHujfaPZLHGdl83OpTb903Y4Me0SN92GFuy5wtwbHvZgocMINL1/QXp0jgRDDktHW
         M2OCD8OKYaZCkmB8IWM3anlvHmNipVevGHFIm6bQkLIbVRXY6VgDktgXvDrl1LEINEDU
         GhSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nmXehuDx2Dw4AYU/FQM4t1NGahLAaHGd5zW1WzvYQSg=;
        b=VTXL2tbbgm5sFiZLlggfllF3LNoVwchvrWT6JihNtlHoQg6u0QjXurPcNpItUPeHxa
         eSd2GGj4bvj6iS20H9CdcwSBSYgCqMeoVOGqdvr/JhyYyhCL9wAhSpPH7tD6ZvMhLCrz
         PAzjLCdUNK3KUhgxutMkl2Yxw/bpFopLl/JdhUlVF6M9c4Y8C+VpeSTPPMBxRXOvawtn
         OtrWzlkpVsFu5nylUoUAa3i06cpQT6C15ZEfqjAHTKevt9phHPf+bajPPvQZj6CwQxqj
         Fvgxh1Atzmvepzah5QbdRUhSTtE7dpjf99/5FXubcvEOMnVe8laYFmXmemolqEF+iy8D
         pVQQ==
X-Gm-Message-State: AFqh2kriFEJctqfKmU1muXY5ImUGQnbDU0Gdk01MPvxA80Pvb4W2rIBx
        HJnOYiNXMIOm2r3530J5GE4=
X-Google-Smtp-Source: AMrXdXv0zazo2Y87mAt1sZ5dc/LQLw091Xo8diiQrnzGoyBXY+unhEtw47AIa6ZyVEQehkn2VUZBWg==
X-Received: by 2002:a92:360e:0:b0:30f:618:d931 with SMTP id d14-20020a92360e000000b0030f0618d931mr1459742ila.10.1673827114880;
        Sun, 15 Jan 2023 15:58:34 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:7de9:438a:dc6b:e300? ([2601:284:8200:b700:7de9:438a:dc6b:e300])
        by smtp.googlemail.com with ESMTPSA id c72-20020a02964e000000b00363d6918540sm7976751jai.171.2023.01.15.15.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 15:58:34 -0800 (PST)
Message-ID: <b643ba75-204f-acaf-b942-6c1aea01ede6@gmail.com>
Date:   Sun, 15 Jan 2023 16:58:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in
 length_mt6
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>, Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
References: <cover.1673666803.git.lucien.xin@gmail.com>
 <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com>
 <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/23 12:40 PM, Eric Dumazet wrote:
> On Sun, Jan 15, 2023 at 6:43 PM Xin Long <lucien.xin@gmail.com> wrote:
>>
>> On Sun, Jan 15, 2023 at 10:41 AM David Ahern <dsahern@gmail.com> wrote:
>>>
>>> On 1/13/23 8:31 PM, Xin Long wrote:
>>>> For IPv6 jumbogram packets, the packet size is bigger than 65535,
>>>> it's not right to get it from payload_len and save it to an u16
>>>> variable.
>>>>
>>>> This patch only fixes it for IPv6 BIG TCP packets, so instead of
>>>> parsing IPV6_TLV_JUMBO exthdr, which is quite some work, it only
>>>> gets the pktlen via 'skb->len - skb_network_offset(skb)' when
>>>> skb_is_gso_v6() and saves it to an u32 variable, similar to IPv4
>>>> BIG TCP packets.
>>>>
>>>> This fix will also help us add selftest for IPv6 BIG TCP in the
>>>> following patch.
>>>>
>>>
>>> If this is a bug fix for the existing IPv6 support, send it outside of
>>> this set for -net.
>>>
>> Sure,
>> I was thinking of adding it here to be able to support selftest for
>> IPv6 too in the next patch. But it seems to make more sense to
>> get it into -net first, then add this selftest after it goes to net-next.
>>
>> I will post it and all other fixes I mentioned in the cover-letter for
>> IPv6 BIG TCP for -net.
>>
>> But before that, I hope Eric can confirm it is okay to read the length
>> of IPv6 BIG TCP packets with skb_ipv6_totlen() defined in this patch,
>> instead of parsing JUMBO exthdr?
>>
> 
> I do not think it is ok, but I will leave the question to netfilter maintainers.
> 
> Guessing things in tcpdump or other tools is up to user space implementations,
> trying to work around some (kernel ?) deficiencies.
> 
> Yes, IPv6 extensions headers are a pain, we all agree.
> 
> Look at how ip6_rcv_core() properly dissects extension headers _and_ trim
> skb accordingly (pskb_trim_rcsum() called either from ip6_rcv_core()
> or ipv6_hop_jumbo())
> 
> So skb->len is not the root of trust. Some transport mediums might add paddings.
> 
> Ipv4 has a similar logic in ip_rcv_core().
> 
> len = ntohs(iph->tot_len);
> if (skb->len < len) {
>      drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
>      __IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
>     goto drop;
> } else if (len < (iph->ihl*4))
>      goto inhdr_error;
> 
> /* Our transport medium may have padded the buffer out. Now we know it
> * is IP we can trim to the true length of the frame.
> * Note this now means skb->len holds ntohs(iph->tot_len).
> */
> if (pskb_trim_rcsum(skb, len)) {
>       __IP_INC_STATS(net, IPSTATS_MIB_INDISCARDS);
>       goto drop;
> }
> 
> After your changes, we might accept illegal packets that were properly
> dropped before.

