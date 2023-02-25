Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216056A26D1
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 03:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBYCdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 21:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBYCdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 21:33:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3EA1B2DD
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:33:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AA0861828
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 02:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF520C433D2;
        Sat, 25 Feb 2023 02:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677292412;
        bh=UhyIwoNpscRi1ghMnP5h2kWcFOXiCqhjXQY3+Hob3Sk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H6vL0YCmIgOvXo1cGm1tadvi5ZSWXc6nMJpRtLEtubXynPlq49o1MTr/dVWVQJMrh
         6F1RuNpwzpeLmpJbs4sTVSthk5xsanEGWMSzDCRMhB6U0vx4EGckBWjLE6lSYHVqc4
         9CYsrayOwiVQQDB7vDKPtB4/0KMfYKtxziIkNN4QS44nboxIBcO3oRqAhQ29TfyrWK
         MEHOLGfXuEtzk04lCgnQ0z/mGVdwvkWCXBYO/KkG68vkNp1pnwycJoDOXumVh4uDxo
         vYgL7X0z7YOt+xCYYD7OHA7clBhEp9DxzSEtfpYE00cJsvvAfoxv3hyyTuDtm4gssc
         zzoRnuK2C0X1w==
Date:   Fri, 24 Feb 2023 18:33:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     nick black <dankamongmen@gmail.com>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH] [net] fix inaccuracies in msg_zerocopy.rst
Message-ID: <20230224183331.60980adc@kernel.org>
In-Reply-To: <63f8cbc36988_78f6320819@willemb.c.googlers.com.notmuch>
References: <Y/gg/EhIIjugLdd3@schwarzgerat.orthanc>
        <63f8cbc36988_78f6320819@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 09:37:55 -0500 Willem de Bruijn wrote:
> nick black wrote:
> > Replace "sendpage" with "sendfile". Remove comment about
> > ENOBUFS when the sockopt hasn't been set; experimentation
> > indicates that this is not true.
> > 
> > Signed-off-by: nick black <dankamongmen@gmail.com>  
> 
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> 
> The first error was there from the start. The second is an
> inconsistency introduced with commit 5cf4a8532c99
> ("tcp: really ignore MSG_ZEROCOPY if no SO_ZEROCOPY")
> 
> If Documentation fixes go to net, I suggest that as Fixes tag.

Applied, thanks!
