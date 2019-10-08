Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C08DD03B4
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfJHXA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:00:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727363AbfJHXA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:00:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570575654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8G4W4L+NNUOSFMXU/18cQJQxA2iOZClvy3/EKxaJUEQ=;
        b=FB2806APLl9hby1WlvLkBLnfQK17vDuq6qL9F2Twldj6A8n6vLBI7hV3dYKfLjPZRbd2kO
        AhyJQMEBcBvwYNkW+EfmIFEaB9NZiSD+mFbMhsYtrflvr6hXRBfEfQfccRkJl/0z0Llsj1
        zhF5cHiKtHcXjoThzs6mV4m5mcFjhoo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-vzQxG4XIOBCLUVuKbxDk6w-1; Tue, 08 Oct 2019 19:00:51 -0400
Received: by mail-wr1-f72.google.com with SMTP id n18so176974wro.11
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=skNsq4Qi3roSRViPjBQkj7WI1BOuSmoi2Xgm4BkUkV0=;
        b=ahPx343n29XPt9pnySau+9+Zn4yMTdbk7gDBkgoNSmAuj7PzJtkrZ3iKAJWWrLq2aI
         vtCyvb4b1xWrNXzO23JEB7r6WWKVeR4V4LQX8RcKXIY0rx7uLqmIkaYgpkO54qjcjBra
         jW2e8QumBc234qCUX00BdFxVuyYoHcZcBw+XU/KAJeLvzl2Mxqu1GajU9POaMcP89li1
         6et691FYzGAqi0/Mdyj8jD16NLS1t6uvTnxWd5DrwY9uIRGaDhPjyuOjAb4XW/7z+XBO
         Qt9yedIeFTI+hoOy2Vv5Fpuo1TUhd2FO7lufojZb5/qt/PKyQNpzYCRDtUcU8n6ttnrs
         dKLg==
X-Gm-Message-State: APjAAAXconZZcsmQKUwB6Hxp8C9hHRryNYhR9G4aJUe38ovlFsskAqyZ
        veGh/aVtpOBeg/WHl7169W26qIwel9K+X4lHYXlzJFke90/ImlIdGcB8bV96B+ODhRm7KDi1wyh
        X4/15EK1jqaTtvy+d
X-Received: by 2002:adf:e6cb:: with SMTP id y11mr239956wrm.174.1570575650233;
        Tue, 08 Oct 2019 16:00:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwIDXBj5eLi+xJHwVG8gnvKWra/Rx2+UjFSUBXtOlmFkD4gG44+bRs0kna/3T/l11rLJyCqJg==
X-Received: by 2002:adf:e6cb:: with SMTP id y11mr239945wrm.174.1570575650005;
        Tue, 08 Oct 2019 16:00:50 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id m7sm211775wrv.40.2019.10.08.16.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 16:00:49 -0700 (PDT)
Date:   Wed, 9 Oct 2019 01:00:47 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Ease nsid allocation
Message-ID: <20191008230047.GA4779@linux.home>
References: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
 <20191001.212027.1363612671973318110.davem@davemloft.net>
 <30d50c1d-d4c8-f339-816b-eb28ec4c0154@6wind.com>
 <20191003161940.GA31862@linux.home>
 <8eec279e-c617-b2a5-e802-4b6561cd2f94@6wind.com>
MIME-Version: 1.0
In-Reply-To: <8eec279e-c617-b2a5-e802-4b6561cd2f94@6wind.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: vzQxG4XIOBCLUVuKbxDk6w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 05:45:22PM +0200, Nicolas Dichtel wrote:
> Le 03/10/2019 =E0 18:19, Guillaume Nault a =E9crit=A0:
> [snip]
> > Why not using the existing NLM_F_ECHO mechanism?
> >=20
> > IIUC, if rtnl_net_notifyid() did pass the proper nlmsghdr and portid to
> > rtnl_notify(), the later would automatically notify the caller with
> > updated information if the original request had the NLM_F_ECHO flag.
> >=20
> Good point. Note that with library like libnl, the auto sequence number c=
heck
> will fail (seq number is 0 instead of the previous + 1) and thus must be =
bypassed.
>
Well, it's up to the caller of rtnl_notify() to build a netlink message
with proper sequence number. Currently, rtnl_net_notifyid() always sets
it to 0. That's probably why the libnl test fails.

