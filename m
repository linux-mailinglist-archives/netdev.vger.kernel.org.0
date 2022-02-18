Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB044BB778
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbiBRLBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:01:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbiBRLBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:01:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C571EB420;
        Fri, 18 Feb 2022 03:00:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 550A9B825C6;
        Fri, 18 Feb 2022 11:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B68CC340E9;
        Fri, 18 Feb 2022 11:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645182057;
        bh=xDNIszGdyu9JUBGF0Ipy4PA25oS8dSDLtoFOXkvLIKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xhs5U3EmTHMl0nWTi0yo5A9OtOEMx+CXjLeSXvOKPnazzvK2X0inACaa/m64YpgUk
         u+vVm+IomqjAgDPdsac93LXVY76GMGTrnK4LSylb0dOkLFJlN++Jgb7zxCyODkLwCB
         XH6wFRfMUdSm/dVW2R1k+STgi42X00YftHzB9N0A=
Date:   Fri, 18 Feb 2022 12:00:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        Riccardo Ferrazzo <rferrazzo@came.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] staging: wfx: fix scan with WFM200 and WW regulation
Message-ID: <Yg98Zjikg0ncQv8b@kroah.com>
References: <20220218105358.283769-1-Jerome.Pouiller@silabs.com>
 <2535719.D4RZWD7AcY@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2535719.D4RZWD7AcY@pc-42>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 11:57:47AM +0100, Jérôme Pouiller wrote:
> On Friday 18 February 2022 11:53:58 CET Jerome Pouiller wrote:
> > From: Riccardo Ferrazzo <rferrazzo@came.com>
> > 
> > Some variants of the WF200 disallow active scan on channel 12 and 13.
> > For these parts, the channels 12 and 13 are marked IEEE80211_CHAN_NO_IR.
> > 
> > However, the beacon hint procedure was removing the flag
> > IEEE80211_CHAN_NO_IR from channels where a BSS is discovered. This was
> > making subsequent scans to fail because the driver was trying active
> > scans on prohibited channels.
> > 
> > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> I forgot to mention I have reviewed on this patch:
> 
> Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>

Reviwed-by is implied with signed-off-by.

But what happened to the signed-off-by from the author of this change?

thanks,

greg k-h
