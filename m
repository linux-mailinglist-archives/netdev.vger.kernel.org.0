Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6533C55DA16
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbiF0WIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 18:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242029AbiF0WH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 18:07:29 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8642BC31
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 15:04:53 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 6E6E150057F;
        Tue, 28 Jun 2022 01:03:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 6E6E150057F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656367395; bh=jGaDFoI6IQoF0vY7kOqp0aU1M8SCsUgBGpdsKiEkDl4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=urkc0Cy2+yk/gY+ZLxZEbOdj3hTC2UYvY3kR2XVfzInqQGRZ72i4hOfgpTIKVgj1x
         HYYDqy4Yc+39BEtC1ThpD/wGVG1rAz3JK1z7Wt11o/Jk0daI2lhbSyCZFxXVWLW1ja
         kN/bj4bBpZz58tY325k+q+d29AvsD+u9i+mPfc3I=
Message-ID: <11daa581-65c2-47d5-8bd3-78757fd55ee3@novek.ru>
Date:   Mon, 27 Jun 2022 23:04:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v1 3/3] ptp_ocp: implement DPLL ops
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@fb.com>,
        Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20220623005717.31040-1-vfedorenko@novek.ru>
 <20220623005717.31040-4-vfedorenko@novek.ru>
 <20220623182813.safjhwvu67i4vu3b@bsd-mbp.dhcp.thefacebook.com>
 <80568c10-2d73-2a68-aed6-a553ae2410f8@novek.ru>
 <20220627192354.pyy2lcyy4aiz6s4l@bsd-mbp.dhcp.thefacebook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220627192354.pyy2lcyy4aiz6s4l@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.06.2022 20:23, Jonathan Lemon wrote:
> On Sun, Jun 26, 2022 at 08:27:17PM +0100, Vadim Fedorenko wrote:
>> On 23.06.2022 19:28, Jonathan Lemon wrote:
>>> On Thu, Jun 23, 2022 at 03:57:17AM +0300, Vadim Fedorenko wrote:
>>>> From: Vadim Fedorenko <vadfed@fb.com>
>>>>
>>>> +static int ptp_ocp_dpll_get_status(struct dpll_device *dpll)
>>>> +{
>>>> +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>>>> +	int sync;
>>>> +
>>>> +	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>>>> +	return sync;
>>>> +}
>>>
>>> Please match existing code style.
>>>
>>
>> Didn't get this point. The same code is used through out the driver.
>> Could you please explain?
> 
> Match existing function definition style.

Got it. Will address in the next version, thanks!
