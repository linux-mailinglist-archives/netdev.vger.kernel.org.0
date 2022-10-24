Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3E460A000
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 13:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJXLPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 07:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJXLPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 07:15:06 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D24D2FC0D;
        Mon, 24 Oct 2022 04:15:01 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id D76A510000E;
        Mon, 24 Oct 2022 11:14:57 +0000 (UTC)
Message-ID: <9d30928d-d839-20bc-d101-91845ddfa871@ovn.org>
Date:   Mon, 24 Oct 2022 13:14:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     i.maximets@ovn.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFE net-next] net: tun: 1000x speed up
Content-Language: en-US
To:     Pavel Machek <pavel@ucw.cz>
References: <20221021114921.3705550-1-i.maximets@ovn.org>
 <20221024110847.GA527@duo.ucw.cz>
From:   Ilya Maximets <i.maximets@ovn.org>
In-Reply-To: <20221024110847.GA527@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/22 13:08, Pavel Machek wrote:
> Hi!
> 
>> Bump the advertised speed to at least match the veth.  10Gbps also
>> seems like a more or less fair assumption these days, even though
>> CPUs can do more.  Alternative might be to explicitly report UNKNOWN
>> and let the application/user decide on a right value for them.
>>
>> Link: https://mail.openvswitch.org/pipermail/ovs-discuss/2022-July/051958.html
>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>> ---
>>
>> Sorry for the clickbait subject line.  Can change it to something more
>> sensible while posting non-RFE patch.  Something like:
>>
>>   'net: tun: bump the link speed from 10Mbps to 10Gbps'
>>
>> This patch is RFE just to start a conversation.
> 
> Yeah, well, it seems that internet already fallen for your clickbait
> :-(.
> 
> https://www.phoronix.com/news/Linux-TUN-Driver-1000x
> 										Pavel
> 										

Oh, Wow...  Sorry about that. :/

Best regards, Ilya Maximets.
