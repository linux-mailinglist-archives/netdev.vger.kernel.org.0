Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAC216DA6
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 00:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfEGWvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 18:51:00 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:33492 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGWvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 18:51:00 -0400
Received: from nat-ies.mentorg.com ([192.94.31.2] helo=svr-ies-mbx-01.mgc.mentorg.com)
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hO8vF-0002eg-Ns from joseph_myers@mentor.com ; Tue, 07 May 2019 15:50:53 -0700
Received: from digraph.polyomino.org.uk (137.202.0.90) by
 svr-ies-mbx-01.mgc.mentorg.com (139.181.222.1) with Microsoft SMTP Server
 (TLS) id 15.0.1320.4; Tue, 7 May 2019 23:50:50 +0100
Received: from jsm28 (helo=localhost)
        by digraph.polyomino.org.uk with local-esmtp (Exim 4.90_1)
        (envelope-from <joseph@codesourcery.com>)
        id 1hO8vB-0007SS-TH; Tue, 07 May 2019 22:50:49 +0000
Date:   Tue, 7 May 2019 22:50:49 +0000
From:   Joseph Myers <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To:     Arnd Bergmann <arnd@arndb.de>
CC:     <linux-api@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <netdev@vger.kernel.org>, Laura Abbott <labbott@redhat.com>,
        Florian Weimer <fw@deneb.enyo.de>,
        Paul Burton <pburton@wavecomp.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
In-Reply-To: <20190319165123.3967889-1-arnd@arndb.de>
Message-ID: <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
References: <20190319165123.3967889-1-arnd@arndb.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: SVR-IES-MBX-07.mgc.mentorg.com (139.181.222.7) To
 svr-ies-mbx-01.mgc.mentorg.com (139.181.222.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What happened with this patch (posted 19 March)?  I found today that we 
can't use Linux 5.1 headers in glibc testing because the namespace issues 
are still present in the headers as of the release.

-- 
Joseph S. Myers
joseph@codesourcery.com
