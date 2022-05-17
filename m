Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F12A5296F2
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiEQBxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiEQBx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:53:29 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 18:53:28 PDT
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7308234B9C
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:53:28 -0700 (PDT)
Received: (qmail 51975 invoked by uid 89); 17 May 2022 01:46:47 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 17 May 2022 01:46:47 -0000
Date:   Mon, 16 May 2022 18:46:44 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v3 02/10] ptp: ocp: add Celestica timecard PCI
 ids
Message-ID: <20220517014644.4jxm4evud46ybsh3@bsd-mbp.dhcp.thefacebook.com>
References: <20220513225924.1655-1-jonathan.lemon@gmail.com>
 <20220513225924.1655-3-jonathan.lemon@gmail.com>
 <20220516174303.73de08ae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516174303.73de08ae@kernel.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 05:43:03PM -0700, Jakub Kicinski wrote:
> On Fri, 13 May 2022 15:59:16 -0700 Jonathan Lemon wrote:
> > +#ifndef PCI_VENDOR_ID_CELESTICA
> > +#define PCI_VENDOR_ID_CELESTICA 0x18d4
> > +#endif
> > +
> > +#ifndef PCI_DEVICE_ID_CELESTICA_TIMECARD
> > +#define PCI_DEVICE_ID_CELESTICA_TIMECARD 0x1008
> > +#endif
> 
> The ifdefs are unnecessary, these kind of constructs are often used out
> of tree when one does not control the headers, but not sure what purpose
> they'd serve upstream?

include/linux/pci_ids.h says:

 *      Do not add new entries to this file unless the definitions
 *      are shared between multiple drivers.

Neither FACEBOOK (0x1d9b) nor CELESTICA (0x18d4) are present
in this file.  This seems to a common idiom in several other
drivers.  Picking one at random:

   gve.h:#define PCI_VENDOR_ID_GOOGLE 0x1ae0


So these #defines are needed.
-- 
Jonathan
