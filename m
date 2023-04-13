Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E9E6E0FA7
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbjDMOHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjDMOHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:07:18 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5DCE49;
        Thu, 13 Apr 2023 07:07:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B95EE6732D; Thu, 13 Apr 2023 16:07:13 +0200 (CEST)
Date:   Thu, 13 Apr 2023 16:07:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kevin Brodsky <kevin.brodsky@arm.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 2/3] net/compat: Update msg_control_is_user when
 setting a kernel pointer
Message-ID: <20230413140713.GA16625@lst.de>
References: <20230413114705.157046-1-kevin.brodsky@arm.com> <20230413114705.157046-3-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413114705.157046-3-kevin.brodsky@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 12:47:04PM +0100, Kevin Brodsky wrote:
> cmsghdr_from_user_compat_to_kern() is an unusual case w.r.t. how
> the kmsg->msg_control* fields are used. The input struct msghdr
> holds a pointer to a user buffer, i.e. ksmg->msg_control_user is
> active. However, upon success, a kernel pointer is stored in
> kmsg->msg_control. kmsg->msg_control_is_user should therefore be
> updated accordingly.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
