Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1477C6DF235
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 12:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjDLKuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 06:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDLKuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 06:50:46 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8A76A40
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 03:50:43 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 69BBE1251;
        Wed, 12 Apr 2023 12:50:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1681296640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++ImFyNZjyXGnAI7hQxYxl6unqA4tyL9j1pKeX2VQO0=;
        b=14FSRd7+o8icS4DTA9G4tA8Hbv+9vRfhAzzNVkpzghRi05J68+CelsVmYhrE4hKyloYzKo
        Ofoc8owkyu1iSP/1T95ePwKHRdFadYskjN52wsqBYVnHnBNmTl/Xjx5jKZZFaVoMJG036v
        FyamY/5yl6UeP+Kh19K7IhT/JGIf+dL+dquZQfIxfH3w3JZenoKgyY0sit/BJgIAb06+3s
        A4ICBVOxC5Zfgzkrt1ojNMAm2vLoyb8VQm4rZC63CeSt+op6QxOt5a4a3iqra0mqbCsMh8
        rg/SvP/KFXYeHBOhNYaeOKVtwgfu2wnNOnGmh+8HyMOxVzjL42t/rNs9fGz3Bg==
From:   Michael Walle <michael@walle.cc>
To:     kuba@kernel.org
Cc:     gerhard@engleder-embedded.com, glipus@gmail.com,
        kory.maincent@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, maxime.chevallier@bootlin.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        robh+dt@kernel.org, thomas.petazzoni@bootlin.com,
        vadim.fedorenko@linux.dev, vladimir.oltean@nxp.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping layers to user space.
Date:   Wed, 12 Apr 2023 12:50:34 +0200
Message-Id: <20230412105034.178936-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230406184646.0c7c2ab1@kernel.org>
References: <20230406184646.0c7c2ab1@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +/* Hardware layer of the SO_TIMESTAMPING provider */
>> +enum timestamping_layer {
>> +	SOF_MAC_TIMESTAMPING =3D (1<<0),
>> +	SOF_PHY_TIMESTAMPING =3D (1<<1),
>
> What does SOF_ stand for?

I'd guess start of frame. The timestamp will be taken at the
beginning of the frame.

-michael
