Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEDC58CFA7
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244371AbiHHVaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238532AbiHHVaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D24247;
        Mon,  8 Aug 2022 14:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2FDFB81057;
        Mon,  8 Aug 2022 21:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FFAC433C1;
        Mon,  8 Aug 2022 21:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659994212;
        bh=8I/6BSCB7QRgGY9y/Ch+UemtT6uX2ke0x7wPLXYO2Jo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YoQXx1BVTKzcpPWbTYiLLfa6VX1OZVvXYTKfuplpwqucw//VCTfu3BeNLbuAyW9dn
         2VMwISWtomZOXcFI1XWxDLM4qSGfqxgP160V9KiPw1hV0YOGoeoeegoPhKlAThfkri
         DgDMQiseGYlbmWn8XxAd4hLaF6C+omW+JwGErkVpUPPKv8JLVaOKzF2KLYl4ZRAV2D
         hnp8jM6Pp9ai/o7Ss33c5gqvI/nApve37AzDZgXNyQGEiKZ3Ol/TGFz2sU/WO5IEmw
         LLEhYtLTHnKCot2A3eBjrvNJChQn5GUFCnkKV8I20XHHzDyuaHkRZgT9wlN3zno1SG
         FPw/OrM1ByXGw==
Date:   Mon, 8 Aug 2022 14:30:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth 2022-08-05
Message-ID: <20220808143011.7136f07a@kernel.org>
In-Reply-To: <CABBYNZLPkVHJRtGkfV8eugAgLoSxK+jf_-UwhSoL2n=9J9TFcw@mail.gmail.com>
References: <20220805232834.4024091-1-luiz.dentz@gmail.com>
        <20220805174724.12fcb86a@kernel.org>
        <CABBYNZLPkVHJRtGkfV8eugAgLoSxK+jf_-UwhSoL2n=9J9TFcw@mail.gmail.com>
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

On Mon, 8 Aug 2022 12:38:25 -0700 Luiz Augusto von Dentz wrote:
> > Did you end up switching to the no-rebase/pull-back model or are you
> > still rebasing?  
> 
> Still rebasing, I thought that didn't make any difference as long as
> the patches apply.

Long term the non-rebasing model is probably better since it'd be great
for the bluetooth tree to be included in linux-next.

Since you haven't started using that model, tho, would you mind
repairing the Fixes tags in this PR? :)
