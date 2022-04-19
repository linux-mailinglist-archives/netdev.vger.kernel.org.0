Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A78507A9E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 22:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356565AbiDSUHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 16:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356495AbiDSUHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 16:07:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D40645E;
        Tue, 19 Apr 2022 13:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04CD4616B0;
        Tue, 19 Apr 2022 20:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018CAC385A7;
        Tue, 19 Apr 2022 20:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650398703;
        bh=A2qFOURET0e3VBZ9tKe16pxmX9MhilNw6SAjKsMMhX4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=h54xjPFYQ5UlVjImczhHBaUH3BHuzY7ey1mWTR43wzLoeWrs6AkZCzGqQiC0NluDQ
         tGFqvAA8lem8JV64LBoXvcAukfPJ/ztdK7I48eWrPuej+kgtQTR8x0FIhhpYve2w65
         T1aRBqFXf0UYl3Spgvsd0utJMwUElfwfxT2LboBX6ffvs1+5gaYMFSeYWicSqq6Nwq
         P+WTUO+WaigptQv1hEFr08nExGCChJcPXBjcsD+kYVd27Y8BX5Ga6iI1crGEmVtuu5
         qjdCK3lGUwBSV7Fwvtm20nI+1SgbIm9ttZDS/NgjjhkfHfBTKOOsPWV5hsM+O5Z5it
         ZiQQWjnnf19eg==
Message-ID: <6a9ac38a-5de0-3305-e14b-afd280411dd7@kernel.org>
Date:   Tue, 19 Apr 2022 14:04:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next] net/ipv6: Enforce limits for
 accept_unsolicited_na sysctl
Content-Language: en-US
To:     Arun Ajith S <aajith@arista.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com
References: <20220419105910.686-1-aajith@arista.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220419105910.686-1-aajith@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/22 4:59 AM, Arun Ajith S wrote:
> Fix mistake in the original patch where limits were specified but the
> handler didn't take care of the limits.
> 
> Signed-off-by: Arun Ajith S <aajith@arista.com>
> ---
>  net/ipv6/addrconf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

