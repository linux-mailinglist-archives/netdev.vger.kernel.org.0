Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3661E3F0C88
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 22:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhHRUSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 16:18:36 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:36202 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhHRUSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 16:18:33 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 17IKHto2004917;
        Wed, 18 Aug 2021 22:17:55 +0200
Date:   Wed, 18 Aug 2021 22:17:55 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Oleg <lego12239@yandex.ru>, netdev@vger.kernel.org
Subject: Re: ipv6 ::1 and lo dev
Message-ID: <20210818201755.GA4899@1wt.eu>
References: <20210818165919.GA24787@legohost>
 <fb3e3ad3-7bc3-9420-d3f6-e9bae91f4cd@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb3e3ad3-7bc3-9420-d3f6-e9bae91f4cd@tarent.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 07:47:37PM +0200, Thorsten Glaser wrote:
> On Wed, 18 Aug 2021, Oleg wrote:
> 
> > I try to replace ::1/128 ipv6 address on lo dev with ::1/112 to
> > access more than 1 address(like with ipv4 127.0.0.1/8). But i get
> 
> AIUI this is not possible in IPv6, only :: and ::1 are reserved,
> the rest of ::/96 is IPv4-compatible IPv6 addresses.
> 
> I never understood why you'd want more than one address for loopback
> anyway (in my experience, the more addresses a host has, the more
> confused it'll get about which ones to use for what).

It's because you've probably never dealt with massive hosting :-)
Sometimes binding a full /24 (or smaller) on the loopback, be it
for listening addresses or to be used as sources to connect to
next hops, is extremely useful.

Willy
