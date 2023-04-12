Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AB46DFF37
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 21:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDLTxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 15:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjDLTxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 15:53:14 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1281FFE;
        Wed, 12 Apr 2023 12:52:45 -0700 (PDT)
Received: from [192.168.2.51] (p4fc2f435.dip0.t-ipconnect.de [79.194.244.53])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 0E639C042A;
        Wed, 12 Apr 2023 21:51:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1681329075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rHhIv4XRWuvy0SOWZF0k4Hfl2JiKD/56whRvSjhKz9E=;
        b=pgd0CnYchBrUg9IrnuBJXh8qHrspvfwlAKkJncEANg6JarE5CBfb20giSOXEZ1rXvAypDI
        e5ZvA0wA7v6wBQpj+QtXFeY+SP64AMmbLtvUv7NrAN3zgJT8olOg2FxRXZNdCuT2EwgARY
        XJ3Yp2HTlkmG4LFYDORUPerFhuSaVyIZEEdUPaX3xgNV75aZkWFr31AMhG8NaOJ9uJmuZ2
        i5uqEyPMYjdbKnWJu7SrApkvTyxnBv0afxLS6V5EuNo7WlxB0UhjsFHgnOFrYeUE7F7mf5
        Hh+ojStCllCzzHakZstwj/wkzxVhpPYaOLn6/ReFfdAikVU7l3k7XQ+yYIyDtA==
Message-ID: <7978e5ed-56aa-dc01-957c-3f110a92ce5f@datenfreihafen.org>
Date:   Wed, 12 Apr 2023 21:51:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH wpan-next 1/2] MAINTAINERS: Update wpan tree
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
References: <20230411090122.419761-1-miquel.raynal@bootlin.com>
 <20230411130209.6ffe1d21@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230411130209.6ffe1d21@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

On 11.04.23 22:02, Jakub Kicinski wrote:
> On Tue, 11 Apr 2023 11:01:21 +0200 Miquel Raynal wrote:
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
> 
> Very nice, feel free to ship these two with fixes.
> We often fast track MAINTAINERS updates.

That's what I did. Coming with the next ieee802154 pull request to net.

regards
Stefan Schmidt
