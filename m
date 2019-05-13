Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E453A1BB8F
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 19:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731282AbfEMRKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 13:10:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50755 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731261AbfEMRKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 13:10:25 -0400
Received: from c-67-160-6-8.hsd1.wa.comcast.net ([67.160.6.8] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1hQET0-0005K9-0o; Mon, 13 May 2019 17:10:22 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 000C75FF13; Mon, 13 May 2019 10:10:19 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id ED5F6A6E12;
        Mon, 13 May 2019 10:10:19 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     David Miller <davem@davemloft.net>
cc:     jarod@redhat.com, linux-kernel@vger.kernel.org, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: fix arp_validate toggling in active-backup mode
In-reply-to: <20190513.094632.2251179341102416171.davem@davemloft.net>
References: <26675.1557528809@famine> <2033e768-9e35-ac89-c526-4c28fc3f747e@redhat.com> <6720.1557765810@famine> <20190513.094632.2251179341102416171.davem@davemloft.net>
Comments: In-reply-to David Miller <davem@davemloft.net>
   message dated "Mon, 13 May 2019 09:46:32 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7471.1557767419.1@famine>
Date:   Mon, 13 May 2019 10:10:19 -0700
Message-ID: <7472.1557767419@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

>From: Jay Vosburgh <jay.vosburgh@canonical.com>
>Date: Mon, 13 May 2019 09:43:30 -0700
>
>> 	That would be my preference, as the 29c4948293bf commit looks to
>> be the change actually being fixed.
>
>Sorry I pushed the original commit message out :-(
>
>But isn't the Fixes: tag he choose the one where the logic actually
>causes problems?  That's kind of my real criteria for Fixes: tags.

	I don't think so.  It looks like the problem being fixed here
(clearing recv_probe when we shouldn't) was introduced at 29c4948293bf,
but was not the only place the same problem existed.  3fe68df97c7f fixed
the other occurrences of this problem, but missed the specific one added
by 29c4948293bf, which is now fixed by this patch.

	In any event, both of the commits in question are old enough
that it's kind of moot, as -stable will presumably get the right thing
regardless.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
