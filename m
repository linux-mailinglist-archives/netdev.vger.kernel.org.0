Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4576B1BCFD8
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgD1WWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:22:02 -0400
Received: from correo.us.es ([193.147.175.20]:59006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgD1WWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 18:22:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 46C9311EB31
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 00:22:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 378A2BAAA3
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 00:22:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2D1A3BAC2F; Wed, 29 Apr 2020 00:22:00 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0142CDA7B2;
        Wed, 29 Apr 2020 00:21:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 00:21:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D56EC42EF4E0;
        Wed, 29 Apr 2020 00:21:57 +0200 (CEST)
Date:   Wed, 29 Apr 2020 00:21:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] do not typedef socklen_t on Android
Message-ID: <20200428222157.GA30125@salvia>
References: <20200421081549.108375-1-zenczykowski@gmail.com>
 <20200428000640.GE24002@salvia>
 <CANP3RGewkX54pqZtironHRCrEYdMF2FZLdKzJz=4GU2CgC=1Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGewkX54pqZtironHRCrEYdMF2FZLdKzJz=4GU2CgC=1Mg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 05:26:44PM -0700, Maciej Żenczykowski wrote:
> I don't know all that much about it.  Mostly it just seems to work.
> 
> I'm quoting from: https://en.wikipedia.org/wiki/Bionic_(software) ;-)
> 
> Bionic is basically a BSD licensed C library for use with Linux.
> This differs from other BSD C libraries which require a BSD kernel,
> and from the GNU C Library (glibc) which uses the GNU Lesser General
> Public License.
> 
> For the most part it's supposed to be drop-in compatible I think,
> and the kernel headers (uapi) come from some recent version of Linux.
> 
> The license and smaller size are AFAIK the main benefits.
> 
> ---
> 
> Got me curious and:
> 
> I'm not actually sure what defines __ANDROID__, maybe __BIONIC__ would
> be a better guard?
> 
> That seems to be defined in bionic/libc/include/sys/cdefs.h
> 
> https://android.googlesource.com/platform/bionic/+/master/libc/include/sys/cdefs.h#43
> 
> And the docs here:
> 
> https://android.googlesource.com/platform/bionic/+/master/docs/defines.md
> 
> do seem to suggest that __BIONIC__ is more equivalent to __GLIBC__

https://sourceforge.net/p/predef/wiki/Libraries/

This one also refers to the existing C library definitions which makes
more sense to me too.
