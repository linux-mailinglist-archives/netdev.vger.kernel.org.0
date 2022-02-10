Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3E34B10D4
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243176AbiBJOtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:49:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241899AbiBJOtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:49:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8306AE9A;
        Thu, 10 Feb 2022 06:49:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4224BB8204B;
        Thu, 10 Feb 2022 14:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBCFC004E1;
        Thu, 10 Feb 2022 14:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644504582;
        bh=wZ8e4x7dPPXTT1USevGL00+7hfu6Gi8e6ZhNHsFFQlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PK0n//D1ZVB//hugWRW6h+p49FIpcM1pKsxrSmvz8VeewTnVg71HOMasxmcVNtm+e
         7+BIBz8qDgAwUYJbnkQG3QDZJj4a2QEtzn1ecX4Ezj8aFVvMQCXcChzN3kkreBv9jj
         vBaI8ZADyrw+4Vq7/ahGh8I/nRBlODB9Edg4b+uE=
Date:   Thu, 10 Feb 2022 15:49:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     bids.7405@bigpond.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH] USB: zaurus: support another broken Zaurus
Message-ID: <YgUmAg2//Lh4n2zg@kroah.com>
References: <20220210122643.12274-1-oneukum@suse.com>
 <YgUL6y4F34ZgC2K/@kroah.com>
 <6d5a8cb4-1823-cecb-a31e-2118a95c96a6@suse.com>
 <YgUei+MqkHAE2Oet@kroah.com>
 <118c84c8-d3aa-c3cb-06f4-c088e49c416f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118c84c8-d3aa-c3cb-06f4-c088e49c416f@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 03:20:38PM +0100, Oliver Neukum wrote:
> 
> On 10.02.22 15:17, Greg KH wrote:
> > On Thu, Feb 10, 2022 at 03:13:49PM +0100, Oliver Neukum wrote:
> >>
> >>> And isn't there a needed "Reported-by:" for this one as it came from a
> >>> bug report?
> >> Do we do these for reports by the kernel.org bugzilla?
> > We should, why not?
> 
> Hi,
> 
> 
> because it sort of implies that it was reported to a mailing list.
> If there is a bugzilla for it, shouldn't we reference it?

Yes please do that as well, that's what the "Link:" tag is for.

thanks,

greg k-h
