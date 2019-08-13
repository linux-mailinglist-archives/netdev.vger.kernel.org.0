Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1468B410
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 11:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfHMJ1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 05:27:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:34782 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726282AbfHMJ1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 05:27:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E1C2BAE34;
        Tue, 13 Aug 2019 09:27:17 +0000 (UTC)
Message-ID: <1565688434.7043.4.camel@suse.com>
Subject: Re: KASAN: slab-out-of-bounds Read in usbnet_generic_cdc_bind
From:   Oliver Neukum <oneukum@suse.com>
To:     Andrey Konovalov <andreyknvl@google.com>,
        syzbot <syzbot+45a53506b65321c1fe91@syzkaller.appspotmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date:   Tue, 13 Aug 2019 11:27:14 +0200
In-Reply-To: <CAAeHK+wELVfuQPJaOeG7KggR2BDTOuzCYLC+dzqbhrRRPNf9cA@mail.gmail.com>
References: <000000000000487b44058fea845c@google.com>
         <CAAeHK+wELVfuQPJaOeG7KggR2BDTOuzCYLC+dzqbhrRRPNf9cA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, den 12.08.2019, 14:27 +0200 schrieb Andrey Konovalov:
> On
> This one is funny, we do sizeof(struct usb_cdc_mdlm_desc *) instead of
> sizeof(struct usb_cdc_mdlm_desc) and the same for
> usb_cdc_mdlm_detail_desc in cdc_parse_cdc_header().

You are right. Old copy & paste error presumably.
Patch is on the way.

	Regards
		Oliver

