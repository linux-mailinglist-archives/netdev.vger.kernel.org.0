Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A156D529B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbjDCUhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjDCUhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:37:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7903A97
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 13:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D46D62AC8
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 20:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0E7C433EF;
        Mon,  3 Apr 2023 20:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680554239;
        bh=mf6N6scv0oJEDWntRaFE/QuUd2lXBBHpRKoAP9D5JDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sxOaWKXoAd8ZIUHEsO/jrqUTghW9kWWtm4KVBOa85SmeHzWOcmsMMwJf3BICsbFYS
         NH/2rcgnYij3cqmuVBIawUli8nizYdfPwCx1FbNvY/X7qm7DnufRWYgev4qMM6r2h1
         SpnnFzFSyEYb4239h5Jv0Kvr1Ia6mU3NHbpsnpLFXy/d5+YIPzbKpu3cPDktBUmn3C
         sJyGEpDbVuxrqW34OIYMC8ux1UrGGJdfGjEaUyuk5WnB0YqpbA2Oycc9FaMjl6J/OU
         nvKah4G9L26kojFYG0Y6TA4qSuU3t/aBJxoHcCm0QxNPQmSDbDPBpBuuWu4hnbNp5X
         O9pfpSLpx0W5w==
Date:   Mon, 3 Apr 2023 13:37:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
Subject: Re: [PATCH v8 net-next 05/14] pds_core: set up device and adminq
Message-ID: <20230403133717.2abbda69@kernel.org>
In-Reply-To: <cf47c976-2714-62b7-3e5e-436fcfc788d4@amd.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
        <20230330234628.14627-6-shannon.nelson@amd.com>
        <20230331220719.60bb08f3@kernel.org>
        <cf47c976-2714-62b7-3e5e-436fcfc788d4@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Apr 2023 12:48:33 -0700 Shannon Nelson wrote:
> > Also it'd be a little easier to review if the documentation was part
> > of the same patch as code :(  
> 
> Well, at least there is a doc file at the end of the patchset :-). 
> Shall I build up the pds_core.rst file little by little throughout the 
> patchset?

That'd be easier for review. Otherwise I have to keep jumping
between patches :(
