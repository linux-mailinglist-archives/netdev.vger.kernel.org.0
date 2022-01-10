Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85920488ECA
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 03:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbiAJC47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 21:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiAJC47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 21:56:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E7BC06173F;
        Sun,  9 Jan 2022 18:56:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3056EB8108B;
        Mon, 10 Jan 2022 02:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB512C36AEB;
        Mon, 10 Jan 2022 02:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641783415;
        bh=aOppgOK3k7neJytZGIe5uHUWHgsOGEDNs7FDSxRg9xY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=um/wJXdVXVxp+wnG+JVDy9NIdH88TSGHrlH8ztmCdmexmhpoGQgwDmijePUMIxJZJ
         F1ZvPeT9WTj1VlZKy6rPx3/EiTbbEtmovizjAsSFQHkf/aCdCY3e2h3cM8CLcU8OyM
         bsKYTHadGuogBEoKIIcHyhmKgCoZjFqnoci6yKLn2g48Sifkl+FmHxbNBNirbljTKm
         HsZXd378WZCa21iUUkaad/KfeiMATrDI8ZYICrWsKvARyAgrTJU27QPLMyQsM3j2Ni
         gi+WXw+SHhDyuQkhmaX9HmzZyaCs+END0NqKG/XgytudaVdEAsYbXQnqtc0JwZSUnP
         2BpSEjUmJMF6A==
Date:   Sun, 9 Jan 2022 18:56:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Subject: Re: pull request: bluetooth 2022-01-07
Message-ID: <20220109185654.69cbca57@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CABBYNZJ3LRwt=CmnR4U1Kqk5Ggr8snN_2X_uTex+YUX9GJCkuw@mail.gmail.com>
References: <20220107210942.3750887-1-luiz.dentz@gmail.com>
        <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6FFD2498-E81C-49DA-9B3E-4833241382EE@holtmann.org>
        <20220109141853.75c14667@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CABBYNZJ3LRwt=CmnR4U1Kqk5Ggr8snN_2X_uTex+YUX9GJCkuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 9 Jan 2022 18:46:05 -0800 Luiz Augusto von Dentz wrote:
> > You're right. I think our patchwork build bot got confused about the
> > direction of the merge and displayed old warnings :S You know what..
> > let me just pull this as is and we can take the fixes in the next PR,
> > then. Apologies for the extra work!  
> 
> Im planning to send a new pull request later today, that should
> address the warning and also takes cares of sort hash since that has
> been fixup in place.

But I already pulled..
