Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2F1198644
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgC3VSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:18:15 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:56915 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728393AbgC3VSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:18:14 -0400
Received: from xps13.fritz.box ([IPv6:2001:984:543e:1:2701:2dbe:5ad1:8fec])
        by smtp-cloud7.xs4all.net with ESMTPSA
        id J1nKjwh1qLu1fJ1nMjGLSF; Mon, 30 Mar 2020 23:18:11 +0200
Message-ID: <1a57d88410e8354d083ad31e956bb03d1a8e3c0b.camel@tiscali.nl>
Subject: Re: [GIT] Networking
From:   Paul Bolle <pebolle@tiscali.nl>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Date:   Mon, 30 Mar 2020 23:18:06 +0200
In-Reply-To: <CAHk-=wjDZTfj3wYm+HKd2tfT8j_unQwhP-t3-91Z-8qqMS=ceQ@mail.gmail.com>
References: <20200328.183923.1567579026552407300.davem@davemloft.net>
         <CAHk-=wgoySgT5q9L5E-Bwm_Lsn3w-bzL2SBji51WF8z4bk4SEQ@mail.gmail.com>
         <20200329.155232.1256733901524676876.davem@davemloft.net>
         <CAHk-=wjDZTfj3wYm+HKd2tfT8j_unQwhP-t3-91Z-8qqMS=ceQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIZlByNEyvIoWA/k1045l/pfw74BXnmXCHCoreDdAatMndKRBj12+VtbIyvWU251W6Dsg6olVWwj+3EkLLFzWR9XeYy5twmu+vxuncIpYmhVEIEj+xd8
 MWTjqGAm3JyRJlwsnG217PgBNlgM7ylSK/6n2i2k8gJhd46AyGeot6Ozv/P4LLFuvuHCeX9sdgxUg++oM4t3af1KjZwUI18VApnck2k7iXctYCZR0+a0NkO+
 aLhUSpNNoi/TX0cGVkUCpsz2DDJgyFfCPss/zIkAL+Y2wfcWVmqrMbM/EoMPNkrf5pxdm6taFZPwdg2DlCS3yvtqZQIVBJSI97ZZpa+PLWGPjmh2VapETGYH
 L3YaEwLEuqphytZtl+HXXZkkd6GzEYU3QnAD6ctGyCB6x+RetxYYj9BtoZZjWUoXJ6qKFRBm
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Added Johannes.]

Linus Torvalds schreef op zo 29-03-2020 om 15:54 [-0700]:
> On Sun, Mar 29, 2020 at 3:52 PM David Miller <davem@davemloft.net> wrote:
> > Meanwhile, we have a wireless regression, and I'll get the fix for
> > that to you by the end of today.
> 
> Oops. This came in just after I posted the 5.6 release announcement
> after having said that there didn't seem to be any reason to delay.

If this email gets through this should be about "mac80211: fix authentication
with iwlwifi/mvm". Is that right?


Paul Bolle

