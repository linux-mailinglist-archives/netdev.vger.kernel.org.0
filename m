Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E0E117285
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfLIRLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:11:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:32928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfLIRLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:11:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 587FC15433951;
        Mon,  9 Dec 2019 09:11:29 -0800 (PST)
Date:   Mon, 09 Dec 2019 09:11:26 -0800 (PST)
Message-Id: <20191209.091126.397853146180657876.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     arnd@arndb.de, devel@driverdev.osuosl.org, johan.hedberg@gmail.com,
        netdev@vger.kernel.org, marcel@holtmann.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 1/2] staging: remove isdn capi drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209153743.GA1284708@kroah.com>
References: <20191209151114.2410762-1-arnd@arndb.de>
        <20191209153743.GA1284708@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 09:11:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 9 Dec 2019 16:37:43 +0100

> On Mon, Dec 09, 2019 at 04:11:13PM +0100, Arnd Bergmann wrote:
>> As described in drivers/staging/isdn/TODO, the drivers are all
>> assumed to be unmaintained and unused now, with gigaset being the
>> last one to stop being maintained after Paul Bolle lost access
>> to an ISDN network.
>> 
>> The CAPI subsystem remains for now, as it is still required by
>> bluetooth/cmtp.
>> 
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Nice!  You beat me to it :)
> 
> I'll go queue this up soon.
> 
> David, any objection for me taking patch 2/2 here as well?

No objections.
