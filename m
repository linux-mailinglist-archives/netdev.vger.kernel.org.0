Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3B83D95E0
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhG1TKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:10:46 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:45730
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229620AbhG1TKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 15:10:45 -0400
Received: from famine.localdomain (1.general.jvosburgh.us.vpn [10.172.68.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id CDA4C3F231;
        Wed, 28 Jul 2021 19:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627499442;
        bh=0M5Xf38iYE1qsup1vcJX2g/p0o4NyYDUs/dStGYbz7g=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=W3KJxgxe2Y6hSntOh+jbhIWw1qwvFCSHxtMTKWZBdeh8XoI4Oh7XxjcqFD1mh69HX
         9PNsMSm0SgjZWroyjLmRO+AWTlVxh9uSz3catiY+JJyqBY80zUEi3n5h6VkC/ivwwz
         Yo3bSbc40bAFohMjFqFjwtlGGOrNr2c63DuPiu8/oB3sqnnXXFvG9nVotc5f6EDanU
         EmpvPVoD95iPkjPDbLzNmu9p976NkM5R+JHtW3Yshos6BybFWnK3so+JBqJqUwCuyc
         ZUWWrNE15wgDqTxxnfXcLA86j0Ts8ghUjj+5OjfVOe+DPS8x75wEAYzi4ilZr7UMUo
         yvSk4BYcKUKfg==
Received: by famine.localdomain (Postfix, from userid 1000)
        id C30A75FBC4; Wed, 28 Jul 2021 12:10:38 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id BC5249FAC3;
        Wed, 28 Jul 2021 12:10:38 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jiri Pirko <jiri@resnulli.us>
cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] bonding: add new option lacp_active
In-reply-to: <YQFiJQx7gkqNYkga@nanopsycho>
References: <20210728095229.591321-1-liuhangbin@gmail.com> <YQFiJQx7gkqNYkga@nanopsycho>
Comments: In-reply-to Jiri Pirko <jiri@resnulli.us>
   message dated "Wed, 28 Jul 2021 15:56:53 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3750.1627499438.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 28 Jul 2021 12:10:38 -0700
Message-ID: <3752.1627499438@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Pirko <jiri@resnulli.us> wrote:

>Wed, Jul 28, 2021 at 11:52:29AM CEST, liuhangbin@gmail.com wrote:
>
>[...]
>
>>+module_param(lacp_active, int, 0);
>>+MODULE_PARM_DESC(lacp_active, "Send LACPDU frames as the configured lac=
p_rate or acts as speak when spoken to; "
>>+			      "0 for off, 1 for on (default)");
>
>Afaik adding module parameters is not allowed.

	Correct; also, adding options requires adding support to
iproute2 to handle the new options via netlink.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
