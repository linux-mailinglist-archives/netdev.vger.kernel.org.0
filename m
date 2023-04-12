Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CCC6DFF35
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 21:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjDLTw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 15:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDLTwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 15:52:21 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB01768B;
        Wed, 12 Apr 2023 12:51:46 -0700 (PDT)
Received: from [192.168.2.51] (p4fc2f435.dip0.t-ipconnect.de [79.194.244.53])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 1A8C7C08A3;
        Wed, 12 Apr 2023 21:50:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1681329033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N0mmHvziHXPPkSMv4GUPva5dnH20AV1HPLFo2iqYQWc=;
        b=M8SXG2SJM3AYm4AibzsKVLUCdbCSUYx7wtwbGG1MiIeJF7fYINvaRmb3PlNYzrGMJ8cx2l
        RgO7EuSPTnuW004LJtV7/HbcZ+Cw0dnAPiB5ut2E3UtXiv+wFObh+2J9/g/fh161KeXZsf
        asxXeCWUPWVKlqK+Ua7fhuRpAtWYbPJO9Cza0rg16stLd/TbHSrBS+0FljGytlRvTH2hx1
        cCAxeoQWTfbgBUPzawmeOpV9adKUkFkPZWNmqH5i03TY4JdDkx8zA4XA8ekr+2NVYm4zFF
        f+KHqInfLS6ws0v0Q6Yv3pN2d6w8cmRBlXrYAy7CQgbzW7RGM9gjjPDdE14AVw==
Message-ID: <cdad4dbe-ec72-627b-901a-213be82db5a1@datenfreihafen.org>
Date:   Wed, 12 Apr 2023 21:50:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH wpan-next 2/2] MAINTAINERS: Add wpan patchwork
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
References: <20230411090122.419761-1-miquel.raynal@bootlin.com>
 <20230411090122.419761-2-miquel.raynal@bootlin.com>
 <CAK-6q+gNq_dX0_EVrc1Sa8OxBUCFV6hpqmMokLiBbRLDUzXiMg@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAK-6q+gNq_dX0_EVrc1Sa8OxBUCFV6hpqmMokLiBbRLDUzXiMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 11.04.23 14:13, Alexander Aring wrote:
> Hi,
> 
> On Tue, Apr 11, 2023 at 5:03 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>>
>> This patchwork instance is hosted on kernel.org and has been used for a
>> long time already, it was just not mentioned in MAINTAINERS.
>>
>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
