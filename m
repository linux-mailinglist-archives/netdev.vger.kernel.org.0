Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972F962CE7F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbiKPXHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbiKPXHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:07:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C307D6238F
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 15:07:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C04EB81F0D
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 23:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D717C433D6;
        Wed, 16 Nov 2022 23:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668640034;
        bh=+gR1PU11xXLiito02RRXIzV4qkrxM2MaPtomsH3lqpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mbFcg8l1+vddbUAiKN0z0oP5Wina6oKWefBJBE6Iq1bXc8emXvGTrhgRbLQLAeeqD
         U+ZOZobb3CxRUe52FHsArwSdSFQrSlxQL22Glduu5GqvZ89BDvTe6mKrRGQWPSr2VF
         q4VKovLC6jbxIaQMArenvrHN/Bd/IankyLcv/XfLjiofI4hO9a3sn3ZLDT59J+2Dvc
         YgEbCFegHi9OJgpUjX6TWPWGHvtlM029u4hYobVA2lITwZ/thwUf69PPbJ+P5UE6D+
         5pTSvr7AgNTPpQwyH63r07UT6tBAOjvNzc8Sg9SddKM7Zmy1+d5oB7fchu+wJTPPYw
         lGI3WNn9sLT0g==
Date:   Wed, 16 Nov 2022 15:07:13 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <Y3VtIWHAyjZeJVDh@x130.lan>
References: <cover.1667997522.git.leonro@nvidia.com>
 <Y3PV7HM5cDoZogCY@unreal>
 <20221115183020.GA704954@gauss3.secunet.de>
 <Y3Ph4Lnf2vV0Hx3U@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y3Ph4Lnf2vV0Hx3U@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 21:00, Leon Romanovsky wrote:
>On Tue, Nov 15, 2022 at 07:30:20PM +0100, Steffen Klassert wrote:
>> On Tue, Nov 15, 2022 at 08:09:48PM +0200, Leon Romanovsky wrote:
>> > On Wed, Nov 09, 2022 at 02:54:28PM +0200, Leon Romanovsky wrote:
>> > > From: Leon Romanovsky <leonro@nvidia.com>
>> > >
>> > > Changelog:
>> > > v7: As was discussed in IPsec workshop:
>> >
>> > Steffen, can we please merge the series so we won't miss another kernel
>> > release?
>>
>> I'm already reviewing the patchset. But as I said at the
>> IPsec workshop, there is no guarantee that it will make
>> it during this release cycle.
>

BTW mlx5 patches are almost ready and fully reviewed, will be ready by
early next week.

Steffen in case you will be ready, how do you want to receive the whole
package? I guess we will need to post all the patches for a final time,
including mlx5 driver.

