Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A608E119093
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLJT2V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Dec 2019 14:28:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47454 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJT2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:28:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3186C146D1AB2;
        Tue, 10 Dec 2019 11:28:20 -0800 (PST)
Date:   Tue, 10 Dec 2019 11:28:17 -0800 (PST)
Message-Id: <20191210.112817.1801022311000396362.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        marcelo.leitner@gmail.com, stranche@codeaurora.org,
        edumazet@google.com, linux-sctp@vger.kernel.org,
        subashab@codeaurora.org
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHo-OowHek4i9Pzxn96u8U5sTH8keQmi-yMCY-OBS7CE74OGNQ@mail.gmail.com>
References: <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
        <20191209161835.7c455fc0@cakuba.netronome.com>
        <CAHo-OowHek4i9Pzxn96u8U5sTH8keQmi-yMCY-OBS7CE74OGNQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 11:28:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Tue, 10 Dec 2019 12:46:29 +0100

> At some point essays and discussions belong in email and not in the
> commit message.

Wrong, full details on the context and impetus matter, no matter how
voluminous.

If you put what you ate for breakfast in the commit log message I wouldn't
complain.
