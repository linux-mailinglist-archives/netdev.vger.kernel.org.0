Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8493F0A76
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhHRRsV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Aug 2021 13:48:21 -0400
Received: from lixid.tarent.de ([193.107.123.118]:52320 "EHLO mail.lixid.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhHRRsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 13:48:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 9BDAD140BB7;
        Wed, 18 Aug 2021 19:47:44 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id 0kEeqtMHrNMF; Wed, 18 Aug 2021 19:47:38 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 32BE4140978;
        Wed, 18 Aug 2021 19:47:38 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id DB8A35226D7; Wed, 18 Aug 2021 19:47:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id D855652238E;
        Wed, 18 Aug 2021 19:47:37 +0200 (CEST)
Date:   Wed, 18 Aug 2021 19:47:37 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Oleg <lego12239@yandex.ru>
cc:     netdev@vger.kernel.org
Subject: Re: ipv6 ::1 and lo dev
In-Reply-To: <20210818165919.GA24787@legohost>
Message-ID: <fb3e3ad3-7bc3-9420-d3f6-e9bae91f4cd@tarent.de>
References: <20210818165919.GA24787@legohost>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Aug 2021, Oleg wrote:

> I try to replace ::1/128 ipv6 address on lo dev with ::1/112 to
> access more than 1 address(like with ipv4 127.0.0.1/8). But i get

AIUI this is not possible in IPv6, only :: and ::1 are reserved,
the rest of ::/96 is IPv4-compatible IPv6 addresses.

I never understood why you’d want more than one address for loopback
anyway (in my experience, the more addresses a host has, the more
confused it’ll get about which ones to use for what).

bye,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

*************************************************

Mit dem tarent-Newsletter nichts mehr verpassen: www.tarent.de/newsletter

*************************************************
