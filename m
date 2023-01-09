Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79ED4662994
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237111AbjAIPOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237040AbjAIPNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:13:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B311A1;
        Mon,  9 Jan 2023 07:12:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 222726117E;
        Mon,  9 Jan 2023 15:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB33AC433D2;
        Mon,  9 Jan 2023 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673277137;
        bh=uo7fc0mmKrGkfOcf5guy0Az6XhMXNwAy01tztDAqFu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ARs3SeRseq7l2W5O8NbAsxmyFUlrz1czglO2P2+kEicK8nHKYaOIVANWlGwMoV1mw
         uzXrhYeu+GFOZlGCDpCfh9UBE7wNzouby1DViZuJ+GhDWSZlIjijOceg810VWTNoaZ
         4tZSVsqLkojuUS13ntWYF+PGXnu/DW9cg47uPLJFDpl6oC+TwaTSTDdDsaEl5U25t7
         adKPRoSm2Z8k3F8RfnlQ0vP+2XfauwiedH1Kf/pUBTq9lJgb9LR0d05GK/FKolJQDe
         JV4j00zhxAwW5S+KJcq+9cudh3nO6hPeSSGWzFrhg9RCmAEK0qaRNgdosxLnIe5rd+
         CVqd0OL0jZ2rQ==
Date:   Mon, 9 Jan 2023 08:12:13 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
        linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Paul Moore <paul@paul-moore.com>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCHv2 00/12] iov_iter: replace import_single_range with ubuf
Message-ID: <Y7wuzaXhypvExrNF@kbusch-mbp>
References: <20230108171241.GA20314@lst.de>
 <20230105190741.2405013-1-kbusch@meta.com>
 <1880281.1673256668@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1880281.1673256668@warthog.procyon.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 09:31:08AM +0000, David Howells wrote:
> lore.kernel.org doesn't seem to have the patches.
> 
> https://lore.kernel.org/lkml/20230105190741.2405013-1-kbusch@meta.com/

That's frustrating. Seems like an email setup problem on my end. I'll
split this series up and resend.
