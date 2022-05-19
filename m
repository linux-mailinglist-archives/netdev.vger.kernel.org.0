Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91C152DCDA
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244083AbiESSbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244013AbiESSbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:31:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC3C52B17
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:31:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C00FB827D6
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64A2C385AA;
        Thu, 19 May 2022 18:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652985083;
        bh=PwDQ/E+c0RPinCwMKdF3OoSVHKuvOwCSgtfUKlfaPBs=;
        h=Date:From:To:Cc:Subject:From;
        b=gXO9fBjTXNwVH3tmQ3KYNvCW1J8dmSGuLx+N/inIF9P6qzvxvUun0iXTx7h8498OK
         qZBNLSgzjTEZk76sJoqt45YF817MrFUCmJJ4HwbYWXOcWViuueW1Yfak4ztcwgKOjd
         uHk+7snI6bjlYec1eJ4dTz4CMan7HBdTAzql5OmamLxDoV4gXdJ1fBkehUFVnINidy
         IOaaxzbLHxE1EnlWpKYCP8gLK9EuKP66t32YowKlzReiPgHFUqePGAmeV4hYpdNcAN
         H760LPk3f/UFfa4AJZlzhyqUX1BR3tG5QR6dJlio/xH/kK+lAbPCLNnepkM4b+IcFB
         5p3qDMNsbrA6g==
Date:   Thu, 19 May 2022 11:31:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: net <> net-next conflicts
Message-ID: <20220519113122.6bb6809a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

The conflicts in today's net -> net-next merge were pretty tedious.

First off - please try to avoid creating them.

If they are unavoidable - please include the expected resolution
in the cover letter and mark the cover letter with [conflict] 
(i.e.  [PATCH tree 0/n][conflict]) so we can easily find them days 
later when doing the merge.

Thanks!
