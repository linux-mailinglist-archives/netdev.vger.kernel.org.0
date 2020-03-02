Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4AD1763FB
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCBTbW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Mar 2020 14:31:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52734 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgCBTbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 14:31:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C65F148774D4;
        Mon,  2 Mar 2020 11:31:22 -0800 (PST)
Date:   Mon, 02 Mar 2020 11:31:21 -0800 (PST)
Message-Id: <20200302.113121.562858661345596228.davem@davemloft.net>
To:     jgross@suse.com
Cc:     kda@linux-powerpc.org, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f8aa7d34-582e-84de-bf33-9551b31b7470@suse.com>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
        <f8aa7d34-582e-84de-bf33-9551b31b7470@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Mar 2020 11:31:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jürgen Groß <jgross@suse.com>
Date: Mon, 2 Mar 2020 16:29:41 +0100

> On 02.03.20 15:21, Denis Kirjanov wrote:
>> the patch adds a basic xdo logic to the netfront driver
>> XDP redirect is not supported yet
>> v2:
>> - avoid data copying while passing to XDP
>> - tell xen-natback that we need the headroom space
> 
> Please add the patch history below the "---" delimiter

Incorrect, I prefer to have them in the commit message and recorded
in the GIT history.

Please don't give out this advice for networking changes.

Thank you.
