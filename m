Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA79129992
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 18:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLWRtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 12:49:09 -0500
Received: from mail-pl1-f171.google.com ([209.85.214.171]:45571 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfLWRtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 12:49:09 -0500
Received: by mail-pl1-f171.google.com with SMTP id b22so7442095pls.12;
        Mon, 23 Dec 2019 09:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BD3ugHGbi3JiphrEuLGlasM1GtjCU97ipFBRiz4FgVk=;
        b=js5ANKTf4YyTpQv6Yv54NNQNJ7VUw2lPzOINHNXnx/lVFgCSSoxgOcCtjjEzjijdBQ
         2wfu5A3b8A9Ut6fbq9QJAB23z+o0WBGC5+bYcfzM6fP2ZbHE7eIuVTQk39KB0tZ0jZl4
         37ZDQnCHZ11HHSUSK4Y53H6ScxfGLsJaW2gXcg8j0kG7h/VvZpFrIw7r6RrkLUaBl62K
         14iatrwvyDXmElldPxKejzaXSunSvZDNkesIcCRyA+JjsaCuv8IFrSnGiIslYjZKKqiK
         nmHpMbw5nve07i766p5UJWGiuSQ9Q0KowUAi5VGQxOXPAD87eOyOw1fAiq3MaDpXifUu
         BhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BD3ugHGbi3JiphrEuLGlasM1GtjCU97ipFBRiz4FgVk=;
        b=Meh4D74dLMeTJwIg2BO2vUaZ5QWri0kBaHItM2D9V8jrdC+2zlmIdskmysA00FWzrc
         H8eW8UbJvBPiSkUrzGwb32HI6IG+GaUHAoI5OmuGaST/kABydClfD9YG1lb2ZtldJZ3X
         iKZqf22zk1pDjr14lzQnwm3W78V7+kiMHMEirhMEwtNHQe1eiFk3Y7XkiWeeFDvpu/LB
         u61mO0Ntwpit1DiqzTA/dP2QqJnBiBRarINSjJhVIdV/SvtdkbR/TF00Z2qjbSg+bl19
         qw7XwatSpxS/22eHCrglNHB85Xcmd0nivhyaTrRj9CBbwhuVvJMgV3QqMUUTH3PrRbxm
         RV1A==
X-Gm-Message-State: APjAAAVplHpSte7oCDN/7QQyYcNPFKBo/dne6ryho53kI4r3uHtaKWaa
        e+LFnF2tq0pOYxxRyOkhSgc=
X-Google-Smtp-Source: APXvYqxQ78zuVH3ofKqIdW1oBKjo0GRWTdLy3Lz4XLOLn4DS1aMy8rBakviuxSziupUJqcYOF1HqtA==
X-Received: by 2002:a17:90a:cb16:: with SMTP id z22mr294798pjt.122.1577123348293;
        Mon, 23 Dec 2019 09:49:08 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.206])
        by smtp.gmail.com with ESMTPSA id v13sm24919211pgc.54.2019.12.23.09.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 09:49:07 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 5341EC16F2; Mon, 23 Dec 2019 14:49:04 -0300 (-03)
Date:   Mon, 23 Dec 2019 14:49:04 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     netdev@vger.kernel.org, dcaratti@redhat.com, lucien.xin@gmail.com,
        linux-sctp@vger.kernel.org
Subject: Re: SCTP over GRE (w csum)
Message-ID: <20191223174904.GL4444@localhost.localdomain>
References: <20191223174535.GF6274@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223174535.GF6274@localhost.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Just Cc-ing linux-sctp@ ]

On Mon, Dec 23, 2019 at 06:45:35PM +0100, Lorenzo Bianconi wrote:
> Hi all,
> 
> I am currently working on the following scenario:
> 
> sctp --> ipv4 --> gretap --> ipv6 --> eth
> 
> If NETIF_F_SCTP_CRC is not supported by the network device (it is the
> case for gre), sctp will fallback computing the crc32 in sw with
> sctp_gso_make_checksum(), where SKB_GSO_CB(skb)->csum is set to ~0 by
> gso_reset_checksum(). After the gso segmentation, gre_gso_segment()
> will try to compute gre csum with gso_make_checksum() even if skb->ip_summed
> is set to CHECKSUM_NONE (and so using ~0 as partial).
> One possible (trivial and not tested) solution would be to recompute the
> gre checksum, doing in gre_gso_segment() something like:
> 
> 	if (skb->ip_summed == CHECKSUM_NONE) {
> 		...
> 		err = skb_checksum_help(skb);
> 		if (err < 0)
> 			return return ERR_PTR(err);
> 	} else {
> 		*pcsum = gso_make_checksum(skb, 0);
> 	}
> 
> One possible improvement would be offload the GRE checksum computation if the
> hw exports this capability in netdev_features and fall back to the sw
> implementation if not.
> Am I missing something? Is there a better approach?
> 
> Regards,
> Lorenzo


