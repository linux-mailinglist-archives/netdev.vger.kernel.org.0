Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E7F1B8305
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 03:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgDYBZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 21:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgDYBZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 21:25:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9502CC09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 18:25:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 224C615073351;
        Fri, 24 Apr 2020 18:25:35 -0700 (PDT)
Date:   Fri, 24 Apr 2020 18:25:32 -0700 (PDT)
Message-Id: <20200424.182532.868703272847758939.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     irusskikh@marvell.com, netdev@vger.kernel.org,
        mstarovoitov@marvell.com, dbogdanov@marvell.com
Subject: Re: [PATCH net-next 08/17] net: atlantic: A2 driver-firmware
 interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424174447.0c9a3291@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
        <20200424072729.953-9-irusskikh@marvell.com>
        <20200424174447.0c9a3291@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 18:25:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 24 Apr 2020 17:44:47 -0700

> On Fri, 24 Apr 2020 10:27:20 +0300 Igor Russkikh wrote:
>> +/* Start of HW byte packed interface declaration */
>> +#pragma pack(push, 1)
> 
> Does any structure here actually require packing?

Yes, please use the packed attribute as an absolute _last_ resort.
