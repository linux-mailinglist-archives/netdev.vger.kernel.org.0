Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2957302769
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 17:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbhAYQCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbhAYQBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:01:37 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E340EC0613D6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 08:00:54 -0800 (PST)
Received: from miraculix.mork.no (fwa142.mork.no [192.168.9.142])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 10PG0UXg024653
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 25 Jan 2021 17:00:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1611590430; bh=Y8Cg5lPwv0RAfj3mso69tLawQ7qPJLJBNHUfu8M6YYo=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=h7BprOwN4flD8Up1rR47N7zTRnztzpDp6cq98HCB+UmQal3bbjJVcT1UsNL0fjJcO
         9Rid6leywsfZJ6KRlMTN4Vc+lZ+rTY6kPUICsNtSjMGOOFPdCPOFC+OCxjkxoquqAG
         pa71GZnnA/uLqOW/vFwN//fIa0YbHLh6BAW+8eiE=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l44I1-000EH7-2U; Mon, 25 Jan 2021 17:00:29 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Dan Williams <dcbw@redhat.com>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        stranche@codeaurora.org, aleksander@aleksander.es,
        dnlplm@gmail.com, stephan@gerhold.net, ejcaruso@google.com,
        andrewlassalle@google.com
Subject: Re: [PATCH net-next v2] net: qmi_wwan: Add pass through mode
Organization: m
References: <1611560015-20034-1-git-send-email-subashab@codeaurora.org>
        <9c4aa5531548bf4a2e8b060b724a341476780b5d.camel@redhat.com>
Date:   Mon, 25 Jan 2021 17:00:28 +0100
In-Reply-To: <9c4aa5531548bf4a2e8b060b724a341476780b5d.camel@redhat.com> (Dan
        Williams's message of "Mon, 25 Jan 2021 09:53:50 -0600")
Message-ID: <8735ypgg6b.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Williams <dcbw@redhat.com> writes:
> On Mon, 2021-01-25 at 00:33 -0700, Subash Abhinov Kasiviswanathan
> wrote:
>> Pass through mode is to allow packets in MAP format to be passed
>> on to the stack. rmnet driver can be used to process and demultiplex
>> these packets.
>>=20
>> Pass through mode can be enabled when the device is in raw ip mode
>> only.
>> Conversely, raw ip mode cannot be disabled when pass through mode is
>> enabled.
>>=20
>> Userspace can use pass through mode in conjunction with rmnet driver
>> through the following steps-
>>=20
>> 1. Enable raw ip mode on qmi_wwan device
>> 2. Enable pass through mode on qmi_wwan device
>> 3. Create a rmnet device with qmi_wwan device as real device using
>> netlink
>
> This option is module-wide, right?
>
> eg, if there are multiple qmi_wwan-driven devices on the system, *all*
> of them must use MAP + passthrough, or none of them can, right?

No, this is a per-netdev setting, just like the raw-ip flag.



BJ=C3=B8rn
