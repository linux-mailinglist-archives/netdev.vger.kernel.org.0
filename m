Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B578B5F3213
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 16:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiJCOmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 10:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJCOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 10:42:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E0427155
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 07:42:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B00D5B8110F
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 14:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1862DC433C1;
        Mon,  3 Oct 2022 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664808127;
        bh=ORlG6p9MBH8qpHyzc+/LicR6QuWys1BB7zARQjJ867U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SxEiU+9AcDq1B/w/E4gIcyhXajbwbEfN8b2jb30Qrt8DDlu0widPeCTtfPj82DX83
         ZBJLIz0tcmdgd5s3crR+u+xlvYkvVfsJd8y4AUyGMvRPTBL8zSI1f4+aVsKVR60+r/
         Ai60dl8H8BJqAs5ZZ5ehm6aq0w7tR39IOl4JV//hZB2GgqWAmNdmJeW0bjnYhhyWEY
         MFYHAjRVjhjxY+c0EVfEGPLWqn4qXfw7OeB0tyIIJkLDobteS7K/pJ64kE02q38gTA
         MYpX1JTmaeyEcvcnEag5lwTvR8uf0Tybwu0xI+T2XticcdCCCR8HzNW5SKoYQlyqXN
         f6x7WnIWqutHw==
Date:   Mon, 3 Oct 2022 07:42:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: PHY firmware update method
Message-ID: <20221003074205.29ecfd8b@kernel.org>
In-Reply-To: <YzrTKwR/bEPJOs1P@shell.armlinux.org.uk>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
        <YzQ96z73MneBIfvZ@lunn.ch>
        <YzVDZ4qrBnANEUpm@nanopsycho>
        <YzWPXcf8kXrd73PC@lunn.ch>
        <20220929071209.77b9d6ce@kernel.org>
        <YzWxV/eqD2UF8GHt@lunn.ch>
        <Yzan3ZgAw3ImHfeK@nanopsycho>
        <Yzbi335GQGbGLL4k@lunn.ch>
        <20220930074546.0873af1d@kernel.org>
        <YzrTKwR/bEPJOs1P@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Oct 2022 13:18:51 +0100 Russell King (Oracle) wrote:
> On Fri, Sep 30, 2022 at 07:45:46AM -0700, Jakub Kicinski wrote:
> > Actually maybe there's something in DMTF, does PLDM have standard image
> > format? Adding Jake. Not sure if PHYs would use it tho :S   
> 
> DMTF? PLDM?

Based on google search + pattern matching the name I think this is 
the spec:

https://www.dmtf.org/sites/default/files/standards/documents/DSP0267_1.0.0.pdf
