Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E15557E6E0
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbiGVSzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236338AbiGVSzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:55:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CB5564E1;
        Fri, 22 Jul 2022 11:55:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7257460EF5;
        Fri, 22 Jul 2022 18:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89252C341CA;
        Fri, 22 Jul 2022 18:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658516137;
        bh=SHSOCNekWxCfsC+ee7AXhYazN4SoxT4p3smCSJcJZ0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YjloQ4cYn9IOruMjsdUZPhW1QM2gckvXycdNIEeNEeff7/3ydwcl15tTQp6+g2MdF
         81QzaJG9mYi4WRDzQyvdm5tcYHEVeXL5ulmXZilO3l6i0bu67A6SiQqKN96UevlfAV
         L8Jd7jjORk1eQ0yLv5tuS/WHUjM8ULKJ4rqgpryHBZEuMSX7EDBjG9+0orpp5FxfV/
         +3u7we0ROPP/+QSgni6kC8hw9vGhRVRiqzRnN1L0DfGESQDt8uPXAVWMjnRhWdoTOL
         pb2JUtr0vEhFilg6BuOQDrL4o4AP7wMQflmUt9wlRh29yKPHtBoSkCHffPjzI6bsfH
         ubYSc/MpqdnBg==
Date:   Fri, 22 Jul 2022 11:55:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     Slark Xiao <slark_xiao@163.com>, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] s390/qeth: Fix typo 'the the' in comment
Message-ID: <20220722115536.0d450512@kernel.org>
In-Reply-To: <434e604c-7fd3-6422-d13b-309a7c1fe0d3@linux.ibm.com>
References: <20220722093834.77864-1-slark_xiao@163.com>
        <434e604c-7fd3-6422-d13b-309a7c1fe0d3@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 12:23:06 +0200 Alexandra Winter wrote:
> On 22.07.22 11:38, Slark Xiao wrote:
> > Replace 'the the' with 'the' in the comment.
> > 
> > Signed-off-by: Slark Xiao <slark_xiao@163.com>
> > ---
> >  drivers/s390/net/qeth_core_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
> > index 9e54fe76a9b2..35d4b398c197 100644
> > --- a/drivers/s390/net/qeth_core_main.c
> > +++ b/drivers/s390/net/qeth_core_main.c
> > @@ -3565,7 +3565,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
> >  			if (!atomic_read(&queue->set_pci_flags_count)) {
> >  				/*
> >  				 * there's no outstanding PCI any more, so we
> > -				 * have to request a PCI to be sure the the PCI
> > +				 * have to request a PCI to be sure the PCI
> >  				 * will wake at some time in the future then we
> >  				 * can flush packed buffers that might still be
> >  				 * hanging around, which can happen if no  
> 
> This trivial typo has been sent twice already to this mailinglist:
> https://lore.kernel.org/netdev/Ytb1%2FuU+jlcI4jXw@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com/T/
> https://lore.kernel.org/netdev/7a935730-f3a5-0b1f-2bdc-a629711a3a01@linux.ibm.com/t/

Some of the comment spelling fixes get nacked in bulk (e.g. the
previous one was sent with a date of three days prior to the actual
posting). Since they are not in a thread the nacks are hard to see.
Or maybe they got lost 'cause patchwork does not understand
drivers/s390/net is netdev. Anyway, this one looks good, so it will
likely go in.
