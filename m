Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C766C1F3E
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjCTSNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCTSNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:13:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977A91E9FA;
        Mon, 20 Mar 2023 11:07:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55049B81052;
        Mon, 20 Mar 2023 18:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2642C4339B;
        Mon, 20 Mar 2023 18:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679335634;
        bh=36zZJaP15lU/DAfQXwCuDp6WzbDW9TdMEQ5YISr/ta0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TvJFUgOV4+CjcznHX3ztiMjH4e1finCQbN4ubA88P8XpXoh7G1XLJpawCFwIHDJKs
         06gvdS20jkoYFWDEC9N0qg0LbYj+9D6vmHcRxeBLXJ9uqptVnJ4xAL43CX3sVfhyPx
         neCJ3+G5mMfKBJs7Tn/3Hm7aFd75p7D/dT9B+2VFM0SpyoehCghdtpLG3d0CtmKTM0
         WJQqZiQzvHYkOgQzbvbY/KoNCokLIT4I7FSXxVzovEn3Pf6kiVaqBWVeo/4khFUuQm
         HkHEeAZEbjg/LlhuuhFOzNSazc61NOyZD/16dz0v0noC/8kQ/7oLgM09C14nl/FtPB
         bzczjO08Gi0kw==
Date:   Mon, 20 Mar 2023 11:07:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        jesse.brandeburg@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next] ixgb: Remove ixgb driver
Message-ID: <20230320103103.22488dc7@kernel.org>
In-Reply-To: <20230317200904.3796436-1-anthony.l.nguyen@intel.com>
References: <20230317200904.3796436-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 13:09:03 -0700 Tony Nguyen wrote:
> There are likely no users of this driver as the hardware has been
> discontinued since 2010. Remove the driver and all references to it
> in documentation.

Thank you! =F0=9F=A7=B9=EF=B8=8F=F0=9F=A7=B9=EF=B8=8F
