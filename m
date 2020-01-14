Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED13139FCA
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 04:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbgANDNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 22:13:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbgANDNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 22:13:50 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5C89214AF;
        Tue, 14 Jan 2020 03:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578971630;
        bh=rOpxXM202UQvQZhZH7oQtvt/ed36on649KoSjgs1IIc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oqnv/JimSD0m7kc6PWHNUuCgjb3FTGjDQQj6e1X8yilTYcMEO+nkp8Ky7K5gE3n0m
         aCE4wU7q5GDExne1melVbKl8af4t5BjmJgzramRB3wubFL29S/4DKOH+qxooldewrz
         zXW/HXmms8UPWCvdnnhIk6mO7AsVK3MMrN4Z1Nnk=
Date:   Mon, 13 Jan 2020 19:13:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: Re: [stable] wimax: i2400: fix memory leaks
Message-ID: <20200113191348.2bc68212@cakuba>
In-Reply-To: <cbed1d656d40ba099714b13f17b912a3dd30b402.camel@codethink.co.uk>
References: <cbed1d656d40ba099714b13f17b912a3dd30b402.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 23:39:57 +0000, Ben Hutchings wrote:
> It looks like these fixes are needed for 4.19 (and older stable
> branches):
> 
> commit 2507e6ab7a9a440773be476141a255934468c5ef
> Author: Navid Emamdoost <navid.emamdoost@gmail.com>
> Date:   Tue Sep 10 18:01:40 2019 -0500
> 
>     wimax: i2400: fix memory leak
> 
> commit 6f3ef5c25cc762687a7341c18cbea5af54461407
> Author: Navid Emamdoost <navid.emamdoost@gmail.com>
> Date:   Fri Oct 25 23:53:30 2019 -0500
> 
>     wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Queued, thank you Ben!

Navid, please make sure you always provide Fixes tags.
Patch with a CVE but without a Fixes tag is just extra 
work for many busy people...
