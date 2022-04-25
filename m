Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C969A50E4A6
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbiDYPrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbiDYPrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC865473BE;
        Mon, 25 Apr 2022 08:44:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2399961143;
        Mon, 25 Apr 2022 15:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477AEC385A7;
        Mon, 25 Apr 2022 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650901447;
        bh=A4Xb/DwhvlQTAOJqZzaTzrsf5ce2U62ID0WNLllV+To=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q391trceTEQu+yMPps3GAvH47BurSsoxxkzlP6y/RgHp9Y89xcaEp8vkX9DjTLF84
         3wZhGoIHST/UVMkjHqeew4/VmHtclYH6Dsgy78wRhg9LPLzgO4WpaQhim5GTXMx7K5
         mlO8pMqMP8oG95cB2/TCA54Junflg3YMLYhLt+XWGo1lY82HMoI/A64tGxAX4XAxe/
         PM2FVgdtPfobiLF5ZD1REx/IAK/ZdFqPQ1Vjlpv/2nnajWyNCJVPCLbUtLT5U8eQoI
         Lx5PH+VCjAp448jcrs3MZOS3xUxrYPYXO/uEgdlljlsQAc4YFt/ADN6r1frDrJBzq9
         9FffPvb1TGbLw==
Date:   Mon, 25 Apr 2022 08:44:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ian Cowan <ian@linux.cowan.aero>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: appletalk: cleanup brace styling
Message-ID: <20220425084406.5f93bb43@kernel.org>
In-Reply-To: <20220425023512.502988-1-ian@linux.cowan.aero>
References: <20220425023512.502988-1-ian@linux.cowan.aero>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Apr 2022 22:35:12 -0400 Ian Cowan wrote:
> This cleans up some brace styling to meet the style guide. There is one
> exception where the compiler wants unnecessary braces to prevent
> multiple if/else ambiguity.
> 
> Signed-off-by: Ian Cowan <ian@linux.cowan.aero>

Please don't send pure style cleanups to networking, especially 
to dinosaur code. Thanks!
