Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED6D6DFF2E
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 21:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjDLTvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 15:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjDLTvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 15:51:08 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F601FFE;
        Wed, 12 Apr 2023 12:50:20 -0700 (PDT)
Received: from [192.168.2.51] (p4fc2f435.dip0.t-ipconnect.de [79.194.244.53])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id BA816C006B;
        Wed, 12 Apr 2023 21:50:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1681329007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OYszXDQDEy+KRWGHuZZ9FLDb+crUAan5/S25sGaF/ds=;
        b=NECSaBbG/6dTXqm/DJpE6+NslcQJx3nLxUMz/L0QFx+KS4+lZH1IqywXTk+HS/GVyuPymt
        W03xYv1miv5Ex0rD6QjTzPt8aZiHxzTTTIzMDQbXWsI2LiWZvXdec94Ml3tZr+1L93DHOZ
        HNSHsj2s4WTQqLITOE3qEd8dpesEcjhSKUzk67AFo95zVnSbEquyZvtXZaTWXv82aKOrpz
        S96y4qwdLKaENJt3XqcGYwlhaVwk9Gx7U7tXqX/JFWH23IcswA52csuGmGDtEV1Feq7VRn
        u0pXDU0jYTx1SPkREqhVBoXPRvb7ZeC0pPmyYDIw3EalS2AR0e9srixyj1wMbw==
Message-ID: <992405e3-c2d2-95ae-a937-a501baf06f2c@datenfreihafen.org>
Date:   Wed, 12 Apr 2023 21:50:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH wpan-next 1/2] MAINTAINERS: Update wpan tree
Content-Language: en-US
To:     Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
References: <20230411090122.419761-1-miquel.raynal@bootlin.com>
 <CAB_54W6tnKmjmRAmA=pZPUucDvmROTx-Xx3V1k2Ms=nemC_Vjw@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAB_54W6tnKmjmRAmA=pZPUucDvmROTx-Xx3V1k2Ms=nemC_Vjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 11.04.23 14:11, Alexander Aring wrote:
> Hi,
> 
> On Tue, Apr 11, 2023 at 5:01 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>>
>> The wpan maintainers group is switching from Stefan's tree to a group
>> tree called 'wpan'. We will now maintain:
>> * wpan/wpan.git master:
>>    Fixes targetting the 'net' tree
>> * wpan/wpan-next.git master:
>>    Features targetting the 'net-next' tree
>> * wpan/wpan-next.git staging:
>>    Same as the wpan-next master branch, but we will push there first,
>>    expecting robots to parse the tree and report mistakes we would have
>>    not catch. This branch can be rebased and force pushed, unlike the
>>    others.
>>
>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
