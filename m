Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA87C6C8C97
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 09:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjCYIZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 04:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjCYIZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 04:25:00 -0400
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C23CC19;
        Sat, 25 Mar 2023 01:24:54 -0700 (PDT)
Received: from madeliefje.horms.nl (86-88-72-229.fixed.kpn.net [86.88.72.229])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id D2DBA202AA;
        Sat, 25 Mar 2023 08:24:22 +0000 (UTC)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 38A883F81; Sat, 25 Mar 2023 09:24:22 +0100 (CET)
Date:   Sat, 25 Mar 2023 09:24:22 +0100
From:   Simon Horman <horms@kernel.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 09/10] net: sunhme: Inline error returns
Message-ID: <ZB6vtqEhmfSQNema@vergenet.net>
References: <20230324175136.321588-1-seanga2@gmail.com>
 <20230324175136.321588-10-seanga2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324175136.321588-10-seanga2@gmail.com>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.8 at zeeaster
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.0 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 01:51:35PM -0400, Sean Anderson wrote:
> The err_out label used to have cleanup. Now that it just returns, inline it
> everywhere.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

