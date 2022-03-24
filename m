Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B854E688D
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 19:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244665AbiCXSWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 14:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241513AbiCXSV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 14:21:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DDFB7176;
        Thu, 24 Mar 2022 11:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B48E1B8250B;
        Thu, 24 Mar 2022 18:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E2EC340F0;
        Thu, 24 Mar 2022 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648146023;
        bh=7ITnYalcxmJRyuoqr47/CUMJHt7HpTkm0ce8wwF/42c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HhQaWrCwPfXRimeJI1RBChGpRecL4Thp/1QmcidH12Ax/rHOTlijWUfROrJwAfWiE
         eW1eSCUjh2tphNMqHCOI/fxrme/AQH+gwpZn6KlgOrAt86+xZrWJjkEcsUTLXFh7Be
         E+tz0i287sxe/qq3A0c3zZKCgDcPmMFIyvlQ4wqnCoEOyOzdw9z0xaGSOzc7GRWbEw
         If5trqaBOKQCv8POYT/6+S5PJrhL6LgS77n1qGhYNzNKaCmVBSLYzWAEAi+41EBW61
         hdBQULJanprqJqA/YJZMS0W7vT3a8mtMJFP0UNhiNONYH80bqkjuB/lSgp+wUuek7s
         0G7xDQ+FYASpg==
Date:   Thu, 24 Mar 2022 11:20:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        imagedong@tencent.com, edumazet@google.com, dsahern@kernel.org,
        talalahmad@google.com, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 1/3] skbuff: add a basic intro doc
Message-ID: <20220324112021.7f7d6e8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87a6dfigfi.fsf@meer.lwn.net>
References: <20220323233715.2104106-1-kuba@kernel.org>
        <20220323233715.2104106-2-kuba@kernel.org>
        <87a6dfigfi.fsf@meer.lwn.net>
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

On Thu, 24 Mar 2022 08:16:49 -0600 Jonathan Corbet wrote:
> > +:c:type:`struct sk_buff` is the main networking structure representing
> > +a packet.  
> 
> You shouldn't need :c:type: here, our magic stuff should see "struct
> sk_buff" and generate the cross reference.  Of course, it will be a
> highly local reference in this case...

Thanks! I'll fix in v1, I must admit I added this last minute and I hit
send before the build finished :S
