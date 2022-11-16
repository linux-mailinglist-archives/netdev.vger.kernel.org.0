Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C26E62CE0E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbiKPWv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKPWvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:51:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3B619C2C;
        Wed, 16 Nov 2022 14:51:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B7296202D;
        Wed, 16 Nov 2022 22:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9F3C433D7;
        Wed, 16 Nov 2022 22:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668639082;
        bh=kwMv8VQvYzTgypX/mCOAuaT7GYLj9ZfVoavI6kIk7cw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bh+DWdA50FDxpH3/gDI8Li5xswIHjHUL5dJ0wt4bQQUqMEvIrzrG8uL1JZpcMrBSI
         qL07EYLAABCvI6gKAsP0G0TTZOFjHWnMY0UDaf+0ApTbGFTq0WXTbdAwHVxBNGTGBT
         wWlhRY9ix+h3P9r4GnOe0k1bFcghVIdkTl7cydX+x/h0H1qFiWHMjebKe1H+BZpKym
         zdZWcO3i66PvoJMKaPhN5+nLpRzZ4zy2UauglxDF63SUFN1Wofw/c/8RpDam8iEL2p
         FSqzxRXZfFPrNfGiDndRKhhh7EYneEyVjR6mD7MZoGXvbepeo2bUQ9xT9ClmBIUYf8
         yV5fvTjdi3kpQ==
Date:   Wed, 16 Nov 2022 14:51:21 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net-next] sctp: change to include linux/sctp.h in
 net/sctp/checksum.h
Message-ID: <Y3VpaTiSSkWuttmx@x130.lan>
References: <ca7ea96d62a26732f0491153c3979dc1c0d8d34a.1668526793.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ca7ea96d62a26732f0491153c3979dc1c0d8d34a.1668526793.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 10:39, Xin Long wrote:
>Currently "net/sctp/checksum.h" including "net/sctp/sctp.h" is
>included in quite some places in netfilter and openswitch and
>net/sched. It's not necessary to include "net/sctp/sctp.h" if
>a module does not have dependence on SCTP, "linux/sctp.h" is
>the right one to include.
>
>Signed-off-by: Xin Long <lucien.xin@gmail.com>

LGTM as long as it builds:
Reviewed-by: Saeed Mahameed <saeed@kernel.org>


