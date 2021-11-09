Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BCF44A435
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239701AbhKIBvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:51:53 -0500
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:46010 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231229AbhKIBvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 20:51:53 -0500
Received: from omf11.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 26CB31802DA68;
        Tue,  9 Nov 2021 01:49:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id 9133F20A293;
        Tue,  9 Nov 2021 01:49:05 +0000 (UTC)
Message-ID: <f527316e1ea4017af37857dd6d3eeecffc3bbce0.camel@perches.com>
Subject: Re: [PATCH AUTOSEL 4.19 10/47] NET: IPV4: fix error "do not
 initialise globals to 0"
From:   Joe Perches <joe@perches.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     wangzhitong <wangzhitong@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>, paul@paul-moore.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Date:   Mon, 08 Nov 2021 17:49:04 -0800
In-Reply-To: <20211108175031.1190422-10-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
         <20211108175031.1190422-10-sashal@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.74
X-Stat-Signature: ywfaopkbkekuqwjh9bmzy79m9yzhhabh
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 9133F20A293
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18A8nOBpRGzod+EATlk6xaJ0ABEZZMG0Mc=
X-HE-Tag: 1636422545-143270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-11-08 at 12:49 -0500, Sasha Levin wrote:
> From: wangzhitong <wangzhitong@uniontech.com>
> 
> [ Upstream commit db9c8e2b1e246fc2dc20828932949437793146cc ]
> 
> this patch fixes below Errors reported by checkpatch
>     ERROR: do not initialise globals to 0
>     +int cipso_v4_rbm_optfmt = 0;
> 
> Signed-off-by: wangzhitong <wangzhitong@uniontech.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/ipv4/cipso_ipv4.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index e8b8dd1cb1576..75908722de47a 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -87,7 +87,7 @@ struct cipso_v4_map_cache_entry {
>  static struct cipso_v4_map_cache_bkt *cipso_v4_cache;
>  
>  /* Restricted bitmap (tag #1) flags */
> -int cipso_v4_rbm_optfmt = 0;
> +int cipso_v4_rbm_optfmt;

I think this is a silly thing to backport unless it's required
for some other patch.

>  int cipso_v4_rbm_strictvalid = 1;
>  
>  /*


