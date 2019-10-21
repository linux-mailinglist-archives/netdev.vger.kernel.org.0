Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28D8FDF669
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbfJUUAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:00:07 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37285 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729388AbfJUUAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:00:07 -0400
Received: by mail-qk1-f193.google.com with SMTP id u184so13968879qkd.4;
        Mon, 21 Oct 2019 13:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=7wF4eyy9rC944zoBFkPA6SZd0QMuYvB01rxgc/hAHLc=;
        b=nv89j+Mtc4h+5bbUlsWFdYazWmIZKRckM5LiqYUBy0ZpcyPntno0fdixxs8l65VSvz
         OloXvPlU6tQ1xLPJqb8dC3yxmkZYpHZ9mI4sVt+Ia05/x3II58fUjkKwiVajw6IHBtXL
         FjUBxN8v/AfryxWxbR6ppp5ivpezTs9HoaFap4LWOxVxphGKPabx9jDMwza40RMHgh6q
         umXfCzkXgKNlNkbliBBkiY7kWcfSKw0s4MTIJaDB1fxeSVqU1iK+1HIbE+h5nQSm9geF
         ornFmRRqFJAni92Z9YqALPSLuBeSOwUMWscQImybKLI/nfjr8EC7Z0Ex637F304sGOQt
         yT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=7wF4eyy9rC944zoBFkPA6SZd0QMuYvB01rxgc/hAHLc=;
        b=gp2qAZCy9Sx9c3fghX4VsIgzSvMU3w1FT8gynoL4hZ4erppcGdMB29N80n3W92eTVT
         HPqGbj1SiJk9QMH7Y0iFRl2FeuyQfflm7MZbyMaw2Iu4c68CnPuU3wVpqUBVb3AXJNZu
         gpUqVwgXfBgezloEYIq4Af00Rh5KwR3BEhBv7rNR4R9/eq5h+kQKE/mtFE5ie3ny/VSo
         Duc6P/T5CZ4nvK4nMqunf07fp28lxmj+SaKWm0F+E0WWr2B5iaf5z9Ir20Z2AS8FJRZa
         YTGBW7UIHXXfSlGxmBBksNxA9eVGm+dWYqaO+uCrSkfiJKh7XgDTbXnOnIoM1edie0e3
         2MdQ==
X-Gm-Message-State: APjAAAX5f+RhfRUmI7DmhFPY4REGrmGDfYLvmY42sX5GZrDnsLuC13FI
        aFGiqga8EPxK730i4Hild4N7W4PR
X-Google-Smtp-Source: APXvYqyZO3c4dDzRJWSN5v7kq93oggd2iavsMn1mKpfJEnFpbAFTNXofIaMrhcFLmSWs0XSgnp9ybg==
X-Received: by 2002:a37:7686:: with SMTP id r128mr22958010qkc.444.1571688006052;
        Mon, 21 Oct 2019 13:00:06 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f144sm8213888qke.132.2019.10.21.13.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:00:05 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:00:04 -0400
Message-ID: <20191021160004.GD90634@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/16] net: dsa: add ports list in the switch
 fabric
In-Reply-To: <20191021123740.GC16084@lunn.ch>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-3-vivien.didelot@gmail.com>
 <20191021123740.GC16084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 14:37:40 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > +static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
> > +{
> > +	struct dsa_switch_tree *dst = ds->dst;
> > +	struct dsa_port *dp;
> > +
> > +	dp = &ds->ports[index];
> > +
> > +	dp->ds = ds;
> > +	dp->index = index;
> > +
> > +	INIT_LIST_HEAD(&dp->list);
> > +	list_add(&dp->list, &dst->ports);
> > +
> > +	return dp;
> > +}
> 
> Bike shedding, but i don't particularly like the name touch.  How
> about list. The opposite would then be delist, if we ever need it?

The fabric code uses "touch" for "get or create" already, so I used the same
semantics for ports as well. But I'm not strongly attached to this naming
anyway, so I will polish them all together in a future series.


Thanks,
Vivien
