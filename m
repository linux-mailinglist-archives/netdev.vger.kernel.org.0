Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA57D58468E
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiG1TQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiG1TQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:16:15 -0400
Received: from smtp116.ord1d.emailsrvr.com (smtp116.ord1d.emailsrvr.com [184.106.54.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99610FD1B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1659035774;
        bh=SeMSQnT6wZkcTf3H3sQpzQpbLlpeUjeQJXewNPiwe+0=;
        h=Date:Subject:To:From:From;
        b=cr/rxuPX78wSfyIUVkoK9+1hub+katxpA/Xlb2aAaEVDL/iG4pjI7p43Gt1dKu5k1
         fRGGGguDje1vqVhvyC+b2mBe0g0SNNsWjWirccEFmY7CbvXBjouCSWn60nDcKc1Tsb
         QVQWRF8KybegjRFGt4741w/sZ1MoJrBWYM4GGhl8=
X-Auth-ID: antonio@openvpn.net
Received: by smtp15.relay.ord1d.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id 0BF92601D4;
        Thu, 28 Jul 2022 15:16:12 -0400 (EDT)
Message-ID: <7c690a60-103d-47c6-022a-5f2588c1fd87@openvpn.net>
Date:   Thu, 28 Jul 2022 21:16:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net> <YtbNBUZ0Kz7pgmWK@lunn.ch>
 <c490b87c-085b-baca-b7e4-c67a3ee2c25e@openvpn.net>
 <20220728092848.36c6ccd5@kernel.org>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
In-Reply-To: <20220728092848.36c6ccd5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 42921ce1-6c69-4280-8ab3-968aa8b9941a-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/2022 18:28, Jakub Kicinski wrote:
> On Thu, 28 Jul 2022 09:41:11 +0200 Antonio Quartulli wrote:
>> However, I guess I will still fill MODULE_VERSION() with a custom
>> string. This may also be useful when building the module out-of-tree.
> 
> Please use the kernel versions for versioning the out of tree code.
> Whenever a new release is cut upstream you bump the number
> appropriately in oot, and adjust whatever compat code needs adjusting.

Thanks for the hint about the versioning!
Will definitely use the kernel version once we are hooked.


-- 
Antonio Quartulli
OpenVPN Inc.
