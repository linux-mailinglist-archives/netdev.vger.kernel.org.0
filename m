Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B718138DE3
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 10:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgAMJb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 04:31:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:45266 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgAMJb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 04:31:57 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iqw4W-002bnY-RN; Mon, 13 Jan 2020 10:31:44 +0100
Message-ID: <8e1acaf6529f997b939a75975e958a4cf7f58738.camel@sipsolutions.net>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 cfg80211_wext_siwrts
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Justin Capella <justincapella@gmail.com>
Cc:     syzbot <syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Cody Schuffelen <schuffelen@google.com>
Date:   Mon, 13 Jan 2020 10:31:43 +0100
In-Reply-To: <20200113092820.GB9510@kadam>
References: <00000000000073b469059bcde315@google.com>
         <b5d74ce6b6e3c4b39cfac7df6c2b65d0a43d4416.camel@sipsolutions.net>
         <CAMrEMU_a9evtp26tYB6VUxznmSmH98AmpP8xnejQr5bGTgE+8g@mail.gmail.com>
         <20200113092820.GB9510@kadam>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-01-13 at 12:28 +0300, Dan Carpenter wrote:
> That's the wrong ops struct?  I think I was looking at the "previous
> report" that Johannes mentioned where it was crashing because
> virt_wifi doesn't implement a set_wiphy_params function.

Did I say that? Had forgotten by the time I got to this email ...

But thanks for the pointer (reminder?) I'll go through cfg80211 and fix
it there then.

johannes


