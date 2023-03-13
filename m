Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43F16B75BE
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjCMLRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjCMLRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:17:03 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E862595C;
        Mon, 13 Mar 2023 04:16:13 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VdlpqpR_1678706148;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VdlpqpR_1678706148)
          by smtp.aliyun-inc.com;
          Mon, 13 Mar 2023 19:15:49 +0800
Date:   Mon, 13 Mar 2023 19:15:48 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Subject: Re: [PATCH net-next 2/2] net/ism: Remove extra include
Message-ID: <ZA8F5EA/4pPjmpVK@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20230313101032.13180-1-wenjia@linux.ibm.com>
 <20230313101032.13180-3-wenjia@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313101032.13180-3-wenjia@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:10:32AM +0100, Wenjia Zhang wrote:
> From: Stefan Raspl <raspl@linux.ibm.com>
> 
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  drivers/s390/net/ism_drv.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
> index 1c73d32966f1..05749c877990 100644
> --- a/drivers/s390/net/ism_drv.c
> +++ b/drivers/s390/net/ism_drv.c
> @@ -11,7 +11,6 @@
>  #include <linux/types.h>
>  #include <linux/interrupt.h>
>  #include <linux/device.h>
> -#include <linux/pci.h>
>  #include <linux/err.h>
>  #include <linux/ctype.h>
>  #include <linux/processor.h>
> -- 
> 2.37.2
