Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859C3292857
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 15:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgJSNjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 09:39:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727796AbgJSNjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 09:39:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603114790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZfVuaGzIPbXuxbuS2tqkcBD53V5zAA46m/GFS3P7v8k=;
        b=DbAB3HXtIPFryHPBDeJZGM1Zvh7Mm1zARZGS4VivEHLyJmwtIp0Y8ugo/ty0WTZ0sKLN15
        Wjo8hI7j7f86BMXk6R2pk54R/orgzOTSBFu27oPSy7bKkXcI39tKO9uz3Ubbs06o1EOF5/
        PAU0EKFVQjjS3K+3I4XjtpaZaUvBAyU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-PKoHPYCvOgq6Ck5lsc0oSQ-1; Mon, 19 Oct 2020 09:39:48 -0400
X-MC-Unique: PKoHPYCvOgq6Ck5lsc0oSQ-1
Received: by mail-wr1-f69.google.com with SMTP id 47so7440861wrc.19
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 06:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZfVuaGzIPbXuxbuS2tqkcBD53V5zAA46m/GFS3P7v8k=;
        b=k3R5Lu1lVyXGGEzCAa7gGisvkgYClEYK4yy9aAmakmr/xaU/XUw36NtKLRg4M4FdcD
         /YOmWjILson+V26S15gLCYWBp7YvSbpQj+krDMZ9+pabFHH+uxNjI1meA6cI71AuEG/D
         BlpC53UIO2bjs8Ci//6Jt8mj5b4OSUt0lhh75Tr+XFjWsUo4U7iHJMjHDj4VI3nIgPk3
         u+dcf7HJGaNqSbZZEuQj9Dol3NvL7zVaAt26war4yIEaj/HObGLjTbeQOt1+/nzS7dk1
         G3lsZX0+2RcU0I0xZlulhuz+yYiEt/oOPXQeFo0bFS+Qq+PzY7b948vhsFvu4iCpL/++
         QmuA==
X-Gm-Message-State: AOAM532zXGg7v0YVZmx/cqs+Pc8AoQEutOra7nLdjeD2L/OID2nD33Mt
        I5sMJ4IMydfoErKJmLp90ZQY6tVJO4jNKZLOcfx3DKYtZLkUPU5Nj6jaJ7v6i416axlhytPm0q+
        cZGuj8E9Yjp4G1f88
X-Received: by 2002:a1c:f719:: with SMTP id v25mr17591763wmh.186.1603114787852;
        Mon, 19 Oct 2020 06:39:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKvOFfkPBLSAQwXjf2PJGyW7v2RuOH8jFvGr9iqjzjqn4nKcdJDvXm8x8e8o7M4YFdLJ35TQ==
X-Received: by 2002:a1c:f719:: with SMTP id v25mr17591754wmh.186.1603114787689;
        Mon, 19 Oct 2020 06:39:47 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id c185sm31830wma.44.2020.10.19.06.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 06:39:46 -0700 (PDT)
Date:   Mon, 19 Oct 2020 15:39:45 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
Subject: Re: [PATCH iproute2-next 2/2] m_mpls: add mac_push action
Message-ID: <20201019133945.GA634@pc-2.home>
References: <cover.1602598178.git.gnault@redhat.com>
 <622d70e7bb6158c6f207661dea8c47e129f16107.1602598178.git.gnault@redhat.com>
 <5804f20b-b8ea-9f02-7aac-129d35f46a2c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5804f20b-b8ea-9f02-7aac-129d35f46a2c@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 09:23:52AM -0600, David Ahern wrote:
> On 10/13/20 8:32 AM, Guillaume Nault wrote:
> > @@ -41,12 +44,12 @@ static void usage(void)
> >  
> >  static bool can_modify_mpls_fields(unsigned int action)
> >  {
> > -	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MODIFY;
> > +	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MAC_PUSH || action == TCA_MPLS_ACT_MODIFY;
> >  }
> >  
> > -static bool can_modify_ethtype(unsigned int action)
> > +static bool can_set_ethtype(unsigned int action)
> >  {
> > -	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_POP;
> > +	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MAC_PUSH || action == TCA_MPLS_ACT_POP;
> >  }
> >  
> >  static bool is_valid_label(__u32 label)
> 
> nit: please wrap the lines with the new action.

Will do.

> Besides the nit, very nice and complete change set - man page, help, and
>  tests.

Thanks!

