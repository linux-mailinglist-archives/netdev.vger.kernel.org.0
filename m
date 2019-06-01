Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5581832077
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfFASaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:30:55 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38578 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfFASay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 14:30:54 -0400
Received: by mail-yw1-f68.google.com with SMTP id b74so5577139ywe.5
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 11:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V4LEPBHszcA4LDKdJA8sIqb7I7JUdyqNTO7/R+BtBSw=;
        b=sJ/yX9U/e872vZ0TITenOSMzO1GzCg63IHjFB7HI3lEfS3TSilShCziBJXGNdz/z5/
         1loPoCWdshiQ2Qu3nwFYj39CuuXggu/4M+sxO6FHh0VhizqhdIXP8Y+z6DaDdxZeBxax
         Elo7yGMqgzHGI+zi7p6C5UhcBAt+M0ExC6VpsgL3efUsiQbftWn1CnUqlhUjzrRDU8Pa
         KqtP7MqKW6zcrtXytN/dwP206uDZBzoStTLeL7z9AqkjT4bzqejl58KKGSCJ3KWszHJ0
         RaejYErd3HL1iNy5NsmQTghKijpKYx3LmlKafgIgCmhD000MzIYLoPJ6yzE8An07A7mg
         KORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V4LEPBHszcA4LDKdJA8sIqb7I7JUdyqNTO7/R+BtBSw=;
        b=GvBWTqz4eigNOUMRdh8NBLQtqOYkykU8qV0qrhxx9T/KFx8JXKzD+x8oS+ar8Um8xb
         qKfnVVDFhNvqrcwUjtHsXMcv8JdIGJCjQKQlWqkEuJPDCEAufmIe6GcpisH9h3bnKD3V
         0ivvuLMgXesgpEcBKeqwFx7pT+/GN3+Zl1FT4fS+5MlUx5XpkOEg9ZEpcaS1aSZyDo2s
         KX/s/lafLEzoMr3k7di7W97WOW60taSA72VrwUjydFHany8OSHzMalOZUA/SD98A2sMp
         aiaBeCttpV6QTqkXQSq/o3Leh+IqGLXBxQBIqCqzSByljpFJzC1FHYJYRtcAe55Apg2l
         Kppg==
X-Gm-Message-State: APjAAAW9hpnre8fhnXUcAFSFE9QouWrHLQqDmPMS8l/y2JANoWE3cGIV
        fye8FYtdE0yXnc9OiMw51A==
X-Google-Smtp-Source: APXvYqx1F0R6DsOG08UEUIvcoBrNjT7iYBUxBmYduN9XdmtRu/o5QljmFP6ozVPa6MFuxQj1VJpu/g==
X-Received: by 2002:a81:3dc8:: with SMTP id k191mr9040955ywa.383.1559413853953;
        Sat, 01 Jun 2019 11:30:53 -0700 (PDT)
Received: from ubuntu (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id v124sm1914060ywb.15.2019.06.01.11.30.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 01 Jun 2019 11:30:53 -0700 (PDT)
Date:   Sat, 1 Jun 2019 14:14:29 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] vrf: Increment Icmp6InMsgs on the original netdev
Message-ID: <20190601181429.GB16560@ubuntu>
References: <20190530050815.20352-1-ssuryaextr@gmail.com>
 <c438f6b0-bb3c-7568-005e-68d7fcd406c3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c438f6b0-bb3c-7568-005e-68d7fcd406c3@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 05:06:16PM -0600, David Ahern wrote:
> On 5/29/19 11:08 PM, Stephen Suryaputra wrote:
> > diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
> > index 1a832f5e190b..9b365c345c34 100644
> > --- a/net/ipv6/reassembly.c
> > +++ b/net/ipv6/reassembly.c
> > @@ -260,6 +260,9 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
> >  	int payload_len;
> >  	u8 ecn;
> >  
> > +	if (netif_is_l3_master(dev))
> > +		dev = dev_get_by_index_rcu(net, inet6_iif(skb));
> > +
> >  	inet_frag_kill(&fq->q);
> >  
> >  	ecn = ip_frag_ecn_table[fq->ecn];
> > 
> 
> this part changes skb->dev. Seems like it has an unintended effect if
> the packet is delivered locally.

Ah, right. How about this then?

+/**
+ * __in6_dev_stats_get - get inet6_dev pointer for stats
+ * @dev: network device
+ * @skb: skb for original incoming interface if neeeded
+ *
+ * Caller must hold rcu_read_lock or RTNL, because this function
+ * does not take a reference on the inet6_dev.
+ */
+static inline struct inet6_dev *__in6_dev_stats_get(const struct net_device *dev,
+						    const struct sk_buff *skb)
+{
+	if (netif_is_l3_master(dev))
+		dev = dev_get_by_index_rcu(dev_net(dev), inet6_iif(skb));
+	return __in6_dev_get(dev);
+}

@@ -260,9 +260,6 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	int payload_len;
 	u8 ecn;
 
-	if (netif_is_l3_master(dev))
-		dev = dev_get_by_index_rcu(net, inet6_iif(skb));
-
 	inet_frag_kill(&fq->q);
 
 	ecn = ip_frag_ecn_table[fq->ecn];
@@ -305,7 +302,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 			   skb_network_header_len(skb));
 
 	rcu_read_lock();
-	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMOKS);
+	__IP6_INC_STATS(net, __in6_dev_stats_get(dev, skb), IPSTATS_MIB_REASMOKS);
 	rcu_read_unlock();
 	fq->q.rb_fragments = RB_ROOT;
 	fq->q.fragments_tail = NULL;
@@ -319,7 +316,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	net_dbg_ratelimited("ip6_frag_reasm: no memory for reassembly\n");
 out_fail:
 	rcu_read_lock();
-	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMFAILS);
+	__IP6_INC_STATS(net, __in6_dev_stats_get(dev, skb), IPSTATS_MIB_REASMFAILS);
 	rcu_read_unlock();
 	inet_frag_kill(&fq->q);
 	return -1;

Thanks.
