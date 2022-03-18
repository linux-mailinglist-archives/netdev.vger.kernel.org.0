Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF924DE095
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 18:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239495AbiCRR6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 13:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239890AbiCRR5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 13:57:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A23241B55
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 10:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D462361AB2
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124C5C340E8;
        Fri, 18 Mar 2022 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647626194;
        bh=0lZRRqYoAMGbyMe8B5vhsJiH1FEkbCsB3W3afihYXBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s28QRHQeWktVLAxxXyHpJtOd8eUQJCsawawzcCu2uIB9j9xpa2ZoEiebAaB3Ukzsg
         ZaYqsf3G7oOPsdk5BmwCiiMmunb+JdqkXAVVjOSRpjGa4FU8AOwZYGNy09mNYpGLOC
         nUDexwGRi0hew77jNiMSZXIHpOK2pAwHd9vG9TqU6jliLfpmPyV7hLOuTv0CNN5+SL
         P1+5pBflNCw7MojtYAHwQpdTrxjBy0wmh71oChYHUK/mflzc9rLaKUlfqb86jZ4PiP
         GJUbIis8tSr+io2+Tw8wRwTNSZIVLeP5xUxwDRSEsUpELgqSaY6Rk2nUga/kpX769j
         YeHafM6lz9/Zg==
Date:   Fri, 18 Mar 2022 10:56:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 09/10] nfp: add support for NFDK data path
Message-ID: <20220318105628.2a714e55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220318101302.113419-10-simon.horman@corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
        <20220318101302.113419-10-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 11:13:01 +0100 Simon Horman wrote:
> +/**
> + * nfp_net_tx() - Main transmit entry point
> + * @skb:    SKB to transmit
> + * @netdev: netdev structure
> + *
> + * Return: NETDEV_TX_OK on success.
> + */
> +netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)

Did I fumble the kdoc here? I'd like to believe that I did not
and someone else added this, cause really it doesn't explain much :)
