Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40BE1B94D4
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 03:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgD0BFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 21:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726227AbgD0BFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 21:05:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C15C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 18:05:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE29615CAB770;
        Sun, 26 Apr 2020 18:05:08 -0700 (PDT)
Date:   Sun, 26 Apr 2020 18:05:05 -0700 (PDT)
Message-Id: <20200426.180505.1265322367122125261.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, mstarovoitov@marvell.com,
        dbogdanov@marvell.com
Subject: Re: [EXT] Re: [PATCH net-next 08/17] net: atlantic: A2
 driver-firmware interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d02ab18b-11b4-163c-f376-79161f232f3e@marvell.com>
References: <20200424174447.0c9a3291@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200424.182532.868703272847758939.davem@davemloft.net>
        <d02ab18b-11b4-163c-f376-79161f232f3e@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Apr 2020 18:05:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Sun, 26 Apr 2020 11:50:19 +0300

> 
>> From: Jakub Kicinski <kuba@kernel.org>
>> Date: Fri, 24 Apr 2020 17:44:47 -0700
>> 
>>> On Fri, 24 Apr 2020 10:27:20 +0300 Igor Russkikh wrote:
>>>> +/* Start of HW byte packed interface declaration */
>>>> +#pragma pack(push, 1)
>>>
>>> Does any structure here actually require packing?
>> 
>> Yes, please use the packed attribute as an absolute _last_ resort.
> 
> These are HW bit-mapped layout API, without packing compiler may screw up
> alignments in some of these structures.

The compiler will not do that if you used fixed sized types properly.

Please remove __packed unless you can prove it matters.
