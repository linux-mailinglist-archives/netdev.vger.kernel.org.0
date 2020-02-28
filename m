Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C18B17334E
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 09:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgB1IwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 03:52:21 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:53174 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgB1IwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 03:52:21 -0500
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2020 03:52:19 EST
Received: from localhost.localdomain (p200300E9D71B9939E2C0865DB6B8C4EC.dip0.t-ipconnect.de [IPv6:2003:e9:d71b:9939:e2c0:865d:b6b8:c4ec])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 53688C3201;
        Fri, 28 Feb 2020 09:46:30 +0100 (CET)
Subject: Re: [PATCH 02/28] docs: networking: convert 6lowpan.txt to ReST
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Aring <alex.aring@gmail.com>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
 <bfa773f25584a3939e0a3e1fc6bc0e91f415cd91.1581002063.git.mchehab+huawei@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <f81edab9-3ca8-5421-5bf8-029cefc96ad6@datenfreihafen.org>
Date:   Fri, 28 Feb 2020 09:46:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <bfa773f25584a3939e0a3e1fc6bc0e91f415cd91.1581002063.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 06.02.20 16:17, Mauro Carvalho Chehab wrote:
> - add SPDX header;
> - use document title markup;
> - mark code blocks and literals as such;
> - adjust identation, whitespaces and blank lines;
> - add to networking/index.rst.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>   .../networking/{6lowpan.txt => 6lowpan.rst}   | 29 ++++++++++---------
>   Documentation/networking/index.rst            |  1 +
>   2 files changed, 17 insertions(+), 13 deletions(-)
>   rename Documentation/networking/{6lowpan.txt => 6lowpan.rst} (64%)
> 
> diff --git a/Documentation/networking/6lowpan.txt b/Documentation/networking/6lowpan.rst
> similarity index 64%
> rename from Documentation/networking/6lowpan.txt
> rename to Documentation/networking/6lowpan.rst
> index 2e5a939d7e6f..e70a6520cc33 100644
> --- a/Documentation/networking/6lowpan.txt
> +++ b/Documentation/networking/6lowpan.rst
> @@ -1,37 +1,40 @@
> +.. SPDX-License-Identifier: GPL-2.0
>   
> -Netdev private dataroom for 6lowpan interfaces:
> +==============================================
> +Netdev private dataroom for 6lowpan interfaces
> +==============================================
>   
>   All 6lowpan able net devices, means all interfaces with ARPHRD_6LOWPAN,
>   must have "struct lowpan_priv" placed at beginning of netdev_priv.
>   
> -The priv_size of each interface should be calculate by:
> +The priv_size of each interface should be calculate by::
>   
>    dev->priv_size = LOWPAN_PRIV_SIZE(LL_6LOWPAN_PRIV_DATA);
>   
>   Where LL_PRIV_6LOWPAN_DATA is sizeof linklayer 6lowpan private data struct.
> -To access the LL_PRIV_6LOWPAN_DATA structure you can cast:
> +To access the LL_PRIV_6LOWPAN_DATA structure you can cast::
>   
>    lowpan_priv(dev)-priv;
>   
>   to your LL_6LOWPAN_PRIV_DATA structure.
>   
> -Before registering the lowpan netdev interface you must run:
> +Before registering the lowpan netdev interface you must run::
>   
>    lowpan_netdev_setup(dev, LOWPAN_LLTYPE_FOOBAR);
>   
>   wheres LOWPAN_LLTYPE_FOOBAR is a define for your 6LoWPAN linklayer type of
>   enum lowpan_lltypes.
>   
> -Example to evaluate the private usually you can do:
> +Example to evaluate the private usually you can do::
>   
> -static inline struct lowpan_priv_foobar *
> -lowpan_foobar_priv(struct net_device *dev)
> -{
> + static inline struct lowpan_priv_foobar *
> + lowpan_foobar_priv(struct net_device *dev)
> + {
>   	return (struct lowpan_priv_foobar *)lowpan_priv(dev)->priv;
> -}
> + }
>   
> -switch (dev->type) {
> -case ARPHRD_6LOWPAN:
> + switch (dev->type) {
> + case ARPHRD_6LOWPAN:
>   	lowpan_priv = lowpan_priv(dev);
>   	/* do great stuff which is ARPHRD_6LOWPAN related */
>   	switch (lowpan_priv->lltype) {
> @@ -42,8 +45,8 @@ case ARPHRD_6LOWPAN:
>   	...
>   	}
>   	break;
> -...
> -}
> + ...
> + }
>   
>   In case of generic 6lowpan branch ("net/6lowpan") you can remove the check
>   on ARPHRD_6LOWPAN, because you can be sure that these function are called
> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> index 3ccb89bf5585..cc34c06477eb 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -34,6 +34,7 @@ Contents:
>      tls
>      tls-offload
>      nfc
> +   6lowpan
>   
>   .. only::  subproject and html
>   
> 

Reviewed-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
