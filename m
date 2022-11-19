Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1684630B2F
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiKSDaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiKSDaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:30:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78119E97D;
        Fri, 18 Nov 2022 19:30:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54838B82689;
        Sat, 19 Nov 2022 03:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7042AC433D7;
        Sat, 19 Nov 2022 03:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668828606;
        bh=s0Ajg/gzQ56VpBktK3FHWtDUaTd25s6hfvbrY/z3SMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IvrprgOU5AXfZ/HAuxRvpu+gV6u/WXgzCrYG6bho4ITXeaVc1cOH9qsAFJGsUgZgk
         3a7Jf1xXEwXPXUCJj6JdZYdOy+tIlYknFYpquACkzTgzaSKm9OzeLEM2gKbJDdx079
         tgHQ+a6OjHDmteeUBUiiwEqCLDGK66GSg8H9nPriP3OmxRvPyQWvsjDTVIzqFV5mDG
         GnT2KKnTVX4wBgi9zYTYmfo65QIvbX+UicR+4rInMCML3oZ9TEK2TxKx0OmOTAm0at
         7Zo4FTt0JXozml8AF2z19lRsySqCISV2oPOdVj2ZvnCFsweJnw6iK8t6jZS3J/b6CM
         evvdpDe/A6UGQ==
Date:   Fri, 18 Nov 2022 19:30:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li zeming <zeming@nfschina.com>
Cc:     pabeni@redhat.com, vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        edumazet@google.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sctp: sm_statefuns: Remove unnecessary
 =?UTF-8?B?4oCYTlVMTOKAmQ==?= values from Pointer
Message-ID: <20221118193004.5a6fbf52@kernel.org>
In-Reply-To: <20221118014641.3035-1-zeming@nfschina.com>
References: <20221118014641.3035-1-zeming@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Nov 2022 09:46:42 +0800 Li zeming wrote:
> -	struct sctp_packet *packet = NULL;
> +	struct sctp_packet *packet;
>  	struct sctp_chunk *chunk = arg;
>  	struct sctp_chunk *shut;

Please don't sent such patches to networking.
