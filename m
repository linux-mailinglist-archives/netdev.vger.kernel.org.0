Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3349239C08
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHBUxj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 2 Aug 2020 16:53:39 -0400
Received: from lixid.tarent.de ([193.107.123.118]:34596 "EHLO mail.lixid.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbgHBUxj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 16:53:39 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2020 16:53:38 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 3295D140C07;
        Sun,  2 Aug 2020 22:44:23 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id VdMdxHdN2FNR; Sun,  2 Aug 2020 22:44:16 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 492EF1402C8;
        Sun,  2 Aug 2020 22:44:16 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id EF8FD5208EA; Sun,  2 Aug 2020 22:44:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id EC3455204A5;
        Sun,  2 Aug 2020 22:44:15 +0200 (CEST)
Date:   Sun, 2 Aug 2020 22:44:15 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
X-X-Sender: tglase@tglase-nb.lan.tarent.de
To:     Ben Hutchings <ben@decadent.org.uk>
cc:     966459@bugs.debian.org, netdev <netdev@vger.kernel.org>
Subject: Re: Bug#966459: linux: traffic class socket options (both IPv4/IPv6)
 inconsistent with docs/standards
In-Reply-To: <e1beb0b98109d90738e054683f5eb1dd483011dd.camel@decadent.org.uk>
Message-ID: <alpine.DEB.2.23.453.2008022243310.15898@tglase-nb.lan.tarent.de>
References: <159596111771.2639.6929056987566441726.reportbug@tglase-nb.lan.tarent.de>  <e67190b7de22fff20fb4c5c084307e0b76001248.camel@decadent.org.uk>  <Pine.BSM.4.64L.2008021919500.2148@herc.mirbsd.org>
 <e1beb0b98109d90738e054683f5eb1dd483011dd.camel@decadent.org.uk>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Aug 2020, Ben Hutchings wrote:

> The RFC says that the IPV6_TCLASS option's value is an int, and that

for setsockopt (“option's”), not cmsg

> No, the wording is *not* clear.

Agreed.

So perhaps let’s try to find out what’s actually right…

Thanks for helping,
//mirabilos
-- 
tarent solutions GmbH
Rochusstraße 2-4, D-53123 Bonn • http://www.tarent.de/
Tel: +49 228 54881-393 • Fax: +49 228 54881-235
HRB 5168 (AG Bonn) • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg
