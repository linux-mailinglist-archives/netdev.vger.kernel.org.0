Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F8E373687
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 10:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhEEIpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 04:45:13 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:40738 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbhEEIpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 04:45:10 -0400
Received: from [192.168.0.20] (cpc89244-aztw30-2-0-cust3082.18-1.cable.virginm.net [86.31.172.11])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id EAFAB549;
        Wed,  5 May 2021 10:44:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1620204253;
        bh=Ls1mxiCMabs0Oko9RrHogOR5j7mZE8FeltuOYuqGmW0=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=K0NvwlNsdPRGGmLE/m2DbmJ9mcvfCTXxTUqmKjZJeJwJJExzzWPCynTAicUmRZO8Y
         BFVKtDNebsiVoOR1Nb0yZEMCwycjyPUoCQpJk3ykg71DDVScMW+sUJEF+DxAhR22ze
         H7TCB4/x4x1txOaVhYBhCDbA7eX9i7CrDF3sq3eI=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH 3/3] Add entries for words with stem "eleminat"
To:     Sean Gloumeau <sajgloumeau@gmail.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Gloumeau <sajgloumeau@protonmail.com>
References: <cover.1620185393.git.sajgloumeau@gmail.com>
 <6a526dbf75f6445f3711df0a201a48f8ac3149cd.1620185393.git.sajgloumeau@gmail.com>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <745aedaf-1954-3b76-a3c7-d5fb193b90b4@ideasonboard.com>
Date:   Wed, 5 May 2021 09:44:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <6a526dbf75f6445f3711df0a201a48f8ac3149cd.1620185393.git.sajgloumeau@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On 05/05/2021 05:17, Sean Gloumeau wrote:
> Entries are added to spelling.txt in order to prevent spelling mistakes
> involving words with stem "eliminat" from occurring again.
> 
> Signed-off-by: Sean Gloumeau <sajgloumeau@gmail.com>
> ---
>  scripts/spelling.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/spelling.txt b/scripts/spelling.txt
> index 7b6a01291598..e657be5aa2a9 100644
> --- a/scripts/spelling.txt
> +++ b/scripts/spelling.txt
> @@ -548,6 +548,9 @@ ehther||ether
>  eigth||eight
>  elementry||elementary
>  eletronic||electronic
> +eleminate||eliminate
> +eleminating||eliminating
> +elemination||elimination

These should be kept in alphabetical order I believe.

>  embeded||embedded
>  enabledi||enabled
>  enbale||enable
> 

