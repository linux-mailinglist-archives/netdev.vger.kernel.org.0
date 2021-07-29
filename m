Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4500F3DA9CE
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhG2ROd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:14:33 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:40324
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229598AbhG2ROd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:14:33 -0400
Received: from famine.localdomain (1.general.jvosburgh.us.vpn [10.172.68.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 2B9483F230;
        Thu, 29 Jul 2021 17:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627578867;
        bh=TtJUedAKwDLWk4XNYBO9nVsDkeqfDsb/JnUi3lOCP/s=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Fhk+oT+qoSlI1tyjBG4EjNarVJT99XiegFMGQ7ZFBFeCJKgjq/l/CmyOsk3vX7ZB+
         3aqYdEXQzGvCJ1eFZ3S5gQZKulNDkItu47Kewo4symldVq5kWGvDsG+za0iRqSj52D
         fXM2muMdknc8jq4CnFfmyENe05yCujzCL4phBiRwVmAFZPDkHHi1Ea6I6BLY7MS6pc
         CbKc4yGm7xWH8y3QqM96VYypIuv/HnJenLp4d+HQbQ2XldgPlCvWsZLZ/8+X8hQy2I
         SInpkTPjn6SZVxZkJhFP8KeuDPAQF9hI5v+Y7vHL1L1n1BHeAoOAX3ydg8AiSdD7NT
         mdf6nOZGa5qrw==
Received: by famine.localdomain (Postfix, from userid 1000)
        id 7A73C5FBC4; Thu, 29 Jul 2021 10:14:14 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 7508F9FAC3;
        Thu, 29 Jul 2021 10:14:14 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] bonding: add new option lacp_active
In-reply-to: <YQIMay98k1OjAmjm@Laptop-X1>
References: <20210728095229.591321-1-liuhangbin@gmail.com> <YQFiJQx7gkqNYkga@nanopsycho> <3752.1627499438@famine> <YQIMay98k1OjAmjm@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Thu, 29 Jul 2021 10:03:23 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15809.1627578854.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 29 Jul 2021 10:14:14 -0700
Message-ID: <15810.1627578854@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Wed, Jul 28, 2021 at 12:10:38PM -0700, Jay Vosburgh wrote:
>> Jiri Pirko <jiri@resnulli.us> wrote:
>> =

>> >Wed, Jul 28, 2021 at 11:52:29AM CEST, liuhangbin@gmail.com wrote:
>> >
>> >[...]
>> >
>> >>+module_param(lacp_active, int, 0);
>> >>+MODULE_PARM_DESC(lacp_active, "Send LACPDU frames as the configured =
lacp_rate or acts as speak when spoken to; "
>> >>+			      "0 for off, 1 for on (default)");
>> >
>> >Afaik adding module parameters is not allowed.
>> =

>> 	Correct; also, adding options requires adding support to
>> iproute2 to handle the new options via netlink.
>
>Hi Jay, Jiri,
>
>Thanks for this info. I will remove the module param. For iproute2, I alr=
eady
>have a patch to support this options. I planed to post it after the
>kernel patch applied.

	Please post the iproute2 patch at the same time as the new
option patch.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
