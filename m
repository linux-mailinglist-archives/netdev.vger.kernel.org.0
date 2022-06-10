Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F105546993
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346021AbiFJPjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345410AbiFJPjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:39:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461E72945D6;
        Fri, 10 Jun 2022 08:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B06261F9B;
        Fri, 10 Jun 2022 15:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850AFC34114;
        Fri, 10 Jun 2022 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654875559;
        bh=0YV5Bhw/4d55YAwiUrbPCrQ1q4G7AwKMvir9aX7y6ok=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PsBKNm5pYWJd8zWQeM4m5JiOWWw4DY4ew5R6uEagEsbavET/Wx4b1qP7mzctsgCdH
         IhhllGimvmoSUf31cL+30ctdW5HqvnCeduch0y+L3xOokDUx3BklaO9kKFl9OI3NtC
         9NrKJHtObmsl6EXfU3IAnq2iq/zm7jJUHrcps27fXym0eCFqZNEx+D0vMzXSqNghM2
         OV+RZKzNqKNEzUe1U4PkL7vLwI5GbsND2zRlX6ek3WZmQlLdiZ3lmE8mDJVV1nJkhb
         6IjDJnoTRdB3nMAh86YqBoDL9QC1p4DchHInUWUJmtlDl1R24T4P0NG29u0sqnBYqf
         6ztZ1I+BkkMxA==
Date:   Fri, 10 Jun 2022 08:39:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v1 1/5] ptp_ocp: use dev_err_probe()
Message-ID: <20220610083918.65f3baeb@kernel.org>
In-Reply-To: <YqMmZBEsCv+f19se@smile.fi.intel.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
        <20220608120358.81147-2-andriy.shevchenko@linux.intel.com>
        <20220609224523.78b6a6e6@kernel.org>
        <YqMmZBEsCv+f19se@smile.fi.intel.com>
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

On Fri, 10 Jun 2022 14:09:24 +0300 Andy Shevchenko wrote:
> I have just checked that if you drop this patch the rest will be still
> applicable. If you have no objections, can you apply patches 2-5 then?

It's tradition in netdev to ask people to repost. But looks completely
safe for me to drop patch 1, so applied 2-5. Don't tell anyone I did this.
