Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D261B39EC1B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhFHCeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:34:36 -0400
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:38438 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230266AbhFHCeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 22:34:36 -0400
Received: from omf03.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 2CFB4182CED2A;
        Tue,  8 Jun 2021 02:32:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id E8B6613D93;
        Tue,  8 Jun 2021 02:32:41 +0000 (UTC)
Message-ID: <150d317762ebcbe7cb824ba6850bf6dc25ee1c00.camel@perches.com>
Subject: Re: [PATCH] net: appletalk: fix some mistakes in grammar
From:   Joe Perches <joe@perches.com>
To:     13145886936@163.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Date:   Mon, 07 Jun 2021 19:32:40 -0700
In-Reply-To: <20210608022546.7587-1-13145886936@163.com>
References: <20210608022546.7587-1-13145886936@163.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=4.04
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: E8B6613D93
X-Stat-Signature: qz1shhxwedewfudwyyc47p91crcas61w
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX191kmvKT1LUwfoWM3gCXs+QOyLiKMaPuEU=
X-HE-Tag: 1623119561-911196
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-06-07 at 19:25 -0700, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix some mistakes in grammar.
[]
> diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
[]
> @@ -707,7 +707,7 @@ static int atif_ioctl(int cmd, void __user *arg)
>  
> 
>  		/*
>  		 * Phase 1 is fine on LocalTalk but we don't do
> -		 * EtherTalk phase 1. Anyone wanting to add it go ahead.
> +		 * EtherTalk phase 1. Anyone wanting to add it goes ahead.

This is really not better grammar.
It's describing how anyone should feel free to create an implementation.

It's also really old code that no one will use much anymore, so any
change to this module isn't particularly useful.


