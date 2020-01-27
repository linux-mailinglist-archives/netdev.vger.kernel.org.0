Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36B614A12A
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgA0Jre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:47:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36602 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgA0Jrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:47:33 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE0051502D624;
        Mon, 27 Jan 2020 01:47:30 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:47:29 +0100 (CET)
Message-Id: <20200127.104729.424111923374196200.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     syzbot+5cfab121b54dff775399@syzkaller.appspotmail.com,
        allison@lohutok.net, keescook@chromium.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pankaj.laxminarayan.bharadiya@intel.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Subject: Re: [PATCH] net/802/mrp: disconnect on uninit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122072604.hkspgs6ihyelzxtn@kili.mountain>
References: <000000000000f35c6a059cab64c5@google.com>
        <20200122072604.hkspgs6ihyelzxtn@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 01:47:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 22 Jan 2020 10:26:04 +0300

> [  I was investigating this bug and I sort of got carried away and wrote
>    a patch.  I'm going to see if I can find a test system to start
>    testing these patches then I will resend the patch.  - dan ]
> 
> Syzbot discovered that mrp_attr attr structs are being leaked.  They're
> supposed to be freed by mrp_attr_destroy() which is called from
> mrp_attr_event().
> 
> I think that when we close everything down, we're supposed to send one
> last disconnect event but the code for that wasn't fully implemented.
> 
> Reported-by: syzbot+5cfab121b54dff775399@syzkaller.appspotmail.com
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Not tested.  Idea only.

Yes, please resend this when it is tested, somehow, by someone :-)
