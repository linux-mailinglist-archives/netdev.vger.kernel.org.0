Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14224428C3
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 08:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhKBHrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 03:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230455AbhKBHq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 03:46:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E02B60F70;
        Tue,  2 Nov 2021 07:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635839062;
        bh=tnLzLFQaUkJ5kBgfVKqw+fnc0hHO1cfgegJKsMn5wxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LrJsMybh4evPbgrE6kgakGzheO2yiFhYEKyV86MOQBwDsyHd6ZZ7mOuf1aJbajnSE
         qdjq+lFkWsDcR1Itzb6BhlOmu+50ixPMLiuEaN5SOlRQVajJwssWe8lgL0D/EeC+Wh
         53hxhJacUQ61VjENePeNz93nZRfPd4p74sg3D4FmsNn/0XPlA2y4TC9PcXTncij4h0
         IT4GIYQTct7fD3w9N0+RqkhsXtvGLjy53ni/ESTqdEmSGMGFdXU7bzHSGEC2k4ecz6
         C+3n3F/yShA7uKZFhK8XqzDOnhdCBwf8vN0AYTj9Klc0dq1/9Qik6oEYlVkcJiaDnR
         z2h+f2ARbZgOA==
Date:   Tue, 2 Nov 2021 09:44:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <YYDsUbGnxxt0TzsX@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
 <YX5Efghyxu5g8kzY@unreal>
 <CAKOOJTze6-3OgNsoJYb5GuDOQAnYJfGkbsas58ek64g+eEn3iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTze6-3OgNsoJYb5GuDOQAnYJfGkbsas58ek64g+eEn3iw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 01:04:03PM -0700, Edwin Peer wrote:
> On Sun, Oct 31, 2021 at 12:23 AM Leon Romanovsky <leon@kernel.org> wrote:
> 
> > The average driver author doesn't know locking well and won't be able to
> > use devlink reference counting correctly.
> 
> I think this problem largely only exists to the extent that locking
> and lifecycle requirements are poorly documented. :P

I'm talking about general locking concepts that are perfectly documented
and still people do crazy things with it. :)

> 
> Regards,
> Edwin Peer
