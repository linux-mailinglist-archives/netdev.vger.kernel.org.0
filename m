Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C584EBABA
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 08:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243245AbiC3GYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 02:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238147AbiC3GYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 02:24:20 -0400
X-Greylist: delayed 12263 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Mar 2022 23:22:33 PDT
Received: from uriel.iewc.co.za (uriel.iewc.co.za [IPv6:2c0f:f720:0:3:d6ae:52ff:feb8:f27b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC2C51322;
        Tue, 29 Mar 2022 23:22:33 -0700 (PDT)
Received: from [2c0f:f720:fe16:c400::1] (helo=tauri.local.uls.co.za)
        by uriel.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1nZRiw-0002Oj-CB; Wed, 30 Mar 2022 08:22:30 +0200
Received: from [192.168.42.207]
        by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1nZRiv-0003gx-AZ; Wed, 30 Mar 2022 08:22:29 +0200
Message-ID: <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
Date:   Wed, 30 Mar 2022 08:22:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Content-Language: en-GB
To:     Eric Dumazet <edumazet@google.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <E1nZMdl-0006nG-0J@plastiekpoot>
 <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za>
 <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
From:   Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 2022/03/30 05:48, Eric Dumazet wrote:
> On Tue, Mar 29, 2022 at 7:58 PM Jaco Kroon <jaco@uls.co.za> wrote:
>
> I do not think this commit is related to the issue you have.
>
> I guess you could try a revert ?
>
> Then, if you think old linux versions were ok, start a bisection ?
That'll be interesting, will see if I can reproduce on a non-production
host.
>
> Thank you.
>
> (I do not see why a successful TFO would lead to a freeze after ~70 KB
> of data has been sent)

I do actually agree with this in that it makes no sense, but disabling
TFO definitely resolved the issue for us.

Kind Regards,
Jaco

