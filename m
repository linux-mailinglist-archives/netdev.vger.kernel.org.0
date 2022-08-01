Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAC6586E5F
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 18:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiHAQOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 12:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiHAQN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 12:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86DA3D590;
        Mon,  1 Aug 2022 09:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3602D60D45;
        Mon,  1 Aug 2022 16:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E40EC433D6;
        Mon,  1 Aug 2022 16:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659370436;
        bh=YXaAov8IHzyzflVVsapCkbUpaXtMMoWT3eFboB7Tiu4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RwfyKsm7meWvTndVlSS0FGxJ9HgEYGzlRVFe54oMXJ9IoxskY5Y0ibklc5z3Axx7c
         tTFxtZaidfXS8BwaZPXFfOaI5iKZkajlaMluB5WPkH6ZfSwZwOCtk4gandwJYzNWIV
         r2HH858krC3w7xXATU4PgNmA/rz889Pl6pdTNsBKGEqTCYQbKX4PtmcXOKH54YTKfA
         GphUCSxLgN7UzpdQ2XiCzLgyom9/dNfUQHhFHm+kzmdSpaNa+29cUd7Q0DeVM6Glxo
         RHzZIzbY62wwlw4TOuMO+kPw9ievZ5NhbfeFTKRPto4VI8Tq4QfdRc2QVgXtk7YBON
         BIqpQ4e1HYTXQ==
Date:   Mon, 1 Aug 2022 09:13:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] iavf: Remove the unused conditional
 statements
Message-ID: <20220801091355.6ca23bcf@kernel.org>
In-Reply-To: <20220801022754.1594651-1-ye.xingchen@zte.com.cn>
References: <20220801022754.1594651-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Aug 2022 02:27:54 +0000 cgel.zte@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Conditional statements have no effect to next process.So remove it.

Nack, it's the default statement. Please fix the tool which makes you
send these patches. 
