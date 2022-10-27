Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6A660FFC4
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbiJ0SDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiJ0SCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:02:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C8C6177;
        Thu, 27 Oct 2022 11:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 005C3623ED;
        Thu, 27 Oct 2022 18:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10169C43142;
        Thu, 27 Oct 2022 18:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666893762;
        bh=9c42IH0b3Le61R6BuZ1IXYz4FnUvKiWMdd8fq7YE9xo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tEVpGBSyENufSdtuWKkSpWxr0ke9inkC05K20gZB8XeYF0YkIWS7WTznAH0FzdEDA
         AdYTiCQ8K3jiMTRIodwX3mnk5NPBfD6fSXmF44ZAidHHVjMfyeR26oZBtk/5a+P77K
         TbEBLgYfM9swb84n+f78mL+WesFXRjepcM6dGdHP2YpSIEaGKeQ7cUtbp/OxUz8pWD
         4YZ32tQ2gU/lkW+d9vvwhJ7tpSGRciFk1ipe4uumjrqWcorzLsl+4varGUfLs0cr2z
         4/PW+Lrr6m5Wx3OHIIIANSuHlGcDiTIjW4eWOwyNBkJqP2lJYUcRTPFVdITrt7prCR
         k9qtqpNOcBNnQ==
Date:   Thu, 27 Oct 2022 11:02:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Bin Chen <bin.chen@corigine.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: hinic: Convert the cmd code from decimal to
 hex to be more readable
Message-ID: <20221027110241.0340abdf@kernel.org>
In-Reply-To: <20221026125922.34080-1-cai.huoqing@linux.dev>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 20:59:10 +0800 Cai Huoqing wrote:
> Subject: [PATCH 1/2] net: hinic: Convert the cmd code from decimal to hex to be more readable

Please put [PATCH net-next] or [PATCH -next] in the subject,
to make the patch sorting easier for maintainers.

> The print cmd code is in hex, so using hex cmd code intead of
> decimal is easy to check the value with print info.

> -	HINIC_PORT_CMD_SET_AUTONEG	= 219,
> -
> -	HINIC_PORT_CMD_GET_STD_SFP_INFO = 240,
> -
> -	HINIC_PORT_CMD_SET_LRO_TIMER	= 244,
> -
> -	HINIC_PORT_CMD_SET_VF_MAX_MIN_RATE = 249,
> -
> -	HINIC_PORT_CMD_GET_SFP_ABS	= 251,
> +	HINIC_PORT_CMD_GET_SFP_ABS = 0xFB,

This deletes some entries. Please don't mix changes with mechanical
conversions.
