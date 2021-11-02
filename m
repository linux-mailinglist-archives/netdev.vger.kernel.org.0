Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4309F4434DD
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbhKBRxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232865AbhKBRxU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 13:53:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E06261050;
        Tue,  2 Nov 2021 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635875445;
        bh=BQbxJlEEwSSAuHGm2VTxVGd2MAAp/bbOn10aYejbo20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eqsp1UPr33xX9Cp3ucdk7B1Bs08ndjIFfwzwVITHEJRTFsv7A7SVVfBfOevAF8VUZ
         THf8d1t06WZTsnKq9YyA58SHjODOEhIucTMEhN2cfXlHga09JshnP0IaUqQJMrq8Tk
         qfl+273N82xRnZj6tXBzm/LuaRShJiKKOqCK80u7aLj7IvnlgX7QmB/givC8ue9bJf
         iO88UiyXXJIbDjMM0zxAbtJZnSZRXCfRyLIXup+5fV8q9zpFAWVIySEVTphMvbsSgC
         TO5BR8FAyLMBasvAWyqtoLshn1z84+FSGbPEndTNTYpTBP5IjFjaWzeZrwpGaDRzTo
         PW/8SvUjmPHyQ==
Date:   Tue, 2 Nov 2021 19:50:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <YYF6cTbyXtrxNwwW@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
 <YX5Efghyxu5g8kzY@unreal>
 <CAKOOJTze6-3OgNsoJYb5GuDOQAnYJfGkbsas58ek64g+eEn3iw@mail.gmail.com>
 <YYDsUbGnxxt0TzsX@unreal>
 <20211102081606.5bc39f21@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102081606.5bc39f21@kicinski-fedora-PC1C0HJN>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 08:16:06AM -0700, Jakub Kicinski wrote:
> On Tue, 2 Nov 2021 09:44:17 +0200 Leon Romanovsky wrote:
> > On Mon, Nov 01, 2021 at 01:04:03PM -0700, Edwin Peer wrote:
> > > On Sun, Oct 31, 2021 at 12:23 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >   
> > > > The average driver author doesn't know locking well and won't be able to
> > > > use devlink reference counting correctly.  
> > > 
> > > I think this problem largely only exists to the extent that locking
> > > and lifecycle requirements are poorly documented. :P  
> > 
> > I'm talking about general locking concepts that are perfectly documented
> > and still people do crazy things with it. :)
> 
> Yet you seem to be pushing for drivers to implement their own locking.

It wasn't me who suggested to expose devlink internal locks and
reference counting to the drivers. In my implementation, drivers
don't need to manage devlink at all and we will be able internally
understand if lock is needed or not.

At least in theory, working to make it true.

Thanks
