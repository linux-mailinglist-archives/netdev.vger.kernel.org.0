Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DAB6BF7FF
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjCRF3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCRF3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:29:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD20817CF6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 22:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4221C60A0C
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 05:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE2EC433D2;
        Sat, 18 Mar 2023 05:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679117385;
        bh=eq5aKD4N05+/7J//J37274UWWL8jwXYsmeh2x+kmDvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g/skgbYoPMuhxPJVt9UirU0dj2rQeGK6h5M3fi3UKCxQbqobaFdjotlX7A0dK0vww
         BtumP065mntmHru387PBPbgcF07VeKzxWKh98HXpqNG5ZOrEJ9ZZqcMXHyuvI8Y5xl
         P8I/9AtOREXLZe+bZKjRMx/QyBAVTN3zfMQT90hmAlo+iNVcqsi63/L2c4FsftXvqy
         t6YXeg6KPDhPjrYBOowBgXaWtR5KmDkcJa8c0Do4eo9dQp5l6UPirt4Va76H6OI9vf
         k3gz7whJLt/jQuOww0ndsrQHevdc43OxVnyPRebovbStpLIfOIA5VCfpgm/yolSKAO
         GgB5kfgToPZAA==
Date:   Fri, 17 Mar 2023 22:29:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang He <windhl@126.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ethernet: sun: add check for the mdesc_grab()
Message-ID: <20230317222944.64f66377@kernel.org>
In-Reply-To: <20230315060021.1741151-1-windhl@126.com>
References: <20230315060021.1741151-1-windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 14:00:21 +0800 Liang He wrote:
>  	hp = mdesc_grab();
>  
> +	if (!hp)
> +		return -ENODEV;

no empty line between the function call and error check, please
