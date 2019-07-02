Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6467B5D983
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfGCAqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:46:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35603 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfGCAqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:46:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so252461pgl.2
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FYV8V46zx6f8bx+FqomXcdEZJHsi2RbZW7Pq48ylEQc=;
        b=TJtsC4opaO+Vk5mX74aA67XC+WaFhWfzpcpWKzGoaJsaXTMIryzwP0yh2eP8Jcp7cZ
         IKPg9ivMLFVzYcgDaHxwvmP4e0zBQCpMziamvV+Toz2SPh6GhZd5i8S9E43U+vB7LOMY
         OKWCB+7Bwu/I3tbTW7/xdJ7Si3Su8Fc/y/D8XgvM2OOH/oBhKGls6EJ35aG2bub246vd
         Aiq8trLdgBxN56X/UJ3Xgr1UIHBCKT8Dp0RddN+xPwX+Ke1ebzcvPCK08tUnA4oC4e6z
         XMOrIVD1clIUtYEw5FEJaH5LUI33M3plOrCgnDZZ+arY+4Ua1XayKw/EZJgv4PgLEF9F
         auOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FYV8V46zx6f8bx+FqomXcdEZJHsi2RbZW7Pq48ylEQc=;
        b=GR7W7akvFZOoIb5cl17B46L/zCFeoTtOQITZDHtv/LLYXPX1lYu9Wj2rnqarjksg6C
         Yh31c9QbPwgAHkZU7C4OEUPrUR30wo0cIo/j2SW6pNYcyug7qSaH93LUqNtDXUYL5C9o
         UYIdRhS0+OXPb+V/hcNp3F1ugW7Yrot9sTgPKAPNLkzZTX59BhtBnyLPmLF98NvVwtTW
         DwNYJCTL/jM9pMnGbcmQsZtgV3oK2V451g3A/RhAdePZNmlGjGIeOqVA7bWhSJK9NUFa
         axD6aH4SkvCyscGbd+BeFvwPz/1nTY5/lhUkM8arN9DFevJoFwspPQo8r0e/6VRa4KxB
         fo2w==
X-Gm-Message-State: APjAAAUkKybXydqbI9pUha61ixXs3cUc4mGhF41KGHkNi38ywSV/5Wl7
        o54lgcpY/L1yDI07jRtRQa9nl6QAvnY=
X-Google-Smtp-Source: APXvYqwVVwbNknDjtrCa7LttNJuSM0YQzdqG2vj9JX9q3mnqGDOojwI7oUK5mbE30tZbHCkMT1Lx3w==
X-Received: by 2002:a17:90a:f491:: with SMTP id bx17mr8373637pjb.118.1562105664831;
        Tue, 02 Jul 2019 15:14:24 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 85sm122406pgb.52.2019.07.02.15.14.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 15:14:24 -0700 (PDT)
Date:   Tue, 2 Jul 2019 15:14:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: don't warn in inet diag when IPV6 is disabled
Message-ID: <20190702151422.6b2685f4@hermes.lan>
In-Reply-To: <20190702.142347.1440800997923616328.davem@davemloft.net>
References: <20190701152303.4031-1-stephen@networkplumber.org>
        <20190702.142347.1440800997923616328.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 02 Jul 2019 14:23:47 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <stephen@networkplumber.org>
> Date: Mon,  1 Jul 2019 08:23:03 -0700
> 
> > @@ -19,9 +19,11 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
> >  {
> >  	if (r->sdiag_family == AF_INET) {
> >  		return &raw_v4_hashinfo;
> > -#if IS_ENABLED(CONFIG_IPV6)
> >  	} else if (r->sdiag_family == AF_INET6) {
> > +#if IS_ENABLED(CONFIG_IPV6)
> >  		return &raw_v6_hashinfo;
> > +#else
> > +		return ERR_PTR(-EOPNOTSUPP);
> >  #endif
> >  	} else {
> >  		pr_warn_once("Unexpected inet family %d\n",  
> 
> Let's make some consistency in this area please.
> 
> The inet_diag code returns -EINVAL, and that's been that way forever.
> It also doesn't print a weird warning for unexpected sdiag_family
> values outside of AF_INET and AF_INET6.
> 
> That's been that way for so long that's probably the behavior to
> revolve everything around.
> 
> Therefore, please just get rid of the warning message instead of
> all of these other changes.
> 
> Thank you.

Sure, that makes sense.
