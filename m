Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0757A34C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237351AbiGSPg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbiGSPgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:36:49 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Jul 2022 08:36:48 PDT
Received: from smtp75.iad3a.emailsrvr.com (smtp75.iad3a.emailsrvr.com [173.203.187.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE270564E2
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 08:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1658244040;
        bh=adV58vm7/tjy+kwDeEpAfKovQjvWtkBDSOIQUg1vwNc=;
        h=Date:Subject:To:From:From;
        b=ujRI5ngutfmpo214226g48qNhkxDHOgiKqZQ2aUfjg8tEBd2Wtf7Nf5DBo2NbTZu6
         09kkqwsVYT9lK1cIJzurRErST8ZTKzTE/Y9tUF7pJNNHsl9H4Ql+FpjCWVFdY/Ljfy
         FR+y17lGx+y6J8vVqbvjPemSN48eNs/XeYFgjfU4=
X-Auth-ID: antonio@openvpn.net
Received: by smtp10.relay.iad3a.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id 129CA62BC;
        Tue, 19 Jul 2022 11:20:39 -0400 (EDT)
Message-ID: <7aeaf711-c18f-3442-be44-d820f2539a15@openvpn.net>
Date:   Tue, 19 Jul 2022 17:21:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net> <YtbLa54+0A4SyR9+@lunn.ch>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
In-Reply-To: <YtbLa54+0A4SyR9+@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: d2ebcfec-646c-42bf-a8b6-56f2520d45a0-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2022 17:19, Andrew Lunn wrote:
> As a general comment throughout the code, pr_ functions are not
> liked. Since this is a network device, it would be better to use
> netdev_debug(), netdev_warn() etc, so indicating which device is
> outputting warnings or debug info.

Thanks for the hint, Andrew!
I will convert the pr_* calls to netdev_*.

Regards,

-- 
Antonio Quartulli
OpenVPN Inc.
