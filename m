Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7781DB1B5
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 18:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439082AbfJQQAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 12:00:38 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41533 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436580AbfJQQAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 12:00:37 -0400
Received: by mail-pg1-f195.google.com with SMTP id t3so1601086pga.8
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 09:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=UN8JPWFL62rSjf9oi4n8jD/HeiVUzFcQ2Ud+GCWyi5o=;
        b=lTbhnzh/kXIGVWLcyf+U2Z6J2IR28rXZcgVUl708OxI5AwoXiIuGKN7V0VzzM9ygpC
         84QRZ9IKQL/QNjw3BDLsytwNFgISJcRveM+YhddoHWWXzmdB665sIAv7yHuyAorAPnFS
         7H5GytsaC8BcJaEztvQtbdOqk3iOKGJUxhBWkhaSZHCeEaF90AQpilqjthdBL0+PGDbM
         NQYUPSm6xjKbjW5/+6EkPbVTfZZJ4az2R+I2xagdlki8BYbmyddGk4/X6YHUSHnV9beL
         rdZjTB3AujQc6WUgIyVBZomPQ20G5cq7pb1Lb+IfOAG+AGl4p8j0iPyTkm5BdLt/ecr3
         PuHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=UN8JPWFL62rSjf9oi4n8jD/HeiVUzFcQ2Ud+GCWyi5o=;
        b=iHCC5YWw4r82VAYKtl8M2MV2xj6OhTe1A5ogRfrRETFS+V/irHoIGey639duS0aebP
         eqwB7/p9lxeJ5apCNH5xdM2aS1pQlskOB0R7kit//Kvn2gFe0kkbQMKCVKzJveFTZZvJ
         wRHOdemA0n6L4T2WsogxrbWT3oQNjiI+zw54f2CDwX7fR3OTlHCXJSMDJ/A94zVaGYqM
         x5lAN5roV//GziT4g/sCjhrW5ltCyKR/vDRzwdjZk3GNlWUjS8Eyzv9YIKQkhYjCYqCG
         Z18A6bneW9olCnzd1tzQZcW9KB9agWBlluj9uXFM8GiqNXx0c9tqwwfxSJEywOXg6IgC
         ia9A==
X-Gm-Message-State: APjAAAWmu+ii8N0Kjd8XFVxj9CM1qRImkv6zPl0Qw4Az8WbtkKlNuj3+
        qua9JwZXyrEwEaLaRzzgZTE7o2CslrA=
X-Google-Smtp-Source: APXvYqzgyC1wI+J8PP1KHlh4Ur9eFHC/dDfXGVV975j8a+YK66gfH9bEXLFCSo6+f6Y29N1d4Kzz+g==
X-Received: by 2002:a17:90a:bd82:: with SMTP id z2mr5350622pjr.15.1571328034927;
        Thu, 17 Oct 2019 09:00:34 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id q33sm3711803pgm.50.2019.10.17.09.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 09:00:34 -0700 (PDT)
Date:   Thu, 17 Oct 2019 09:00:31 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, steffen.klassert@secunet.com
Subject: Re: [PATCH net-next v4 0/6] ipsec: add TCP encapsulation support
 (RFC 8229)
Message-ID: <20191017090031.44a5822e@cakuba.netronome.com>
In-Reply-To: <20191017143314.GA621051@bistromath.localdomain>
References: <cover.1570787286.git.sd@queasysnail.net>
        <20191014.144327.888902765137276425.davem@davemloft.net>
        <20191015082424.GA435630@bistromath.localdomain>
        <20191015114657.45954831@cakuba.netronome.com>
        <20191017143314.GA621051@bistromath.localdomain>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 16:33:14 +0200, Sabrina Dubroca wrote:
> > But can there be any potential issues if the TCP socket with esp ULP is
> > also inserted into a sockmap? (well, I think sockmap socket gets a ULP,
> > I think we prevent sockmap on top of ULP but not the other way around..)  
> 
> Yeah, there's nothing preventing a socket that's already in a sockmap
> from getting a ULP, only for inserting a socket in a sockmap if it
> already has a ULP (see sock_map_update_common).
> 
> I gave it a quick test with espintcp, it doesn't quite seem to work: a
> sockmap program that drops everything actually drops messages, but a
> sockmap program that drops some messages based on length... doesn't.
> 
> Although, to be honest, I don't see a use case for sockmap on espintcp
> sockets.

Perhaps we could reject the espintcp ULP installation when sk_user_data
is present? Would that make sense?

> > Is there any chance we could see some selftests here?  
> 
> For espintcp? That's planned, I need to rework my test scripts so that
> they don't need human interaction, and turn them into selftests.
