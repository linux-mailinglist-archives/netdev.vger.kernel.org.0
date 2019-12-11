Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA07711BF63
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 22:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLKVr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 16:47:58 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:46812 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfLKVr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 16:47:57 -0500
Received: by mail-qv1-f65.google.com with SMTP id t9so75385qvh.13
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 13:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=RaAE7sjaNd1lnPk57Cwl+t3wgCFYj7SYpv6MvMoqfZM=;
        b=TyBKqC7aMmrh+M6LP64NE4QW7xWQKWLDifFe4gpI7ZIaVzF4igUoNCdI6aw++uiE2w
         a2kHcrZ8EAdWJIDY54CrtgKsgAEjnSjG48BIbTqGWKmy66OUQYLEYGD476TScP+HmOIy
         /W9rmUeuAa87/A/TiMhuZVPWNXUQQUOe55G1llrZKFLXgUJiub0lIPNPmvGfNSg29efN
         nDUBa53Qtp0pOdxrRxHdIYa2ml8eAcIJFfsvY9IHqmdTN1iNFcqm+G/f2yPZWxxFRgyQ
         pSpz2RhqqpUZq9qXDtPSlqKGUvjgGsQIW44dcxSJy0ft0abuO6po6ZTTg46d48PieaZo
         OUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=RaAE7sjaNd1lnPk57Cwl+t3wgCFYj7SYpv6MvMoqfZM=;
        b=etUL6/6X3bnfL/PpSiGrqVdZnxhDDEVTM1yoPlKgY+sZr2YtT2gSJ0WyvqFEJllcDp
         yr0mF+o8DcnCcfLH8IS4UGTHxBdQaxe9viSFLrDbsZxiyzh6+6/tSHM8HYLoup7AqIms
         KeLTUr8pEJkpQj4dUN6wvKM1yP5iqxHZ50K+TKeyckOllzpAy8PI1kzL1PfROqRzJMbm
         5/thNMIs30xP10J8rP47E5wFZ77Y0dIFRGSfvyJc21XByyi3u8SzW4eP5iePQXmgdu6t
         nIYK1//5CosA6TLAmp6TMzlL5SX0NxDOV07sayz9p7+rjHJCLt7u4WE4n5SBh0rF95wI
         aiTg==
X-Gm-Message-State: APjAAAVUUMIQRv+DWpQC8bHplC/yiQLRBqtmaU7qdbu4/Ei6xR2lACGB
        Dp944qAQYqSYzZGBut404C0=
X-Google-Smtp-Source: APXvYqxp54jG68g6gUukW3yMjWMe0M9d2XbuokGR9xtBNRBzoSlTPiyfoICsOkrUnEFD1Kz1mCIkzw==
X-Received: by 2002:a0c:f513:: with SMTP id j19mr5185205qvm.206.1576100876870;
        Wed, 11 Dec 2019 13:47:56 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 184sm1061118qke.73.2019.12.11.13.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 13:47:55 -0800 (PST)
Date:   Wed, 11 Dec 2019 16:47:54 -0500
Message-ID: <20191211164754.GB1616641@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     nikolay@cumulusnetworks.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] net: bridge: add STP xstats
In-Reply-To: <20191211.120120.991784482938734303.davem@davemloft.net>
References: <0e45fd22-c31b-a9c2-bf87-22c16a60aeb4@gmail.com>
 <9f978ee1-08ee-aa57-6e3d-9b68657eeb14@cumulusnetworks.com>
 <20191211134133.GB1587652@t480s.localdomain>
 <20191211.120120.991784482938734303.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, 11 Dec 2019 12:01:20 -0800 (PST), David Miller <davem@davemloft.net> wrote:
> >> >>  /* Bridge multicast database attributes
> >> >>   * [MDBA_MDB] = {
> >> >>   *     [MDBA_MDB_ENTRY] = {
> >> >> @@ -261,6 +270,7 @@ enum {
> >> >>  	BRIDGE_XSTATS_UNSPEC,
> >> >>  	BRIDGE_XSTATS_VLAN,
> >> >>  	BRIDGE_XSTATS_MCAST,
> >> >> +	BRIDGE_XSTATS_STP,
> >> >>  	BRIDGE_XSTATS_PAD,
> >> >>  	__BRIDGE_XSTATS_MAX
> >> >>  };
> >> > 
> >> > Shouldn't the new entry be appended to the end - after BRIDGE_XSTATS_PAD
> >> > 
> >> 
> >> Oh yes, good catch. That has to be fixed, too.
> >> 
> > 
> > This I don't get. Why new attributes must come between BRIDGE_XSTATS_PAD
> > and __BRIDGE_XSTATS_MAX?
> 
> Because, just like any other attribute value, BRIDGE_XSTATS_PAD is an
> API and fixed in stone.  You can't add things before it which change
> it's value.

I thought the whole point of using enums was to avoid caring about fixed
numeric values, but well. To be more precise, what I don't get is that when
I move the BRIDGE_XSTATS_STP definition *after* BRIDGE_XSTATS_PAD, the STP
xstats don't show up anymore in iproute2.


Thanks,

	Vivien
