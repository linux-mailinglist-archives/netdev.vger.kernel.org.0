Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C64AF1190D5
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfLJTjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:39:35 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46657 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJTje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:39:34 -0500
Received: by mail-qt1-f196.google.com with SMTP id 38so3852810qtb.13
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 11:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=lhiNdVC12nCt8MlphHeNeXsppJHwJXSdVTCOLb3ahXE=;
        b=mVxM7iSVV/fJa7CCTSh9gS1EjUUhQtROEIUQEHdzVn1zNAU3PG0vNxRzPjSWofjHgZ
         ugWkGOdN4LCE8DKbwHJL0DJt24YFP4bxZXjgApONHGBb5y8IJmVwx574VvhcVHf2sBlL
         HB60b42pfla8/r1sKziGjeGJv5oce1uCdqEij3r6hN+uK5UqDIBMLwyb/wvCHsGNo5l5
         RrS+sVIJUmgSJPgnU3BoP6UOEiMRvQn3RnrYdoNYsK6/WJ6De1qrREgshWFvxG3WCsCW
         cmov1+bx9aKLaloZm+BQP31YIJOJr4vX+soePPXfHPgO8GdjDniAPsZZwoDf1VoTMcyv
         GexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=lhiNdVC12nCt8MlphHeNeXsppJHwJXSdVTCOLb3ahXE=;
        b=ou88SxPj+IWBmkIztW/hjmYDgSCjM9DjggWq+kc/iW8hGVtXPR7iEoQ1+SXdaVryn0
         SSlPi6TwL24GOyfhTe8gNIAYlkv28PYIoSuxuv5HCZNhgDgx/qlmM5m7CHTIRMtmLyuy
         qu1WPnDAp/V8ehOLmLe7F2adZCTVZu18h8tM/RfitOJwPwn1pdZADJyYnMJ4Iz3OlkHD
         N+7nH+R2vYLDfn5wAFRBHj98jN7nyndFm+j/W+dM8LlLX8KVknQal8VT5nJK/jcTJ70a
         WBNdohdrGF6znEklbGzEPiXX2Gn+eOh7XWDqaSEkmRccPk++AVOsAt0BIyeHlEnY5Zll
         wCkQ==
X-Gm-Message-State: APjAAAXiidUXOy3yJ1D5Tz/t/bFm/lUts1/0HFX2Ajrw/uQVuqZQl38p
        FIceLF5A1t5T+tupDyC/58utG3rwZnE=
X-Google-Smtp-Source: APXvYqwU1xxAUS2fWCQNFh42v/nXu9DqiiWlsyq9lJNmp5wvKyArMv0ENCgUYFRU+5XyEjTRYnAs2w==
X-Received: by 2002:ac8:664a:: with SMTP id j10mr31595333qtp.70.1576006773764;
        Tue, 10 Dec 2019 11:39:33 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o7sm1211842qkd.119.2019.12.10.11.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 11:39:32 -0800 (PST)
Date:   Tue, 10 Dec 2019 14:39:31 -0500
Message-ID: <20191210143931.GF1344570@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next] net: bridge: add STP xstats
In-Reply-To: <a3b8e24d-5152-7243-545f-8a3e5fbaa53a@cumulusnetworks.com>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
 <a3b8e24d-5152-7243-545f-8a3e5fbaa53a@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

On Tue, 10 Dec 2019 09:49:59 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> Why did you send the bridge patch again ? Does it have any changes ?

The second iproute2 patch does not include the include guards update, but
I kept the bridge_stp_stats structure and the BRIDGE_XSTATS_STP definition
otherwise iproute2 wouldn't compile.

> 
> Why do you need percpu ? All of these seem to be incremented with the
> bridge lock held. A few more comments below.

All other xstats are incremented percpu, I simply followed the pattern.

> >  	struct net_bridge_port *p
> >  		= container_of(kobj, struct net_bridge_port, kobj);
> > +	free_percpu(p->stp_stats);
> 
> Please leave a new line between local var declaration and the code. I know
> it was missing, but you can add it now. :)

OK.

> > +	if (p) {
> > +		struct bridge_stp_xstats xstats;
> 
> Please rename the local var here, using just xstats is misleading.
> Maybe stp_xstats ?

This isn't misleading to me since its scope is limited to the current block
and not the entire function. The block above dumping the VLAN xstats is
using a local "struct br_vlan_stats stats" variable for example.

> 
> > +
> > +		br_stp_get_xstats(p, &xstats);
> > +
> > +		if (nla_put(skb, BRIDGE_XSTATS_STP, sizeof(xstats), &xstats))
> > +			goto nla_put_failure;
> 
> Could you please follow how mcast xstats are dumped and do something similar ?
> It'd be nice to have similar code to audit.

Sure. I would also love to have easily auditable code in net/bridge. For
the bridge STP xstats I followed the VLAN xstats code above, which does:

    if (nla_put(skb, BRIDGE_XSTATS_VLAN, sizeof(vxi), &vxi))
        goto nla_put_failure;

But I can change the STP xstats code to the following:

    if (p) {
        nla = nla_reserve_64bit(skb, BRIDGE_XSTATS_STP,
                                sizeof(struct bridge_stp_xstats),
                                BRIDGE_XSTATS_PAD);
        if (!nla)
            goto nla_put_failure;

        br_stp_get_xstats(p, nla_data(nla));
    }

Would that be preferred?


Thanks,

	Vivien
