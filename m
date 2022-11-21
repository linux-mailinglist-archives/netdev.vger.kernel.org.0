Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C7632B1F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiKURg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiKURg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:36:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EC9CEBAA;
        Mon, 21 Nov 2022 09:36:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB5D7B8123A;
        Mon, 21 Nov 2022 17:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2A1C433D6;
        Mon, 21 Nov 2022 17:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669052212;
        bh=NQjSwgUDT/c7wh4R1lYEuESLykGc+qlQRR0SRX0+IWg=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=WLl5HrN1dCOyEVFxsrOGEEpsb4jtJDNE9mdho8tJZTJhHLYgeC7+pAa4/FOdWVuPH
         akH4eQ7I7btKQyB6QVpcUBPuV0X4x/JWEnmGIF4brKXQfSbMtAE3f4ucVRoO0+Onyo
         c6cE14AcfKxwnvg8HNGdKQdZUbvNaD3rCg7L0y6iED/psh3M2G7vhsWaBQeoMiqwTu
         YCTKqtl+Tki8tK1gV56ZD34Va/xo1IamvOaVv0Mq0lsWfnoNSZSKqi6qO9kl12wJmM
         pxBMWrDaspS67iyqJBsf40OuPLAOUtRRIGC6QvEDFuUpa4+Bo+2pNtPVTYSVgiAm19
         vapP3vwMN3zdA==
Date:   Mon, 21 Nov 2022 18:36:50 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc:     Marcel Holtmann <marcel@holtmann.org>,
        linux-bluetooth@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH hid-next] HID: fix BT_HIDP Kconfig dependencies
In-Reply-To: <20221118084254.1880165-1-benjamin.tissoires@redhat.com>
Message-ID: <nycvar.YFH.7.76.2211211836260.6045@cbobk.fhfr.pm>
References: <20221118084254.1880165-1-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Nov 2022, Benjamin Tissoires wrote:

> If HID_SUPPORT is not selected, BT_HIDP should not be available, simply
> because we disallowed the HID bus entirely.
> 
> Add a new depends and actually revert this file back to where it was 10
> years ago before it was changed by commit 1f41a6a99476 ("HID: Fix the
> generic Kconfig options").
> 
> Fixes: 25621bcc8976 ("HID: Kconfig: split HID support and hid-core compilation")
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/r/202211181514.fLhaiS7o-lkp@intel.com/
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Applied to for-6.2/hid-bpf.

-- 
Jiri Kosina
SUSE Labs

