Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3DB119FA7
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 00:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLJXvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 18:51:36 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38121 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJXvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 18:51:36 -0500
Received: by mail-pj1-f67.google.com with SMTP id l4so8097537pjt.5
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 15:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+5Sptn/EJCLk8CbSb48j9u+kGftjjr8NpHS2NItl0Cc=;
        b=iH1OLIdcvEw5exZBLBGuGH00+33PN+6aUbHE/KQMVvB8iUO3fNzyqmDsrEwFdAI88u
         ChRJGrKaaUp3kHZMDKA4j1rlqddj5M8+G5cHkj2P8aE0qImP/wgionyvVD8fViMmg3kh
         7PVr43Dd35KlRbiEQW7LhPtT0LPa12zbtIf57cGiJWoRmhFEsnxNVhkVML6i4OFwmWK4
         liZ25xtNiXf0q6ndySvDA9zeW3aZhnzRYP+PANc3ZZoUU2CiufYgNR22bx9lpY7u2p7k
         14qMmC8LDTscUbDwE4XqZ4FzyuU+S9QNehKDDR559EgsuntM06J6UO4m9Y4wORpIS5fQ
         /XDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+5Sptn/EJCLk8CbSb48j9u+kGftjjr8NpHS2NItl0Cc=;
        b=fexGbyiJTlJPKBJAbHJc7dKEehGarVk1XWRLJ5Qy7L9YEjH9/i8qb/lUomEqrMB591
         dss/08DNb1DHuclmoBTyDN7Do4bctmBFPnUePFBpl/XyfWpt8OBUx8yGycxkEJgv4/Lv
         5/iJiki9l1gvsnhjwZ0F5TVJoTsur8O/m6+pqy4S+t3eCBhi+RzQjoNSrh7G64mY8KiZ
         rZVJXk/xRxvA4hLlN9MqrI4yhOx+6uV2AV9CIvFOR0/Ty7fB7UKeDiiqbYlZKtH6LmSe
         Bl9LWKKMuPrbjG8RoR1EmU/iY58a1RjZeE8y3ObhJZvzJ6QwIxdU7LzzVnQdnpTl/pfG
         /bCQ==
X-Gm-Message-State: APjAAAUXnk0oFtc/xzD2GWpD+X9dnwnClapx1A9L8YVecSXnUXQezQZ2
        eA1QpUvtnyhrspZLZiwsohSmykNg
X-Google-Smtp-Source: APXvYqwt6N5p0hATlwEYX8U4io7UbeElPLV1dDgHooVNF1eeZQy7ikk6c0Sp5G4RC2pDEFgacWPevQ==
X-Received: by 2002:a17:902:7b88:: with SMTP id w8mr73099pll.197.1576021895633;
        Tue, 10 Dec 2019 15:51:35 -0800 (PST)
Received: from martin-VirtualBox ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id x11sm159614pfn.53.2019.12.10.15.51.34
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Dec 2019 15:51:35 -0800 (PST)
Date:   Wed, 11 Dec 2019 05:21:32 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Jiri Benc <jbenc@redhat.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        scott.drennan@nokia.com, martin.varghese@nokia.com
Subject: Re: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2
 tunnelling
Message-ID: <20191210235132.GA2687@martin-VirtualBox>
References: <cover.1575964218.git.martin.varghese@nokia.com>
 <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
 <20191210161122.0c329d9b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210161122.0c329d9b@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 04:11:22PM +0100, Jiri Benc wrote:
> On Tue, 10 Dec 2019 13:46:41 +0530, Martin Varghese wrote:
> > +static int push_ptap_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> > +static int ptap_pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> 
> The names are inconsistent (*_ptap_mpls vs. ptap_*_mpls). Otherwise,
> this looks good to me.
>

Thanks Jiri 

> 
