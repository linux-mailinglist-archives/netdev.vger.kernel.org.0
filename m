Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD47458CDEF
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 20:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244259AbiHHSpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 14:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244279AbiHHSpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 14:45:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6687A2DC1;
        Mon,  8 Aug 2022 11:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CD556126A;
        Mon,  8 Aug 2022 18:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB5AC433C1;
        Mon,  8 Aug 2022 18:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659984292;
        bh=x1i9aM0KKc+coszc99vWY7V+PJsjLN0jdT6owj1wD40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lWYZoLyuxBTdKRiytxakUukzLJH5J1mKZnue4xKNr6ljXTHOdj+2kjO39iHGWS8O/
         SrMFmKR2exi9RVWkgyjpnY35h04W0JhAWj1GAvVCc0+VJUOj5+j6iMgZyHQyDPrkWH
         61iS4N08gMZH34Vm3KHbqsZrADPi1FUMbXIcynjS8m2IzJ/2gP+CVLIpEBKx+rBZU9
         K67Ejv4RU+SwDzKeW1El+HYk38Wq+KXZbUdP0BRXzNW8EZ1tWbkNs65kwgcu1j3e1f
         VTwi72wQeaPM5dtCDTFJD21Yyxitz+4XZBO19LizKdSNYeJ7IiYMSMl4Be9L1x+m10
         NA/1mbnXnR8kw==
Date:   Mon, 8 Aug 2022 11:44:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 44/45] skbuff: don't mix ubuf_info from
 different sources
Message-ID: <20220808114451.78686a5b@kernel.org>
In-Reply-To: <20220808013551.315446-44-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
        <20220808013551.315446-44-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  7 Aug 2022 21:35:48 -0400 Sasha Levin wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> [ Upstream commit 1b4b2b09d4fb451029b112f17d34792e0277aeb2 ]
> 
> We should not append MSG_ZEROCOPY requests to skbuff with non
> MSG_ZEROCOPY ubuf_info, they might be not compatible.

This is prep for later patches which add a different type of zerocopy.
No need to backport.
