Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65DC1AB491
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 02:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391149AbgDPAEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 20:04:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729647AbgDPAEK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 20:04:10 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DC162076A;
        Thu, 16 Apr 2020 00:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586995450;
        bh=UIWDmQbB1UY5Ns14fq6mzzwec6zw/Zw3l4914qV/fHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N6FhTFCIVRUDGmowtBbsBqzyL/zw65UXrB22QuaiIQd21guALgkiJCkwKUAWhghmt
         Q1mMbiWn6PZnvkcQrorrx6ev5UidTk3KZ9kRos7UOUlfTiudG74A1l3Da74v5bLjtZ
         BukyFvuKdDoEuI6p00g1okLiismXxbaJioJ0Nrec=
Date:   Wed, 15 Apr 2020 20:04:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Kees Cook <keescook@chromium.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net
Subject: Re: [PATCH AUTOSEL 5.6 068/129] slcan: Don't transmit uninitialized
 stack data in padding
Message-ID: <20200416000409.GM1068@sasha-vm>
References: <20200415113445.11881-1-sashal@kernel.org>
 <20200415113445.11881-68-sashal@kernel.org>
 <87h7xkisln.fsf@x220.int.ebiederm.org>
 <20200415172243.GA3661754@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200415172243.GA3661754@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 07:22:43PM +0200, Greg KH wrote:
>On Wed, Apr 15, 2020 at 12:09:08PM -0500, Eric W. Biederman wrote:
>>
>> How does this differ from Greg's backports of this patches?
>
>His tool didn't catch that they are already in a merged tree, it's a few
>steps later that this happens :)

My process for doing these takes a day or two (or three) to build test,
test, and send mails. Sometimes Greg beats me to it :)

-- 
Thanks,
Sasha
