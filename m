Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481C55BC564
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 11:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiISJbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 05:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiISJbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 05:31:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FF1140A2
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 02:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83BFAB8074C
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 09:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B67C433C1;
        Mon, 19 Sep 2022 09:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663579875;
        bh=bRJW9mV80au4vMqU1S7UBqZ97Y6zTwyJ0lDMX5dN1jk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GhHOyLsozm+FNucJR3mOIvi+u2UemtNbvvAG/glsIIL3ZZ6v611a/VfoslSBevUib
         T22zfdyOIlrRnFHY7IoRfyeheYk+ygtA/faQX4Cbb/myXpT4Ofz558rXsQtmVeHqL5
         VMGuMRtbNYwOvihr1B6yjJTruzmK84tCWIexijsZkqQoO4lHxjNAdIRY0wdI/g+WgB
         mwYlDvXKsIccEZR9nC86oskjt/86P87tAB93B0coHabiyxH6YlFwkh26w1jr4pWixs
         T3KIU+EqCaWPNwvg0EtXuLK0ByhXDKex0lGN4WaxwkqwPDaXk7oqeE7ISw4HBdLlhL
         P4mkjastAuyrQ==
Date:   Mon, 19 Sep 2022 12:31:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <Yyg23x8HtBqiB1Oc@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1662295929.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 04, 2022 at 04:15:34PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>

<...>

> Leon Romanovsky (8):
>   xfrm: add new full offload flag
>   xfrm: allow state full offload mode
>   xfrm: add an interface to offload policy
>   xfrm: add TX datapath support for IPsec full offload mode
>   xfrm: add RX datapath protection for IPsec full offload mode
>   xfrm: enforce separation between priorities of HW/SW policies
>   xfrm: add support to HW update soft and hard limits
>   xfrm: document IPsec full offload mode

Kindly reminder.

Thanks
