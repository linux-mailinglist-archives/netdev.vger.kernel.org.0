Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EACE14EDA2F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 15:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbiCaNHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 09:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbiCaNHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 09:07:22 -0400
Received: from smtp121.iad3b.emailsrvr.com (smtp121.iad3b.emailsrvr.com [146.20.161.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63F549916
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 06:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1648731933;
        bh=5NlUh8ccoqKKU3XgT+0pvTBYhHq5WjNg5LszWjJm0AY=;
        h=Date:To:From:Subject:From;
        b=BRruDZS78FtNdWkQH8M4ZO3dQljf5fWOW8Yh4LRAC2Ot+gLfsuAUq6dUbKzNKr6OL
         Pnu4Z/JDBWMkgSdLHfQ0Xmh/I/HcnVy/BuW+u0c8XEhaEkjnOTx+dCicARKli0QZmL
         ZXUtx+ftj5Kp3pC6C0gvnlSypdI8MHSTkcezpv0Y=
X-Auth-ID: antonio@openvpn.net
Received: by smtp24.relay.iad3b.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id F3157400F7;
        Thu, 31 Mar 2022 09:05:32 -0400 (EDT)
Message-ID: <e5553cba-c29d-0a22-c362-0ce1e1ef4b41@openvpn.net>
Date:   Thu, 31 Mar 2022 15:06:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Xin Long <lucien.xin@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
References: <cover.1612342376.git.lucien.xin@gmail.com>
 <fc62f5e225f83d128ea5222cc752cb1c38c92304.1612342376.git.lucien.xin@gmail.com>
 <3842df54-8323-e6e7-9a06-de1e78e099ae@openvpn.net>
 <YkMKAGujYMNOJMU6@kroah.com>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
Subject: Re: [PATCHv5 net-next 1/2] udp: call udp_encap_enable for v6 sockets
 when enabling encap
In-Reply-To: <YkMKAGujYMNOJMU6@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: ac5e4f50-e7a8-45e1-b549-c8f7bbe637db-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 29/03/2022 15:30, Greg Kroah-Hartman wrote:
>> I would like to propose to take this patch in stable releases.
>> Greg, is this an option?
>>
>> Commit in the linux kernel is:
>> a4a600dd301ccde6ea239804ec1f19364a39d643
> 
> 
> What stable tree(s) should this apply to, and where have you tested it?

Sorry for the delay, Greg, but I wanted to run some extra tests on the 
various longterm kernel releases.

This bug exists since "ever", therefore ideally it could/should be 
applied to all stable trees.

However, this patch applies as-is only to v5.10 and v5.4 (you need to 
ignore the hunk for 'drivers/net/bareudp.c' on the latter).

Older trees require a different code change.

My tests on v5.10 and v5.4 show that the patch works as expected.

Therefore, could it be backported to these 2 trees?
It can get my

Tested-by: Antonio Quartulli <antonio@openvpn.net>

Thanks a lot,

-- 
Antonio Quartulli
OpenVPN Inc.
