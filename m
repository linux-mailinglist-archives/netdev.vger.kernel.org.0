Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14721619C1
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 19:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgBQScl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 13:32:41 -0500
Received: from forward501j.mail.yandex.net ([5.45.198.251]:52494 "EHLO
        forward501j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726707AbgBQScl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 13:32:41 -0500
Received: from mxback2g.mail.yandex.net (mxback2g.mail.yandex.net [77.88.29.163])
        by forward501j.mail.yandex.net (Yandex) with ESMTP id 8862D33800D9;
        Mon, 17 Feb 2020 21:32:35 +0300 (MSK)
Received: from localhost (localhost [::1])
        by mxback2g.mail.yandex.net (mxback/Yandex) with ESMTP id Hos6lzhXdw-WZnGPXCA;
        Mon, 17 Feb 2020 21:32:35 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1581964355;
        bh=ZXaLfkB4QnIWV6WwupheBTl3yVczZy/2HbFnDzWCBxQ=;
        h=Message-Id:Cc:Subject:In-Reply-To:Date:References:To:From;
        b=NoyiUAVGde3k3GLIoi3chnJ14yMXccIxA7mQaCHiyh4/LBRx7/rrFWtUTLjObkRGA
         XSd+Ln9DWsYtzS00U4vptmuwT5UQoPgtNLm+hyBU/jS+94HwnKkczyVHifXOr8YLp9
         NpcN5mdyHOK2G+aFF1/rL3x7wFr9/rCmzhBkla6U=
Authentication-Results: mxback2g.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt6-09be74140f25.qloud-c.yandex.net with HTTP;
        Mon, 17 Feb 2020 21:32:35 +0300
From:   Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To:     "Daniel Walker (danielwa)" <danielwa@cisco.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20200217175209.GM24152@zorba>
References: <20200212192901.6402-1-danielwa@cisco.com>
         <20200216.184443.782357344949548902.davem@davemloft.net>
         <20200217172551.GL24152@zorba>
         <16818701581961475@iva7-8a22bc446c12.qloud-c.yandex.net> <20200217175209.GM24152@zorba>
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain messages
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Mon, 17 Feb 2020 21:32:35 +0300
Message-Id: <17589131581964355@myt6-09be74140f25.qloud-c.yandex.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



17.02.2020, 20:52, "Daniel Walker (danielwa)" <danielwa@cisco.com>:
>>     What about sysfs interface with one file per message type?
>
> You mean similar to the module parameters I've done, but thru sysfs ? It would
> work for Cisco. I kind of like Kconfig because it also reduces kernel size for
> messages you may never want to see.

Yup, single sysfs file per message type you've created as kernel module parameter binary switches.

David, is it ok for you?
