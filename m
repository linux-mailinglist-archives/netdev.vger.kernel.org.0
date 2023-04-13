Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581B26E0FAB
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjDMOHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjDMOHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:07:47 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158DDB453;
        Thu, 13 Apr 2023 07:07:35 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A3CEF68AFE; Thu, 13 Apr 2023 16:07:32 +0200 (CEST)
Date:   Thu, 13 Apr 2023 16:07:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kevin Brodsky <kevin.brodsky@arm.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 3/3] net/ipv6: Initialise msg_control_is_user
Message-ID: <20230413140731.GB16625@lst.de>
References: <20230413114705.157046-1-kevin.brodsky@arm.com> <20230413114705.157046-4-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413114705.157046-4-kevin.brodsky@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 12:47:05PM +0100, Kevin Brodsky wrote:
> do_ipv6_setsockopt() makes use of struct msghdr::msg_control in the
> IPV6_2292PKTOPTIONS case. Make sure to initialise
> msg_control_is_user accordingly.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
