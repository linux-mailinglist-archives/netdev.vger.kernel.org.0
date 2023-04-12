Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1146DF2C6
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 13:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjDLLNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 07:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjDLLNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 07:13:30 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FB16EBA
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:13:19 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 225221251;
        Wed, 12 Apr 2023 13:12:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1681297975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mmjz7QWWbWqM3WXonx3bRwKcF0Apg79daSypMWbrEYw=;
        b=WoGPl/0h0VVAqotCoiWpPSzVpjpJh6u0UardwJcdDBr65IMkXvYfQmmUBoTdPivCAGOBZ6
        kUqHyNKsR8J8c9eIrbOdFFIgCEcam7jTgfCmDpsXUt3wL9J5vjATWf/H4IsaaPmnq2HcMJ
        DhVLX5vmWSC+mWSmzOam9ZV1t6gJr1Og1Nnar4L5aXT1qOC39Z1iDMTAFzpMEjyVumRQ3G
        5l3CdeFLGahLFtcQyOyPkTi0AfFR3c5eHHhE2kHvqppKGEImhroduE8tDF9TPY4cGhd3iT
        1pBMImmnVDZfDZUdnpGkXzM9cSwbeHHMYLFTvoqbNyINLHbql7o8Xy+THLq+6w==
MIME-Version: 1.0
Date:   Wed, 12 Apr 2023 13:12:54 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     kuba@kernel.org, gerhard@engleder-embedded.com, glipus@gmail.com,
        kory.maincent@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, maxime.chevallier@bootlin.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        robh+dt@kernel.org, thomas.petazzoni@bootlin.com,
        vadim.fedorenko@linux.dev
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
In-Reply-To: <20230412110840.vmuudkuh5zb3u426@skbuf>
References: <20230406184646.0c7c2ab1@kernel.org>
 <20230412105034.178936-1-michael@walle.cc>
 <20230412110840.vmuudkuh5zb3u426@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <d11aa2c9b888941385cbbd99000b94c6@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2023-04-12 13:08, schrieb Vladimir Oltean:
> On Wed, Apr 12, 2023 at 12:50:34PM +0200, Michael Walle wrote:
>> >> +/* Hardware layer of the SO_TIMESTAMPING provider */
>> >> +enum timestamping_layer {
>> >> +	SOF_MAC_TIMESTAMPING =3D (1<<0),
>> >> +	SOF_PHY_TIMESTAMPING =3D (1<<1),
>> >
>> > What does SOF_ stand for?
>> 
>> I'd guess start of frame. The timestamp will be taken at the
>> beginning of the frame.
> 
> I would suggest (with all due respect) that it was an inapt adaptation
> of the Socket Option Flags that can be seen in
> Documentation/networking/timestamping.rst.

Agreed. Noticing the other SOF_TIMESTAMPING_* names, your
suggestion makes way more sense. Sorry for the noise.

-michael
