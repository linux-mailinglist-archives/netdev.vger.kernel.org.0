Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9820A455FA5
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhKRPj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbhKRPj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 10:39:58 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B329C061574;
        Thu, 18 Nov 2021 07:36:58 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so11602472otg.4;
        Thu, 18 Nov 2021 07:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dZlZJATQ/YmcJWgA31Q7e7yJH81G5LLLJ42PGoSP0yI=;
        b=EJXnXAqgwaqGjyZXZVTkLHK0Qp8VQFd7iFh+WtunxBelUvtr0lgK4lVp9UkuwxQTeY
         8D0rpyErhdP5ZwYzWKyuVP0lsQFNCKSGJVAS8Ea7c3HteDQg+YKfiEo9WEaDmZpieO34
         5cC+kbDe/VQVw8ouBPT/6xW1WxCxr3otNxvLAGF+RGuO5lBwdDBsSja2xazPLxoSA8QH
         6dvmXESOrug6o0IZxqZm5p5ysLRraui14a2Y2wfe7B/ZKET0mIjZH7ARPNYTBiqbbGHK
         tEyqZrCM4tz7qlgxCJDal9+NsRF7TKESmiuAUqqu9BuYkXTKtZlu/39ci0zWxxQJ20Hr
         XXXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dZlZJATQ/YmcJWgA31Q7e7yJH81G5LLLJ42PGoSP0yI=;
        b=rphVHOivmvPMQIfe2TyFpXJ+atXdiIx3VoAZx7WlCPujJkHzGOlBfH2otK4w4Y8rua
         0DIuUpULY5MTiXRJtVmkVyCXgDKsBpQaUFM7+3tnG/dBwDUW8Hd8XfMS9mRVfDtY+YOl
         dVL7g7pWPHb6G2OJ2vJRvZjOXRLuB98bygJUzI5g5X600jbqA2nzNavG14ipn299+ZZk
         UhAqqpQ6bPEfGjV78+ErTZiq3bDIJw1Z6Zg0NuPw+2HXb6iFOR9oDwtsch9lxJyH1FCh
         4GeGDYG91Iw7lKHbph9NH81zr1qVfUQXGLJVpfS8I3WCSCVRBmKZZgQkKKHYn+dtucKv
         wWNw==
X-Gm-Message-State: AOAM533KMmWxt2tFWnzEVEQuPVMhDzyekqAXwXlpd9uhv6qlZoJJYXrX
        77+QPhahFCkBGWNwhX/RoNU=
X-Google-Smtp-Source: ABdhPJzBnDAazNpr2RMobQK1UpRc2NWjCOCOE7f0HrPAtpc5UHuOh8P96ocIpy4uoI5W39b5Pad0cg==
X-Received: by 2002:a9d:24c3:: with SMTP id z61mr21930817ota.100.1637249817453;
        Thu, 18 Nov 2021 07:36:57 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id l23sm33822oti.16.2021.11.18.07.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 07:36:57 -0800 (PST)
Message-ID: <67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com>
Date:   Thu, 18 Nov 2021 08:36:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 net-next 0/2] net: snmp: tracepoint support for snmp
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org, rostedt@goodmis.org
Cc:     davem@davemloft.net, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, ycheng@google.com,
        kuniyu@amazon.co.jp, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211118124812.106538-1-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211118124812.106538-1-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/21 5:48 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> snmp is the network package statistics module in kernel, and it is
> useful in network issue diagnosis, such as packet drop.
> 
> However, it is hard to get the detail information about the packet.
> For example, we can know that there is something wrong with the
> checksum of udp packet though 'InCsumErrors' of UDP protocol in
> /proc/net/snmp, but we can't figure out the ip and port of the packet
> that this error is happening on.
> 
> Add tracepoint for snmp. Therefor, users can use some tools (such as
> eBPF) to get the information of the exceptional packet.
> 
> In the first patch, the frame of snmp-tracepoint is created. And in
> the second patch, tracepoint for udp-snmp is introduced.
> 

there is already good infrastructure around kfree_skb - e.g., drop watch
monitor. Why not extend that in a way that other drop points can benefit
over time?

e.g., something like this (uncompiled and not tested; and to which
Steven is going to suggest strings for the reason):

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0bd6520329f6..e66e634acad0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1075,8 +1075,13 @@ static inline bool skb_unref(struct sk_buff *skb)
        return true;
 }

+enum skb_drop_reason {
+       SKB_DROP_REASON_NOT_SPECIFIED,
+       SKB_DROP_REASON_CSUM,
+}
 void skb_release_head_state(struct sk_buff *skb);
 void kfree_skb(struct sk_buff *skb);
+void kfree_skb_with_reason(struct sk_buff *skb, enum skb_drop_reason);
 void kfree_skb_list(struct sk_buff *segs);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 9e92f22eb086..2a2d263f9d46 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -14,7 +14,7 @@
  */
 TRACE_EVENT(kfree_skb,

-       TP_PROTO(struct sk_buff *skb, void *location),
+       TP_PROTO(struct sk_buff *skb, void *location, enum
skb_drop_reason reason),

        TP_ARGS(skb, location),

@@ -22,16 +22,18 @@ TRACE_EVENT(kfree_skb,
                __field(        void *,         skbaddr         )
                __field(        void *,         location        )
                __field(        unsigned short, protocol        )
+               __field(        unsigned int,   reason          )
        ),

        TP_fast_assign(
                __entry->skbaddr = skb;
                __entry->location = location;
                __entry->protocol = ntohs(skb->protocol);
+               __entry->reason = reason;
        ),

-       TP_printk("skbaddr=%p protocol=%u location=%p",
-               __entry->skbaddr, __entry->protocol, __entry->location)
+       TP_printk("skbaddr=%p protocol=%u location=%p reason %u",
+               __entry->skbaddr, __entry->protocol, __entry->location,
__entry->reason)
 );

 TRACE_EVENT(consume_skb,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 67a9188d8a49..388059bda3d1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -770,11 +770,29 @@ void kfree_skb(struct sk_buff *skb)
        if (!skb_unref(skb))
                return;

-       trace_kfree_skb(skb, __builtin_return_address(0));
+       trace_kfree_skb(skb, __builtin_return_address(0),
SKB_DROP_REASON_NOT_SPECIFIED);
        __kfree_skb(skb);
 }
 EXPORT_SYMBOL(kfree_skb);

+/**
+ *     kfree_skb_with_reason - free an sk_buff
+ *     @skb: buffer to free
+ *     @reason: enum describing why the skb is dropped
+ *
+ *     Drop a reference to the buffer and free it if the usage count has
+ *     hit zero.
+ */
+void kfree_skb_with_reason(struct sk_buff *skb, enum skb_drop_reason
reason);
+{
+       if (!skb_unref(skb))
+               return;
+
+       trace_kfree_skb(skb, __builtin_return_address(0), reason);
+       __kfree_skb(skb);
+}
+EXPORT_SYMBOL(kfree_skb_with_reason);
+
 void kfree_skb_list(struct sk_buff *segs)
 {
        while (segs) {
