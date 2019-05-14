Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A4C1CD13
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 18:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfENQeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 12:34:46 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:41337 "EHLO
        caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726036AbfENQeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 12:34:46 -0400
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id 23294460F6A; Tue, 14 May 2019 12:34:44 -0400 (EDT)
Date:   Tue, 14 May 2019 12:34:44 -0400
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec
 packets
Message-ID: <20190514163443.glfjva3ofqcy7lbg@csclub.uwaterloo.ca>
References: <20190502171636.3yquioe3gcwsxlus@csclub.uwaterloo.ca>
 <CAKgT0Ufk8LXMb9vVWfvgbjbQFKAuenncf95pfkA0P1t-3+Ni_g@mail.gmail.com>
 <20190502175513.ei7kjug3az6fe753@csclub.uwaterloo.ca>
 <20190502185250.vlsainugtn6zjd6p@csclub.uwaterloo.ca>
 <CAKgT0Uc_YVzns+26-TL+hhmErqG4_w4evRqLCaa=7nME7Zq+Vg@mail.gmail.com>
 <20190503151421.akvmu77lghxcouni@csclub.uwaterloo.ca>
 <CAKgT0UcV2wCr6iUYktZ+Bju_GNpXKzR=M+NLfKhUsw4bsJSiyA@mail.gmail.com>
 <20190503205935.bg45rsso5jjj3gnx@csclub.uwaterloo.ca>
 <20190513165547.alkkgcsdelaznw6v@csclub.uwaterloo.ca>
 <CAKgT0Uf_nqZtCnHmC=-oDFz-3PuSM6=30BvJSDiAgzK062OY6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uf_nqZtCnHmC=-oDFz-3PuSM6=30BvJSDiAgzK062OY6w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 12:04:00PM -0700, Alexander Duyck wrote:
> So I recreated the first packet you listed via text2pcap, replayed it
> on my test system via tcpreplay, updated my configuration to 12
> queues, and used the 2 hash keys you listed. I ended up seeing the
> traffic bounce between queues 4 and 8 with an X710 I had to test with
> when I was changing the key value.
> 
> Unfortunately I don't have an X722 to test with. I'm suspecting that
> there may be some difference in the RSS setup, specifically it seems
> like values in the PFQF_HENA register were changed for the X722 part
> that may be causing the issues we are seeing.
> 
> I will see if I can get someone from the networking division to take a
> look at this since I don't have access to the part in question nor a
> datasheet for it so I am not sure if I can help much more.

Great.  I hope someone can figure this out because it is working very
badly so far.

-- 
Len Sorensen
