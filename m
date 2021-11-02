Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945FA443161
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 16:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhKBPSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234220AbhKBPSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 11:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD8C060F36;
        Tue,  2 Nov 2021 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635866169;
        bh=2RJfzdyUckKKdYNbp4YYZ2p6D908APIJYcYYBYyFXhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d4O1gBGlgsqkjZutMpy3JzxA1yNy7ivrdPoGY9J5lzUz/u3BSaSM8jAmovb/SCjxt
         xWL5GZLxtUGPVik5shN0kah/VMMe5b9aSYiikWgGT/vHrBqzOSJ8oWaTeuYW8aW4gG
         zT3XRAZSbFzJ8toNxFdJawq3OxXPf6fyKCI438GxVxnMbIlsh+FMNnA5534hYGlIj6
         yYpL1u0ab/nOciOoeRm5NLfjRvrXJzZL+aMS9igXoP25W2w1/Inuvhk/HS3e19XSqj
         G/NEezLvudo0LTGC8G5nQMEJqs1Gsc+BAGFoj3zQHfiMDRj1LeNqu7hHSfMTnCGkCZ
         KwtAfRy0NW8ZQ==
Date:   Tue, 2 Nov 2021 08:16:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <20211102081606.5bc39f21@kicinski-fedora-PC1C0HJN>
In-Reply-To: <YYDsUbGnxxt0TzsX@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
        <YX5Efghyxu5g8kzY@unreal>
        <CAKOOJTze6-3OgNsoJYb5GuDOQAnYJfGkbsas58ek64g+eEn3iw@mail.gmail.com>
        <YYDsUbGnxxt0TzsX@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 09:44:17 +0200 Leon Romanovsky wrote:
> On Mon, Nov 01, 2021 at 01:04:03PM -0700, Edwin Peer wrote:
> > On Sun, Oct 31, 2021 at 12:23 AM Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > The average driver author doesn't know locking well and won't be able to
> > > use devlink reference counting correctly.  
> > 
> > I think this problem largely only exists to the extent that locking
> > and lifecycle requirements are poorly documented. :P  
> 
> I'm talking about general locking concepts that are perfectly documented
> and still people do crazy things with it. :)

Yet you seem to be pushing for drivers to implement their own locking.
