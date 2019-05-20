Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FFD22E05
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 10:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbfETIKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 04:10:08 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:38309 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730045AbfETIKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 04:10:08 -0400
Received: by mail-pl1-f177.google.com with SMTP id f97so6340460plb.5
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 01:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gQkNzRm6X1JfoZN8498JaZxcKv6dV7q/RTuKdIJWNDk=;
        b=jpmS/coZsRqH7dyxXavonU7oSamQROVq52rQ4DeHQCTghf/QE3v9idKusZTCmAxY8G
         aPe7ZwkK9/PLPzGaS7szfYnr61JFZI6EqNjG3V+0y9hm6wHr1eyB2aZ2RbIXh84ZZ3Kv
         aAt7iiCrF03omLHbcvuvN/CJxoucPXg1wMfrUNTX3vXD5cHiSSJvNBEZ8/Nb0kOCClTr
         F/DxjaESHNWnAnvayFcuccX/kPywnHwDmSy+QgLO89EtjrpBV7/+2F6ZCZQX2eCi0DBg
         jXcXWduh5J6fBI7oDnrFnOwSuyHoIEWGzRQ4H/NRtnguh1PRJb1CLplUv4doV9VqRdMf
         PjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gQkNzRm6X1JfoZN8498JaZxcKv6dV7q/RTuKdIJWNDk=;
        b=tQU2/bt8b/4kEuzaxBwCvRY35JU+OrXk2a8UFmsJSU0weY+jTmZAjj6O3SSKBzgmYB
         InRYxPSqFdcvu/5SaywGog9TBrC3g/YpAMQHK46v9BK5YDTqm2mNlSfigCN5IthjwUOu
         r8ayxgG/JaijyrIAg5+n2ndkIvfWf/vseqMhtB1vM/Db4bxHKrng9jREHQuzM5bb8nhA
         9hzwKpXs8gyy2DPKOJXdqlr1m3FBtq7ornAipAA2cW6MZDPkiFGZzBTrA1akG96w9tGG
         TcPaYZTXKR6tNx+7mb2nnnXMgPLLZvRGvCm5oXm9PZvawPjih2R3PGvaU6aazdsduJ1T
         DNgA==
X-Gm-Message-State: APjAAAW6K459K7iyuxtNdR68bDSX2Chv9Leu+Vt6MUnHvXL31lYUSlWm
        OmgQc9nBCU4XbuO+la1YECe5DtVZVJg=
X-Google-Smtp-Source: APXvYqz8iFjzWHHD8LmCgyz8rgU5l5QrrHTITg95hn/0ckkqiAWWGsEUEmaByuOjoBVKGVE5bAehcg==
X-Received: by 2002:a17:902:9884:: with SMTP id s4mr75740141plp.179.1558339807791;
        Mon, 20 May 2019 01:10:07 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.64])
        by smtp.gmail.com with ESMTPSA id w6sm18089070pge.30.2019.05.20.01.10.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 01:10:07 -0700 (PDT)
Date:   Mon, 20 May 2019 16:09:58 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin Kealey <martin@kurahaupo.gen.nz>
Cc:     netdev@vger.kernel.org
Subject: Re: patch for iproute2
Message-ID: <20190520080958.GV18865@dhcp-12-139.nay.redhat.com>
References: <alpine.DEB.2.00.1905181350500.8326@feathers.ext.sig.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1905181350500.8326@feathers.ext.sig.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 01:52:36PM +1000, Martin Kealey wrote:
> 
> Hello iproute2 maintainer.
> 
> (Sorry, I don't know your name)
> 
> I recently noticed a discrepancy: the internal documentation for the ip
> command says that an *RTT* value can be sufficed with "s" (second) or "ms"
> (millisecond), but in practice no suffix of any kind is accepted.
> 
> I found that that commit 697ac63905cb5ca5389cd840462ee9868123b77f to
> git://git.kernel.org/pub/scm/network/iproute2/iproute2.git caused this
> regression; it was over-zealous in disallowing non-digits in *all* contexts
> where a number is expected.
> 
> As far as I can tell, this does not have any kernel-related impact, merely
> it affects what arguments are accepted by the "ip" command.
> 
> I have a suitable patch for fixing this; what is the procedure for
> submitting it?

It's the same process with submitting patch to netdev[1]. If you are familiar
with git. Just format a patch and send it to detdev@. Be careful with the
subject prefix, Signed-off info and fixes tags.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/tree/Documentation/networking/netdev-FAQ.rst#n257

Thanks
Hangbin
