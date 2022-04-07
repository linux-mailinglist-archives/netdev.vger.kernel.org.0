Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29774F7573
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 07:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbiDGFqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 01:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiDGFqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 01:46:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D8FB0D;
        Wed,  6 Apr 2022 22:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 145D2B826B7;
        Thu,  7 Apr 2022 05:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDE1C385A4;
        Thu,  7 Apr 2022 05:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649310291;
        bh=Biv8d3TRANlgbXTHh8vpDhvWFjg7iUImRdKs7EACW10=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mDvbgZIRln+/gFwun0f/GKEHqZQ1zmMVg4EpdGauUS+cGF397rgitHjXtOscWV5OV
         kOkX+uNqZ0czM/A/ZAbqiTxCTVTnF3oSQGGM4CU8y/A4EWAWK/c47XQLEDEF1WUh+N
         /ONkezIDJZyhD511XC1HORB9jyBZuZJQecg5sV8LoW45mWCcS56f23Xdf9ynfYVStl
         QAwCvsp72asfpYhQdG1XdckxaVz3kKBe1Qy7ltQdYz/WKdP+fDtH9UxNcNGNohN7yD
         5Z0/xnAtCLAIvRdRzPezYriL2cmVQNnf/lkVHRLutrAIPnXHmtAQTYi5r+3OtCx7xF
         5wZdWnDM226Tg==
Date:   Wed, 6 Apr 2022 22:44:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerd Rausch <gerd.rausch@oracle.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH 1/1] net/rds: Use "unpin_user_page" as "pin_user_pages"
 counterpart
Message-ID: <20220406224450.56ea5d86@kernel.org>
In-Reply-To: <47050fe9f6f26f11fc14ff0ac06547f73ec3b81e.camel@oracle.com>
References: <47050fe9f6f26f11fc14ff0ac06547f73ec3b81e.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 06 Apr 2022 14:03:05 -0700 Gerd Rausch wrote:
> In cases where "pin_user_pages" was used to obtain longerm references,
> the pages must be released with "unpin_user_pages".
> 
> Fixes: 0d4597c8c5ab ("net/rds: Track user mapped pages through special API")
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>

You must CC authors of the commit under Fixes. Please repost.
