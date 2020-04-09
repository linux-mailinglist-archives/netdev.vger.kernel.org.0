Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54DC1A3A6A
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgDITSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:18:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgDITSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 15:18:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=jztMyYWTpMyMQi7m+zKRqsu/PjY9R6BdTWm6SuPhJf8=; b=m5dN9vlaGxCg4tGqWftAQiairA
        73Ym+KrKFp0KPiIILnStvfULg3KgeaXP9G/mD0ruHwEfkTI686lHyNnozP7KTUqfUqt1riwYWxT14
        d4tN9+IphBVg6zGZq86sUlPJfVYRZIKuWPuNkcLwyfMXk9oxXlIh7PYgzRK7ABVB6VshjWCdUesHj
        DsfUVwAbrkhmu9WtTXJBxtfS97r5W3GVVejcumhS7SkuG3QE1N2JjKC6kmGv346VhWmSiL2HULIVj
        if1SqPB2E78L2azBF3ruLlPvUXqCnlb/2PDlkSAT4fqZTJoXxsoatn4WTRaEj2u4TFYaGfSs3N/kJ
        G2pheHvA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMcgW-0005vZ-KU; Thu, 09 Apr 2020 19:17:56 +0000
Subject: Re: [PATCH net] docs: networking: convert DIM to RST
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, talgi@mellanox.com,
        leon@kernel.org, jacob.e.keller@intel.com
References: <20200409175704.305241-1-kuba@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fcda6033-a719-adfb-c25d-d562072b5e82@infradead.org>
Date:   Thu, 9 Apr 2020 12:17:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200409175704.305241-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/20 10:57 AM, Jakub Kicinski wrote:
> Convert the Dynamic Interrupt Moderation doc to RST and
> use the RST features like syntax highlight, function and
> structure documentation, enumerations, table of contents.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Hi,

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Sorry I dropped the ball on this.

Thanks.

> ---
>  Documentation/networking/index.rst            |   1 +
>  .../networking/{net_dim.txt => net_dim.rst}   | 106 +++++++++---------
>  MAINTAINERS                                   |   1 +
>  3 files changed, 58 insertions(+), 50 deletions(-)
>  rename Documentation/networking/{net_dim.txt => net_dim.rst} (75%)
> 
> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> index 50133d9761c9..6538ede29661 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -22,6 +22,7 @@ Linux Networking Documentation
>     z8530book
>     msg_zerocopy
>     failover
> +   net_dim
>     net_failover
>     phy
>     sfp-phylink
> diff --git a/Documentation/networking/net_dim.txt b/Documentation/networking/net_dim.rst
> similarity index 75%
> rename from Documentation/networking/net_dim.txt
> rename to Documentation/networking/net_dim.rst
> index 9bdb7d5a3ba3..935b260b6566 100644
> --- a/Documentation/networking/net_dim.txt
> +++ b/Documentation/networking/net_dim.rst
> @@ -1,28 +1,23 @@
> +======================================================
>  Net DIM - Generic Network Dynamic Interrupt Moderation
>  ======================================================
>  
> -Author:
> -	Tal Gilboa <talgi@mellanox.com>
> -
> +:Author: Tal Gilboa <talgi@mellanox.com>
>  
>  Contents
> -=========
> +========
>  
> -- Assumptions
> -- Introduction
> -- The Net DIM Algorithm
> -- Registering a Network Device to DIM
> -- Example
> +.. contents:: :local:
>  
> -Part 0: Assumptions
> -======================
> +Assumptions
> +===========
>  
>  This document assumes the reader has basic knowledge in network drivers
>  and in general interrupt moderation.
>  
>  
> -Part I: Introduction
> -======================
> +Introduction
> +============
>  
>  Dynamic Interrupt Moderation (DIM) (in networking) refers to changing the
>  interrupt moderation configuration of a channel in order to optimize packet
> @@ -41,14 +36,15 @@ number of wanted packets per event. The Net DIM algorithm ascribes importance to
>  increase bandwidth over reducing interrupt rate.
>  
>  
> -Part II: The Net DIM Algorithm
> -===============================
> +Net DIM Algorithm
> +=================
>  
>  Each iteration of the Net DIM algorithm follows these steps:
> -1. Calculates new data sample.
> -2. Compares it to previous sample.
> -3. Makes a decision - suggests interrupt moderation configuration fields.
> -4. Applies a schedule work function, which applies suggested configuration.
> +
> +#. Calculates new data sample.
> +#. Compares it to previous sample.
> +#. Makes a decision - suggests interrupt moderation configuration fields.
> +#. Applies a schedule work function, which applies suggested configuration.
>  
>  The first two steps are straightforward, both the new and the previous data are
>  supplied by the driver registered to Net DIM. The previous data is the new data
> @@ -89,30 +85,40 @@ manoeuvre as it may provide partial data or ignore the algorithm suggestion
>  under some conditions.
>  
>  
> -Part III: Registering a Network Device to DIM
> -==============================================
> +Registering a Network Device to DIM
> +===================================
> +
> +Net DIM API exposes the main function :c:func:`net_dim`.
> +
> +.. c:function:: void net_dim( struct dim *dim, struct dim_sample end_sample )
>  
> -Net DIM API exposes the main function net_dim(struct dim *dim,
> -struct dim_sample end_sample). This function is the entry point to the Net
> +This function is the entry point to the Net
>  DIM algorithm and has to be called every time the driver would like to check if
>  it should change interrupt moderation parameters. The driver should provide two
> -data structures: struct dim and struct dim_sample. Struct dim
> -describes the state of DIM for a specific object (RX queue, TX queue,
> -other queues, etc.). This includes the current selected profile, previous data
> -samples, the callback function provided by the driver and more.
> -Struct dim_sample describes a data sample, which will be compared to the
> -data sample stored in struct dim in order to decide on the algorithm's next
> -step. The sample should include bytes, packets and interrupts, measured by
> -the driver.
> +data structures:
> +
> +.. c:type:: struct dim
> +
> +  Describes the state of DIM for a specific object (RX queue, TX queue,
> +  other queues, etc.). This includes the current selected profile, previous
> +  data samples, the callback function provided by the driver and more.
> +
> +.. c:type:: struct dim_sample
> +
> +  Describes a data sample, which will be compared to the data sample
> +  stored in :c:type:`struct dim <dim>` in order to decide on the algorithm's next step.
> +  The sample should include bytes, packets and interrupts, measured by
> +  the driver.
>  
>  In order to use Net DIM from a networking driver, the driver needs to call the
>  main net_dim() function. The recommended method is to call net_dim() on each
>  interrupt. Since Net DIM has a built-in moderation and it might decide to skip
>  iterations under certain conditions, there is no need to moderate the net_dim()
>  calls as well. As mentioned above, the driver needs to provide an object of type
> -struct dim to the net_dim() function call. It is advised for each entity
> -using Net DIM to hold a struct dim as part of its data structure and use it
> -as the main Net DIM API object. The struct dim_sample should hold the latest
> +:c:type:`struct dim <dim>` to the net_dim() function call. It is advised for
> +each entity using Net DIM to hold a :c:type:`struct dim <dim>` as part of its
> +data structure and use it as the main Net DIM API object.
> +The :c:type:`struct dim_sample <dim_sample>` should hold the latest
>  bytes, packets and interrupts count. No need to perform any calculations, just
>  include the raw data.
>  
> @@ -124,19 +130,19 @@ the data flow. After the work is done, Net DIM algorithm needs to be set to
>  the proper state in order to move to the next iteration.
>  
>  
> -Part IV: Example
> -=================
> +Example
> +=======
>  
>  The following code demonstrates how to register a driver to Net DIM. The actual
>  usage is not complete but it should make the outline of the usage clear.
>  
> -my_driver.c:
> +.. code-block:: c
>  
> -#include <linux/dim.h>
> +  #include <linux/dim.h>
>  
> -/* Callback for net DIM to schedule on a decision to change moderation */
> -void my_driver_do_dim_work(struct work_struct *work)
> -{
> +  /* Callback for net DIM to schedule on a decision to change moderation */
> +  void my_driver_do_dim_work(struct work_struct *work)
> +  {
>  	/* Get struct dim from struct work_struct */
>  	struct dim *dim = container_of(work, struct dim,
>  				       work);
> @@ -145,11 +151,11 @@ void my_driver_do_dim_work(struct work_struct *work)
>  
>  	/* Signal net DIM work is done and it should move to next iteration */
>  	dim->state = DIM_START_MEASURE;
> -}
> +  }
>  
> -/* My driver's interrupt handler */
> -int my_driver_handle_interrupt(struct my_driver_entity *my_entity, ...)
> -{
> +  /* My driver's interrupt handler */
> +  int my_driver_handle_interrupt(struct my_driver_entity *my_entity, ...)
> +  {
>  	...
>  	/* A struct to hold current measured data */
>  	struct dim_sample dim_sample;
> @@ -162,13 +168,13 @@ int my_driver_handle_interrupt(struct my_driver_entity *my_entity, ...)
>  	/* Call net DIM */
>  	net_dim(&my_entity->dim, dim_sample);
>  	...
> -}
> +  }
>  
> -/* My entity's initialization function (my_entity was already allocated) */
> -int my_driver_init_my_entity(struct my_driver_entity *my_entity, ...)
> -{
> +  /* My entity's initialization function (my_entity was already allocated) */
> +  int my_driver_init_my_entity(struct my_driver_entity *my_entity, ...)
> +  {
>  	...
>  	/* Initiate struct work_struct with my driver's callback function */
>  	INIT_WORK(&my_entity->dim.work, my_driver_do_dim_work);
>  	...
> -}
> +  }
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9271068bde63..46a3a01b54b9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5961,6 +5961,7 @@ M:	Tal Gilboa <talgi@mellanox.com>
>  S:	Maintained
>  F:	include/linux/dim.h
>  F:	lib/dim/
> +F:	Documentation/networking/net_dim.rst
>  
>  DZ DECSTATION DZ11 SERIAL DRIVER
>  M:	"Maciej W. Rozycki" <macro@linux-mips.org>
> 


-- 
~Randy
