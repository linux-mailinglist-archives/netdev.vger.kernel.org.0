Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF74274D7D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 01:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgIVXrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 19:47:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59659 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgIVXrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 19:47:20 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kKs05-0004hW-5o; Tue, 22 Sep 2020 23:47:09 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 9EEE45FED0; Tue, 22 Sep 2020 16:47:07 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 97CEF9FB5C;
        Tue, 22 Sep 2020 16:47:07 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
cc:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] bonding: make Kconfig toggle to disable legacy interfaces
In-reply-to: <20200922162459.3f0cf0a8@hermes.lan>
References: <20200922133731.33478-1-jarod@redhat.com> <20200922133731.33478-5-jarod@redhat.com> <20200922162459.3f0cf0a8@hermes.lan>
Comments: In-reply-to Stephen Hemminger <stephen@networkplumber.org>
   message dated "Tue, 22 Sep 2020 16:24:59 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17373.1600818427.1@famine>
Date:   Tue, 22 Sep 2020 16:47:07 -0700
Message-ID: <17374.1600818427@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> wrote:

>On Tue, 22 Sep 2020 09:37:30 -0400
>Jarod Wilson <jarod@redhat.com> wrote:
>
>> By default, enable retaining all user-facing API that includes the use of
>> master and slave, but add a Kconfig knob that allows those that wish to
>> remove it entirely do so in one shot.
>> 
>> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>> Cc: Veaceslav Falico <vfalico@gmail.com>
>> Cc: Andy Gospodarek <andy@greyhouse.net>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Thomas Davis <tadavis@lbl.gov>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>
>Why not just have a config option to remove all the /proc and sysfs options
>in bonding (and bridging) and only use netlink? New tools should be only able
>to use netlink only.

	I agree that new tooling should be netlink, but what value is
provided by such an option that distros are unlikely to enable, and
enabling will break the UAPI?

>Then you might convince maintainers to update documentation as well.
>Last I checked there were still references to ifenslave.

	Distros still include ifenslave, but it's now a shell script
that uses sysfs.  I see it used in scripts from time to time.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
