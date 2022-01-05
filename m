Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0923D4855EB
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbiAEPeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiAEPeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:34:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BCBC061245;
        Wed,  5 Jan 2022 07:34:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 505B0B81C27;
        Wed,  5 Jan 2022 15:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01C8C36AE3;
        Wed,  5 Jan 2022 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641396858;
        bh=77yhxiPBsVwvy/onUduoU4gPKD2EE/6DrFz1KbKsSzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ur+1dLA6bqx+tlZnx1bSVs1Z6p+6vnFyJ8JzUPbRvua2ZVM0nbJtvePttPBRsO8WQ
         +5qhKX+KKrCRVEYDRm0X1yJiy94yc/wbocac4lV6ncX4/CPr5PzxpOC99vJl5P7F1w
         PfRBRCgZHbMZJCreGJiP8yrTiDtMyW4FeKPGHITU=
Date:   Wed, 5 Jan 2022 16:34:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     kuba@kernel.org, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 3/3] net: usb: r8152: remove unused definition
Message-ID: <YdW6d0O1hB1dIh5l@kroah.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <20220105151427.8373-3-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105151427.8373-3-aaron.ma@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:14:27PM +0800, Aaron Ma wrote:
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>

Again, not good, you know better than to not provide a changelog text.

thanks,

greg k-h
