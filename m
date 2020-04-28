Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD311BB288
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 02:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgD1AGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 20:06:45 -0400
Received: from correo.us.es ([193.147.175.20]:59428 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgD1AGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 20:06:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 22C42E16EF
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:06:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 166352DC71
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:06:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0BD20BAABA; Tue, 28 Apr 2020 02:06:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16991DA736;
        Tue, 28 Apr 2020 02:06:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 02:06:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id ECADE42EF9E0;
        Tue, 28 Apr 2020 02:06:40 +0200 (CEST)
Date:   Tue, 28 Apr 2020 02:06:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] do not typedef socklen_t on Android
Message-ID: <20200428000640.GE24002@salvia>
References: <20200421081549.108375-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200421081549.108375-1-zenczykowski@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 01:15:49AM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> This is present in bionic header files regardless of compiler
> being used (likely clang)
> 
> Test: builds
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  libiptc/libip4tc.c | 2 +-
>  libiptc/libip6tc.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
> index 55540638..08147055 100644
> --- a/libiptc/libip4tc.c
> +++ b/libiptc/libip4tc.c
> @@ -22,7 +22,7 @@
>  #define inline
>  #endif
>  
> -#if !defined(__GLIBC__) || (__GLIBC__ < 2)
> +#if !defined(__ANDROID__) && (!defined(__GLIBC__) || (__GLIBC__ < 2))

Out of curiosity: Is there documentation on this Android libc library
and how this definition is used?

Thank you.
