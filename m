Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F666E8784
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjDTBjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjDTBjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:39:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F79F1FE5;
        Wed, 19 Apr 2023 18:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF1B1642F8;
        Thu, 20 Apr 2023 01:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE59EC433D2;
        Thu, 20 Apr 2023 01:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681954747;
        bh=KwO8iROPQ6guPSsSHXUOjYOxrKYEMZQ+PVDW67qQsqQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bENdmrXJz9faZCUsuIcH154wlGHuLdVXavzqmcZMeVxVXTzBsLc8oWoTxfYVKRWPl
         cMgs5wATMPpoVqnrM0FZO+7LQoz/otan9ajQGZGF6luBzVK6CZB/5/pxGn7bfeYw5i
         NnO+p60VoyTN8tOTuQSGQPIgYnMkfXNJ8V9CMJK2F32XRLFNPTHQ4cFO+Pd+l4tFHc
         l0fhWehGBTDOtSixbO2Xa7gyTk5At6EiVmt8fExpLfYTJ08mokyFvfN1Lc/B8R+gqR
         IE4ODuTsoTqGIfgD3j7bRKhUERYI/Z0vkEUXyr2ODvKaY6CQ8yZQWVgHvgL1b39pHI
         1IkIEerSa03uQ==
Date:   Wed, 19 Apr 2023 18:39:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next v2] wwan: core: add print for wwan port
 attach/disconnect
Message-ID: <20230419183905.5d290242@kernel.org>
In-Reply-To: <20230417094617.2927393-1-slark_xiao@163.com>
References: <20230417094617.2927393-1-slark_xiao@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 17:46:17 +0800 Slark Xiao wrote:
> Refer to USB serial device or net device, there is a notice to
> let end user know the status of device, like attached or
> disconnected. Add attach/disconnect print for wwan device as
> well.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

Patch never made it to the list:

https://lore.kernel.org/r/20230417094617.2927393-1-slark_xiao@163.com/

:( Could you resend?
