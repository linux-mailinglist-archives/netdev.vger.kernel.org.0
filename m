Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA58547233
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 07:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiFKFWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 01:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347307AbiFKFWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 01:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7B721F
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 22:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03410B8389F
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 05:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA50C3411D;
        Sat, 11 Jun 2022 05:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654924953;
        bh=da6K3VJ8BhAClCuMjegE4uQifbij4saB0PODv41jsl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WEM91+h3iOUcmGajW/nrQSrWkz0Xo+WOfCz+cVkit+lKyK5kSjCZ85QfZyxJJ43+j
         f1g8h6n2UsyIhMJ9tBtJtRwCb+oqAeKHQ26FxJ1AC0J9eB3em47BSoRXSjuCDeJy4r
         /aUu38I5E0GQ0d9BlSwPv3Anu6ky9TC84hulUOqApGwULbbaOJsvfxeaKZ3auHdWo5
         tYORcJxncs+f/DLuAexed/L2bpN3DYuPsWUEHeMARCif1Re8OhS6Uy+bKepBFrOtng
         bs9bJBGWwgBLqeE6mwT0s8wpb3i1hAZT1ucKw+U5LSgoULCjbZAE5va9zAaznypqu5
         j4ZStzTmt8apQ==
Date:   Fri, 10 Jun 2022 22:22:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>,
        Bin Chen <bin.chen@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next] ethernet: Remove vf rate limit check for
 drivers
Message-ID: <20220610222232.31c3e0e6@kernel.org>
In-Reply-To: <20220609084717.155154-1-simon.horman@corigine.com>
References: <20220609084717.155154-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jun 2022 10:47:17 +0200 Simon Horman wrote:
> From: Bin Chen <bin.chen@corigine.com>
> 
> The commit a14857c27a50 ("rtnetlink: verify rate parameters for calls to
> ndo_set_vf_rate") has been merged to master, so we can to remove the
> now-duplicate checks in drivers.

Thanks for the follow up!
