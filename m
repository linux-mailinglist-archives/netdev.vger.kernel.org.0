Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9EB818E725
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgCVGvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:51:38 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:54159 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726052AbgCVGvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:51:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584859897; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=NqefWYA7oKSyYiu2yGdTUR8SlVG4/Arckme8ISShSZ8=; b=a4unwFG/Sb3cfBOe4YdBbhWTuBC9TC1c678kxzV/2iYsTPsMY/T8TpdR6bCA6bP2n9Mq2aX4
 kSF00nP0iISROj6R/dtVX4+wXbUWTXaHr/Z5qySomuyV6EFZpOrRTfVxM1WweNWVoJ3K+YEZ
 wsk9Krk3I+M60FLcjwel9p1dXSI=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e770aee.7f43d036f1b8-smtp-out-n02;
 Sun, 22 Mar 2020 06:51:26 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E77C8C44795; Sun, 22 Mar 2020 06:51:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 38C5DC433D2;
        Sun, 22 Mar 2020 06:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 38C5DC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Joel Fernandes \(Google\)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci\@vger.kernel.org Felipe Balbi" <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Documentation: Clarify better about the rwsem non-owner release issue
References: <20200322021938.175736-1-joel@joelfernandes.org>
Date:   Sun, 22 Mar 2020 08:51:15 +0200
In-Reply-To: <20200322021938.175736-1-joel@joelfernandes.org> (Joel
        Fernandes's message of "Sat, 21 Mar 2020 22:19:38 -0400")
Message-ID: <87a748khlo.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Joel Fernandes (Google)" <joel@joelfernandes.org> writes:

> Reword and clarify better about the rwsem non-owner release issue.
>
> Link: https://lore.kernel.org/linux-pci/20200321212144.GA6475@google.com/
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

There's something wrong with your linux-pci and linux-usb addresses:

	"linux-pci@vger.kernel.org Felipe Balbi" <balbi@kernel.org>,


	"linux-usb@vger.kernel.org Kalle Valo" <kvalo@codeaurora.org>,


-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
