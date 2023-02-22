Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A206269F0C1
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 09:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjBVI4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 03:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjBVI4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 03:56:11 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1211935267
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 00:56:09 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v3so6869283wrp.2
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 00:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2jzPt0G+YCQ9Tx5sx3XlNp/vxfc/b9lzP2yvXi20w/0=;
        b=LSInBIU56aAgf7yYeM3ew395VJFKgVISn7f+Gwr6QTc/qhRh62vNOVZkRySimzJ5ca
         5hlNNsGQJyD2Te/YGhHsHbkFFOAjB7Z4Ubj9zSTwNOxRUgUxSEjrPfV+k6p0NbsC4D83
         fjM8pU0g0QmCEGwWm76vp2b7xmUWmyTjKXnJp3P/Ya48IIxLe+tD77rWQGCQHrN3eXvJ
         awnapPLbwonnosUoiNui22kjvdFFvDPsOgKBtq00OJ5XMmi0BiVhcT2EIMddGRaKATzG
         lUQVeSHlW3oxa+rhOlw8wixSn2ksU8q2zDLHezn/u13EAaRHGhcj53dNMJgxnQyGjgAp
         yJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2jzPt0G+YCQ9Tx5sx3XlNp/vxfc/b9lzP2yvXi20w/0=;
        b=dskaXs/vkzyPaWiZlgV3ybssJGdfKF8btC+7ixVQs8wehRh569aeBTO+cbuOhXdhWz
         6H4Bg1Tdls2OEugOelauAWQjv4DBDzBSnAVchyMz/az09IF3CfN7SonHxNvv0gS8PGgv
         Gy6D4dzwAyMEaRhcg3rsFZxvujRoHham0wcFXYVQrf6ex6wkmP3UK1szF87iqoPQqnEf
         YAhjLSEuFn8dk4sAl3UoW8d9OPt9oKmjVyGeCEs4dXFPRBKB6q0JL9CPPaeBOOUjhS+w
         D2DKiW1JIlaoaM1iBh7A1+ypxc4aJCBR7kCaAwqJBliZtmR4yQRE0dNGeTB90VL5YQ5d
         Rc8A==
X-Gm-Message-State: AO0yUKVLYKSrljnq+CReayi5ZTRJcHTxVHs/aszZCWOsQ8C3ZuoShDrF
        gAgxWMXYecHSI9Z9kTf27otQUPZMRW0=
X-Google-Smtp-Source: AK7set8vdrw9egtiu1ImyieKbo894IWJvB0c8CcCRB//xgvGa/AyF8xj2byUZlRcQDM5gFGH6SVaWQ==
X-Received: by 2002:adf:e242:0:b0:2bf:c0e4:1bc5 with SMTP id bl2-20020adfe242000000b002bfc0e41bc5mr7125886wrb.56.1677056167471;
        Wed, 22 Feb 2023 00:56:07 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d4ed1000000b002c4084d3472sm3573276wrv.58.2023.02.22.00.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 00:56:07 -0800 (PST)
Date:   Wed, 22 Feb 2023 08:56:04 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, edward.cree@amd.com,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sfc: support offloading TC VLAN push/pop
 actions to the MAE
Message-ID: <Y/XYpLz6K78T2elz@gmail.com>
Mail-Followup-To: Edward Cree <ecree.xilinx@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, edward.cree@amd.com,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org
References: <20230216160442.48394-1-edward.cree@amd.com>
 <Y/HqGyFiIMFZRT7r@unreal>
 <8e7f4439-0a2c-7465-cca5-7b983ff10da7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e7f4439-0a2c-7465-cca5-7b983ff10da7@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 08:32:13PM +0000, Edward Cree wrote:
> On 19/02/2023 09:21, Leon Romanovsky wrote:
> > On Thu, Feb 16, 2023 at 04:04:42PM +0000, edward.cree@amd.com wrote:
> >> From: Edward Cree <ecree.xilinx@gmail.com>
> >>
> >> EF100 can pop and/or push up to two VLAN tags.
> >>
> >> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ...
> >> +	/* Translate vlan actions from bitmask to count */
> >> +	switch (act->vlan_push) {
> >> +	case 0:
> >> +	case 1:
> >> +		vlan_push = act->vlan_push;
> >> +		break;
> >> +	case 2: /* can't happen */
> > 
> > There is no need in case here as "default" will catch.
> > 
> >> +	default:
> >> +		return -EINVAL;
> >> +	case 3:
> >> +		vlan_push = 2;
> >> +		break;
> >> +	}
> >> +	switch (act->vlan_pop) {
> >> +	case 0:
> >> +	case 1:
> >> +		vlan_pop = act->vlan_pop;
> >> +		break;
> >> +	case 2: /* can't happen */
> >> +	default:
> >> +		return -EINVAL;
> > 
> > Please rely switch-case semantics and don't put default in the middle.
> 
> It's legal C and as far as I can tell there's nothing in coding-style.rst
>  about it; I did it this way so as to put the cases in the logical(?)
>  ascending order and try to make the code self-document the possible
>  values of the act-> fields.
> Arguably it's the 'default:' rather than the 'case 2:' that's unnecessary
>  as the switch argument is an unsigned:2 bitfield, so it can only take on
>  these four values.

Can you replace the switch statement with
 vlan_push = act->vlan_push & 1 + act->vlan_push & 2;
Even then it would seem prudent to guard against  act->vlan_push == 2.

Martin

> Although on revisiting this code I wonder if it makes more sense just to
>  use the 'count' (rather than 'bitmask') form throughout, including in
>  act->vlan_push/pop; it makes the tc.c side of the code slightly more
>  involved, but gets rid of this translation entirely.  WDYT?
> 
> -ed
