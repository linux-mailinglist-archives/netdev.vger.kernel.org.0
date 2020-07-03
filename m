Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7084321320C
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgGCDLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGCDLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 23:11:01 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2FCC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 20:11:00 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 207so13200391pfu.3
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 20:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GWjZXNkMOQwfMZqFDwkiG9PIQpQCmCcIYE1VmdShbZI=;
        b=JbH30BOt2vI2oMZkASodXvX+qzBzUddSG8XnBh1mw0vAK5nRtSo7rAk2qYFCxxQblG
         2xfjxAMEm7DmCO1LUNmab3hkXAy8PYzfI7cP0CSJLe+nJdbieUqS3/S3GhN8G2nbMf1m
         cMpGT8lIQFh/KXHtXSw858G2XpTYzNZafLhJu9dGj/x87icUxwPKr6JSoKoCsoHM19bL
         Q7cnAHSK3YAxko+y9m0VNT6KTmmQKpQ4b7PFhYSljC0Jn0FvASf0jfe7EkT+BEyeXkUX
         ojCqnxtUjyPwcWrXjvRTm7dCeNGQCpUbAeBR+alF1j2PTr+714Ud6G0bAXSzwcEd8m1f
         4OKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GWjZXNkMOQwfMZqFDwkiG9PIQpQCmCcIYE1VmdShbZI=;
        b=jzSoJcF4ut5f2KEqNjONyfa7ylDhsFBwCke2TfvW8YQAqwt82IfchP687KIBHSpfS6
         ILUkq3StLXUyZyiqgfgVmBD2NTLRRNlWvMX8FKj195zSxu5KKnGOphcn9SI4Rkym3txx
         BEUEyG/wXEYYLuBmAfVMgvCH263oVTsqooVJC9L1zUm5HjI/g5Mk+af+F3wtShAeoo3M
         9iVvRKoh6DZ5Au4EnvWgtGJBoz4ZECDYmoYqECgF1WghJr5u47+1v/XyzsrLGzxBzpiR
         Xf6EYVqDkq8/ULD9jZHlTermaY5jQa9E7CQVXkQi3ubrzQnecv8a8h0ImDnVHNaSRxN8
         yT0Q==
X-Gm-Message-State: AOAM530qfOvD6JIW0igURZTONm8wRCzKdvbQdfKYNgGvxif0KugLLCoa
        WzrAxejQ45WLLKkCcGLmojXyEqaj
X-Google-Smtp-Source: ABdhPJxg8+7dKBZIcFSpEHDq2X1BoYHvjmkOSB5wii880GmetuC+qX0rIQmlw0RDV07mP75jbWSJhA==
X-Received: by 2002:a63:ee48:: with SMTP id n8mr27314864pgk.292.1593745860139;
        Thu, 02 Jul 2020 20:11:00 -0700 (PDT)
Received: from martin-VirtualBox ([117.202.89.119])
        by smtp.gmail.com with ESMTPSA id q36sm9003760pjq.18.2020.07.02.20.10.58
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 02 Jul 2020 20:10:59 -0700 (PDT)
Date:   Fri, 3 Jul 2020 08:40:56 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip link: initial support for bareudp devicesy
Message-ID: <20200703031056.GA3079@martin-VirtualBox>
References: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
 <20200702091539.GA2793@martin-VirtualBox>
 <20200702095746.GA3913@pc-2.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702095746.GA3913@pc-2.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 11:57:46AM +0200, Guillaume Nault wrote:
> On Thu, Jul 02, 2020 at 02:45:39PM +0530, Martin Varghese wrote:
> > On Wed, Jul 01, 2020 at 09:45:04PM +0200, Guillaume Nault wrote:
> > > +		} else if (matches(*argv, "ethertype") == 0)  {
> > > +			NEXT_ARG();
> > > +			check_duparg(&attrs, IFLA_BAREUDP_ETHERTYPE,
> > > +				     "ethertype", *argv);
> > > +			if (ll_proto_a2n(&ethertype, *argv))
> > Does this function takes care of mpls proto names ?
> > 
> > The original idea of bareudp is to allow even reserved ethertypes.Hence i think we
> > must take ethertype in hex aswell
> 
> ll_proto_a2n() handles both symbolic and numeric ethertypes.
>
Yes it works. 
> > > +				invarg("ethertype", *argv);
> > > +		} else if (matches(*argv, "srcportmin") == 0) {
> > > +			NEXT_ARG();
> > > +			check_duparg(&attrs, IFLA_BAREUDP_SRCPORT_MIN,
> > > +				     "srcportmin", *argv);
> > > +			if (get_u16(&srcportmin, *argv, 0))
> > > +				invarg("srcportmin", *argv);
> > > +		} else if (matches(*argv, "multiproto") == 0) {
> > > +			check_duparg(&attrs, IFLA_BAREUDP_MULTIPROTO_MODE,
> > > +				     *argv, *argv);
> > > +			multiproto = true;
> > > +		} else if (matches(*argv, "nomultiproto") == 0) {
> > do we need nomultiproto flag. Is it redundant
> 
> It allows users to exlicitely disable multiproto without having to rely
> on default values. Also nomultiproto appears in the detailed output, so
> it should be usable as input.
> 
ok
> > > +	if (tb[IFLA_BAREUDP_MULTIPROTO_MODE])
> > > +		print_bool(PRINT_ANY, "multiproto", "multiproto ", true);
> > > +	else
> > > +		print_bool(PRINT_ANY, "multiproto", "nomultiproto ", false);
> > Comments from stephen@networkplumber.org on the first version patch is given below
> > 
> > One of the unwritten rules of ip commands is that the show format
> > should match the command line arguments.  In this case extmode is
> > really a presence flag not a boolean. best to print that with
> > json null command.
> 
> The detailed output prints either "multiproto" or "nomultiproto". Both
> keywords are accepted as configuration input. I can't see any deviation
> from the unwritten rule here.
> 
ok
