Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6696B338BE
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFCTD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:03:28 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41439 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFCTD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:03:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id 83so1987776pgg.8;
        Mon, 03 Jun 2019 12:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wj5NBkAskXIdMm5GMMxhnc//aB+trWbWwghMhqblI2g=;
        b=Oi5KdP6vFXTiYCX5YhmOC3z8WoM6HCJWm357pcq084Y65/vLtlIavRu0bTtmA03LCH
         k2qwxAA28Oi1+xxfwX+ChVcL7olkP60O50eO4Ame/QKmtzmnusqj/BM0/PVVYIuYw5cP
         QIlri+jhZt1Y/4MhFrsU6U1CIWo6R51wBnn4sKNyKgadcLQbl7Lh4kZW10mTkAr3hbwU
         A6LGRMUP5JM+Tz+NuGn1ffFAcMGPOdajqIsXmC8KVPV544/Jb+oLuzXwan3BX3KNf4k9
         USXPIyNK4ROvyDNO3dzpI/MZIvTyk5eBJxjMrgTEM22BPYjJ3moiHFp0iBm8bBMfs4nk
         8EFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wj5NBkAskXIdMm5GMMxhnc//aB+trWbWwghMhqblI2g=;
        b=q5ut3vMeGaLloXXuA/2gNT8Hb0LplOT8XNtRlV6BLLjjQ7MvIknu/lCwwImpYlxE6m
         P+Z8QAMeb3IASfT3K//cmQFqklwVPw8TAWwRdWMUUbamz62gdAWvwJj6xhiYqIHjl9IC
         c8oXTlmQ3XJlrFLTBiZj4CU6pdCnScivVhfmk0FigtgftkidM8y0DPBaSNwgHS7S3xwq
         jHcQa70hs90asWaI9F2llYXEi/bCoiW8YZ0MH5/uArYA62WYejUqkki+uu4DZE+PV0vm
         yxky69GITs4Nh/Xscf8YnjI1Tilhsb8X/1fFTO1LxJfJNVX9fd/eg7NhB9uN+ESCWJzK
         d7RA==
X-Gm-Message-State: APjAAAWD/4lpKR1DxfeX7i/E6GSZCkBwq1qdWRMI/iwxDy/wCAgBCD9u
        hn1AShY7H7yBKbSNbW4TBOrYXQsLwA==
X-Google-Smtp-Source: APXvYqyIta7FKNgPtn64HcmLdHNwehlQynEnE1Dk1kGzqGOQQCu36STH4240jpC6lIhNyw469JE7Uw==
X-Received: by 2002:a17:90a:216f:: with SMTP id a102mr17291210pje.29.1559588607271;
        Mon, 03 Jun 2019 12:03:27 -0700 (PDT)
Received: from ubuntu (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id s12sm3394529pjp.10.2019.06.03.12.03.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 12:03:26 -0700 (PDT)
Date:   Sat, 1 Jun 2019 22:27:06 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190602022706.GA24477@ubuntu>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
 <20190531193558.GB4276@ubuntu>
 <20190601002230.bo6dhdf3lhlkknqq@salvia>
 <20190601150429.GA16560@ubuntu>
 <20190603123006.urztqvxyxcm7w3av@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603123006.urztqvxyxcm7w3av@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 02:30:06PM +0200, Pablo Neira Ayuso wrote:
> > I developed this patchset to suit my employer needs and there is no plan
> > for a follow up patchset, however I think non-zero offset might be useful
> > in the future for tunneled packets.
> 
> For tunneled traffic, we can store the network offset in the
> nft_pktinfo object. Then, add a new extension to update this network
> offset to point to the network offset inside the tunnel header, and
> use this pkt->network_offset everywhere.

OK. I'm changing so that offset isn't being used as input. But, it's
still being passed as reference for output. See further response
below...

> I think this new IPv4 options extension should use priv->offset to
> match fields inside the IPv4 option specifically, just like in the
> IPv6 extensions and TCP options do. If you look on how the
> priv->offset is used in the existing code, this offset points to
> values that the specific option field conveys.

I believe that's what I have coded:

	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type, NULL, NULL);
	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
		*dest = (err >= 0);
		return;
	} else if (err < 0) {
		goto err;
	}
	offset += priv->offset;

offset is returned as the offset where it matches the sought priv->type
then priv->offset is added to get to the right field between the offset.

If this is satisfactory, I can submit v2 of the kernel patch.

Thanks,

Stephen.
