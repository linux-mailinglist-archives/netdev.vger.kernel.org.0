Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF4D4D28A2
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiCIGBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiCIGBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:01:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61339145627
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 22:00:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECF6BB81F3D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 06:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DA6C340EE;
        Wed,  9 Mar 2022 06:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646805640;
        bh=3fwXE7/+x9O8T4InJ4Fs7A77Ci0P9iGKNgLvecJDp3o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UC7d69wKQZviKne0WmusUeJuTG7IK9h+DPLf7FkJe84hczpYbGOnZeJe3k7evOKsx
         5ZlmBZMy8emRJoUdyEm0v4lz8GVNAOtSun7dx2Y39Qy7tt1yPnFMsGMDH/BEUbT1WK
         oHioBdkNm8OqFU8+gc1QS5O385zGO5UotKOevtzWg7qxzyEjTVeM8hNIBpchHk6Rf9
         2kSlb789QkeWS5DX8LveSsT1y6BNBLJsCJEla6doOiio6gYEDYxYfEwV6JI7icGOCN
         abj7TKNOaBtrGG3a8MiA4TI9GyiTsMGCc0UHfqUj+/GalgrGJtVK11s9IcVMquJ7aQ
         gP+F5xfXDAUNw==
Date:   Tue, 8 Mar 2022 22:00:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, rdunlap@infradead.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next 1/2] net/tls: Provide {__,}tls_driver_ctx()
 unconditionally
Message-ID: <20220308220039.7389724b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309034032.405212-2-dmichail@fungible.com>
References: <20220309034032.405212-1-dmichail@fungible.com>
        <20220309034032.405212-2-dmichail@fungible.com>
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

On Tue,  8 Mar 2022 19:40:31 -0800 Dimitris Michailidis wrote:
> Having the definitions of {__,}tls_driver_ctx() under an #if
> guard means code referencing them also needs to rely on the
> preprocessor. The protection doesn't appear needed so make the
> definitions unconditional.
> 
> Fixes: db37bc177dae ("net/funeth: add the data path")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
