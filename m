Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC236D8401
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbjDEQrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbjDEQrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:47:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A643AAB;
        Wed,  5 Apr 2023 09:47:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2229B622D9;
        Wed,  5 Apr 2023 16:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432E8C433EF;
        Wed,  5 Apr 2023 16:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680713230;
        bh=m9Gq0sauwa2Ak7S7SCl7cffwpDketC9wZ9f/DdaPVYo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H7cbwC9c/mWOiCE8k3+9X1Ws0QKSpG0zg/OtduYNe831RM0p/paOdqaOEFnqTmCw0
         iZUgJZZQ5LIhReS+R/6GQVQhhGH1Gvzop44p5XSkpTte5HouEQ+fVWe4AbJ8feLsm5
         nRSThGvlyryicWT076j8W5RoHX1SG7ZMK77EOyAKU9ybdSTVW2iLLx25bsYbA1TmSC
         vGXpo87BuHAUrOUHIbnZ+u3Ycom9W/4vmmHPxcMlffq+0jPGuREb4qaPJVKCXn+VoT
         zvOmSMgFU8i8AEWuujgPJ1Kat1/ePdH9qVs8PWfCjzaV/f5YQKzahZYWvByd6Xg8sr
         CoUH/MHegVBPA==
Date:   Wed, 5 Apr 2023 09:47:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Arefev <arefev@swemel.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: Re: [PATCH] net: Added security socket
Message-ID: <20230405094709.191f6048@kernel.org>
In-Reply-To: <20230405125308.57821-1-arefev@swemel.ru>
References: <20230405125308.57821-1-arefev@swemel.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Apr 2023 15:53:08 +0300 Denis Arefev wrote:
> 	Added security_socket_connect
> 	kernel_connect is in kernel space,
> 	but kernel_connect is used in RPC 
> 	requests (/net/sunrpc/xprtsock.c),  
> 	and the RPC protocol is used by the NFS server.
> 	This is how we protect the TCP connection 
> 	initiated by the client. 

Can you please format this to look like every other commit in the
kernel and use imperative mood?

Then please add to the description _exactly_ how you're going to use
it, i.e. an example of a real rule. And CC
linux-security-module@vger.kernel.org
