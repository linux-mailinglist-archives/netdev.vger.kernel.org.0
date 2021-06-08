Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657D639ED26
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhFHDu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:50:28 -0400
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:55598 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230254AbhFHDu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 23:50:26 -0400
Received: from omf18.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 41271180A8127;
        Tue,  8 Jun 2021 03:48:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 291972EBFA0;
        Tue,  8 Jun 2021 03:48:32 +0000 (UTC)
Message-ID: <049924859bc635b50d62b2297988d52363fb20ee.camel@perches.com>
Subject: Re: [PATCH v2] net: appletalk: fix some mistakes in grammar
From:   Joe Perches <joe@perches.com>
To:     13145886936@163.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Date:   Mon, 07 Jun 2021 20:48:30 -0700
In-Reply-To: <20210608025602.8066-1-13145886936@163.com>
References: <20210608025602.8066-1-13145886936@163.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=4.10
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 291972EBFA0
X-Stat-Signature: ksed3sg3hfawksb1wcsxbsen41oefic5
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19KI80gDoVhBqX9NcNcRMm+HA8AYokvlQA=
X-HE-Tag: 1623124112-107857
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-06-07 at 19:56 -0700, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix some mistakes in grammar.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
> v2: This statement "Anyone wanting to add it goes ahead." 
> is changed to "Anyone wanting to add it, go ahead.".
>  net/appletalk/ddp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
[]
> @@ -707,7 +707,7 @@ static int atif_ioctl(int cmd, void __user *arg)
>  
> 
>  		/*
>  		 * Phase 1 is fine on LocalTalk but we don't do
> -		 * EtherTalk phase 1. Anyone wanting to add it goes ahead.
> +		 * EtherTalk phase 1. Anyone wanting to add it, go ahead.

Your first patch to this file will not be applied
so this patch will not apply either.



