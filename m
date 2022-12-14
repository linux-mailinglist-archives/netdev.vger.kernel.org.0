Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB55F64C1B7
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 02:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237666AbiLNBSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 20:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiLNBSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 20:18:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E0D25C60
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 17:18:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96ECD61708
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 01:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4593EC433EF;
        Wed, 14 Dec 2022 01:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670980716;
        bh=WiALcN65WD76Sc/d2db5t1KHDlgXmLL6qNzHhKRn6P4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M1u7F7pc4gzZ0Bgxzp+j1mwIcuPel1g8DLwnRXPTRfGIdpXuuSIxBRXZJQgRFb6oX
         ghnK9faYmSgGt+yV53A96EiUr129kWtShaZYpcuFWwckmpgCJiQpnPH+AtyCtqb2JS
         lGCtIHFdTC58e+lMT8xsfnUGI8o20YRrKZBMFpACNYEHKCmWu2JugR+VfUGmVLmaEI
         mRaaRWyGjnf81VF2PXA9/UwtRURFgi6VSs2q6/q1ApVMTOBAGCaEgafG5PPPsdiICZ
         O3mOhoABZWkfVBxKXPxnfhsAnJvzyJclKnBzTIHXjzhtuuIP+EmtwEijLxwGNhNLD2
         EpvteU+6G1bDQ==
Date:   Tue, 13 Dec 2022 17:18:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        intel-wired-lan@lists.osuosl.org, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com,
        benjamin.mikailenko@intel.com, paul.m.stillwell.jr@intel.com,
        netdev@vger.kernel.org, leon@kernel.org
Subject: Re: [PATCH net-next v1 00/10] implement devlink reload in ice
Message-ID: <20221213171834.682641c3@kernel.org>
In-Reply-To: <Y5gdpoif/1zBUKDB@localhost.localdomain>
References: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
        <20221212101505.403a4084@kernel.org>
        <f0078f0a-acbc-a9bd-effd-6d04507e71e2@intel.com>
        <Y5gdpoif/1zBUKDB@localhost.localdomain>
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

On Tue, 13 Dec 2022 07:37:26 +0100 Michal Swiatkowski wrote:
> It was targeted to Tony dev-queue to allow some tests as Jake said.
> Sorry, probably I should point it out in cover letter.

You can tag as intel-next, iwl-next or some such, to avoid confusion.
