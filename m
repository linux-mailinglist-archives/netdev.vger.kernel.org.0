Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F598432602
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhJRSJG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 Oct 2021 14:09:06 -0400
Received: from lixid.tarent.de ([193.107.123.118]:34673 "EHLO mail.lixid.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232349AbhJRSI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 14:08:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 6CD321410ED;
        Mon, 18 Oct 2021 20:06:46 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id 1BSVcvwJxPi5; Mon, 18 Oct 2021 20:06:40 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 4D56314108F;
        Mon, 18 Oct 2021 20:06:40 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id EB45D1C1730; Mon, 18 Oct 2021 20:06:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id E84F41C16DF;
        Mon, 18 Oct 2021 20:06:39 +0200 (CEST)
Date:   Mon, 18 Oct 2021 20:06:39 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     netdev@vger.kernel.org
Subject: Re: Intro into qdisc writing?
In-Reply-To: <d14be9a8-85b2-010e-16f3-cae1587f8471@gmail.com>
Message-ID: <e792d595-b68-30c8-506f-848874aca77@tarent.de>
References: <1e2625bd-f0e5-b5cf-8f57-c58968a0d1e5@tarent.de> <d14be9a8-85b2-010e-16f3-cae1587f8471@gmail.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021, Eric Dumazet wrote:

> https://legacy.netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-BPF

This apparently landed in 4.20, I need to support buster (4.19) as well
though, so (independent of the other concerns) it’s out.

bye,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
