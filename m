Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88D610008
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiJ0SQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236410AbiJ0SQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:16:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE145BCB4
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:15:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC648CE27F7
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B354EC433D6;
        Thu, 27 Oct 2022 18:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666894509;
        bh=WWWvw77GA1wakr4dxpWsLx4KrKIJMdiCSIrQPsOPaqk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MZEjpYKqJ4GV0cfdXJ5faQPDMlB9JuEqJZ0C+gBAoh0q0JiSe2h3ZIDQeBQXzUqLC
         Z5MzeT57CCvKkz/c4MxQHgk/i7EJ7jhhIEZEh9VBT3H7FNLGyzsd0QMv/ayy59WTQj
         WsFrvxQK3k+hJl2skikGYfGtQLifGwIyNdU9YDGWX+WCnz+UJ/qqF0Z4r4drjPzATe
         NxqutSk/zx0I6ty8/7AqbZ95ddWZu4jrn4CCRGbTvM/qLTAMgFI/ZNXhkV/oSi6G2r
         mg7KrBhsNYy5hFSqKp1L1TDePzSh7tpMYTgZg7dPHtpzgXqBEeU/mNKAm070U/Q8st
         RMsY8J3WpFMmA==
Date:   Thu, 27 Oct 2022 11:15:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rongwei Liu <rongweil@nvidia.com>
Subject: Re: [V4 net 03/15] net/mlx5: DR, Fix matcher disconnect error flow
Message-ID: <20221027111507.50dd6040@kernel.org>
In-Reply-To: <20221026135153.154807-4-saeed@kernel.org>
References: <20221026135153.154807-1-saeed@kernel.org>
        <20221026135153.154807-4-saeed@kernel.org>
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

On Wed, 26 Oct 2022 14:51:41 +0100 Saeed Mahameed wrote:
> Fixes: cc2295cd54e4 ("net/mlx5: DR, Improve steering for empty or RX/TX-only matchers)

This is missing the terminating quotation marks.

Let me apply the series from the list and fix this for you. Sigh.
