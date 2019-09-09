Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F7DAD608
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 11:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389774AbfIIJrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 05:47:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:36012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728844AbfIIJrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 05:47:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A21FEAD88;
        Mon,  9 Sep 2019 09:47:30 +0000 (UTC)
Message-ID: <1568022444.365.11.camel@suse.com>
Subject: Re: WARNING in hso_free_net_device
From:   Oliver Neukum <oneukum@suse.com>
To:     Hui Peng <benquike@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        alexios.zavras@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        rfontana@redhat.com,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date:   Mon, 09 Sep 2019 11:47:24 +0200
In-Reply-To: <02ef64cc-5053-e6da-fc59-9970f48064c5@gmail.com>
References: <0000000000002a95df0591a4f114@google.com>
         <d6e4d2da-66c6-a8fe-2fea-a3435fa7cb54@gmail.com>
         <20190904154140.45dfb398@hermes.lan>
         <285edb24-01f9-3f9d-4946-b2f41ccd0774@gmail.com>
         <CAAeHK+y3eQ7bXvo1tiAkwLCsFkbSU5B+6hsKbdEzkSXP2_Jyzg@mail.gmail.com>
         <02ef64cc-5053-e6da-fc59-9970f48064c5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Donnerstag, den 05.09.2019, 22:05 -0400 schrieb Hui Peng:
> 
> On 9/5/2019 7:24 AM, Andrey Konovalov wrote:
> > On Thu, Sep 5, 2019 at 4:20 AM Hui Peng <benquike@gmail.com> wrote:
> > > 
> > > Can you guys have  a look at the attached patch?
> > 
> > Let's try it:
> > 
> > #syz test: https://github.com/google/kasan.git eea39f24
> > 
> > FYI: there are two more reports coming from this driver, which might
> > (or might not) have the same root cause. One of them has a suggested
> > fix by Oliver.
> > 
> > https://syzkaller.appspot.com/bug?extid=67b2bd0e34f952d0321e
> > https://syzkaller.appspot.com/bug?extid=93f2f45b19519b289613
> > 
> 
> I think they are different, though similar.
> This one is resulted from unregistering a network device.
> These 2 are resulted from unregistering a tty device.

Hi,

looks like it. That may indeed be the issue.
Please try to have syzbot test your patch and we will
know more.

	Regards
		Oliver

