Return-Path: <netdev+bounces-8075-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A89747229FE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63911280DDE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CEA1F194;
	Mon,  5 Jun 2023 14:47:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5616510FB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:47:38 +0000 (UTC)
Received: from bagheera.iewc.co.za (bagheera.iewc.co.za [154.73.34.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2688E9
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:47:32 -0700 (PDT)
Received: from [154.73.32.4] (helo=tauri.local.uls.co.za)
	by bagheera.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <jaco@uls.co.za>)
	id 1q6BUB-0000GD-5A; Mon, 05 Jun 2023 16:47:07 +0200
Received: from [192.168.1.145]
	by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
	(envelope-from <jaco@uls.co.za>)
	id 1q6BUA-0003YV-BL; Mon, 05 Jun 2023 16:47:06 +0200
Message-ID: <36743946-9616-88f6-a1f0-5a617cc79c5c@uls.co.za>
Date: Mon, 5 Jun 2023 16:47:05 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] net/pppoe: fix a typo for the PPPOE_HASH_BITS_1
 definition
Content-Language: en-GB
To: Simon Horman <simon.horman@corigine.com>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230605072743.11247-1-lukas.bulwahn@gmail.com>
 <ZH3SEl7ZT+MBI7V0@corigine.com>
From: Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <ZH3SEl7ZT+MBI7V0@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/06/05 14:16, Simon Horman wrote:
> On Mon, Jun 05, 2023 at 09:27:43AM +0200, Lukas Bulwahn wrote:
>> Instead of its intention to define PPPOE_HASH_BITS_1, commit 96ba44c637b0
>> ("net/pppoe: make number of hash bits configurable") actually defined
>> config PPPOE_HASH_BITS_2 twice in the ppp's Kconfig file due to a quick
>> typo with the numbers.
>>
>> Fix the typo and define PPPOE_HASH_BITS_1.
>>
>> Fixes: 96ba44c637b0 ("net/pppoe: make number of hash bits configurable")
>> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
Reviewed-by: Jaco Kroon <jaco@uls.co.za>

Sorry about that, that was indeed blonde.  Thanks for the fixup.

Kind Regards,
Jaco


