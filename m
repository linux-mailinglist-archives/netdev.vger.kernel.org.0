Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09273F5E7B
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 11:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfKIKeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 05:34:11 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:55704 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726145AbfKIKeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 05:34:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04391;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0ThZCqFZ_1573295647;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0ThZCqFZ_1573295647)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 09 Nov 2019 18:34:07 +0800
Date:   Sat, 9 Nov 2019 18:34:07 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     edumazet@google.com, rostedt@goodmis.org, mingo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] tcp: remove redundant new line from tcp_event_sk_skb
Message-ID: <20191109103407.GA61998@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20191108095007.26187-1-tonylu@linux.alibaba.com>
 <795f4bb1-b40e-1745-0df4-6e55d80d5272@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <795f4bb1-b40e-1745-0df4-6e55d80d5272@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your comments, I am going to append the tag.

Cheers,
Tony Lu

On Fri, Nov 08, 2019 at 04:22:19AM -0800, Eric Dumazet wrote:
> 
> 
> On 11/8/19 1:50 AM, Tony Lu wrote:
> > This removes '\n' from trace event class tcp_event_sk_skb to avoid
> > redundant new blank line and make output compact.
> > 
> > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> > ---
> >  include/trace/events/tcp.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
> > index 2bc9960a31aa..cf97f6339acb 100644
> > --- a/include/trace/events/tcp.h
> > +++ b/include/trace/events/tcp.h
> > @@ -86,7 +86,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
> >  			      sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
> >  	),
> >  
> > -	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s\n",
> > +	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s",
> >  		  __entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
> >  		  __entry->saddr_v6, __entry->daddr_v6,
> >  		  show_tcp_state_name(__entry->state))
> > 
> 
> This seems good to me. Only few comments :
> 
> I would add a
> 
> Fixes: af4325ecc24f ("tcp: expose sk_state in tcp_retransmit_skb tracepoint")
> 
> And also CC (I just did in this reply) the author of the above patch to make sure nothing unexpected happens.
> 
> Thanks.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
