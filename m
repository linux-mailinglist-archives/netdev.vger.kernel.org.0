Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49FE313A3AB
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 10:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgANJTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 04:19:37 -0500
Received: from krieglstein.org ([188.68.35.71]:38342 "EHLO krieglstein.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgANJTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 04:19:36 -0500
Received: from dabox.localnet (gateway.hbm.com [213.157.30.2])
        by krieglstein.org (Postfix) with ESMTPSA id 06A754009B;
        Tue, 14 Jan 2020 10:19:35 +0100 (CET)
From:   Tim Sander <tim@krieglstein.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jayati Sahu <jayati.sahu@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>,
        netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        andriy.shevchenko@linux.intel.com
Subject: Re: Commit bfdbfd28f76028b960458d107dc4ae9240c928b3 leads to crash on Intel SocFPGA Cyclone 5 DE0 NanoSoc
Date:   Tue, 14 Jan 2020 10:19:34 +0100
Message-ID: <1723612.Q0QZyef4Hx@dabox>
Organization: Sander and Lightning
In-Reply-To: <20200113182453.GD411698@kroah.com>
References: <1758567.4I393bidJ1@dabox> <d10a0557-cca0-64a9-9971-7455d67d0dc3@gmail.com> <20200113182453.GD411698@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, 13. Januar 2020, 19:24:53 CET schrieb Greg Kroah-Hartman:
> On Mon, Jan 13, 2020 at 09:51:54AM -0800, Florian Fainelli wrote:
> > On 1/13/20 9:37 AM, Tim Sander wrote:
> > > Hi
> > > 
> > > I just found out that the commit
> > > bfdbfd28f76028b960458d107dc4ae9240c928b3
> > > which also went in the stable release series causes an oops
> > > in the stmicro driver an a Terrasic DE0 NanoSoc board with Intel SocFPGA
> > > CycloneV chip. I am currently following Preempt-RT that's why i just
> > > noticed only yet when testing 5.4.10-rt5 but this also occurs without
> > > any Preempt-RT patchset. Reverting the patch fixes the oops.
> > > 
> > > It would be nice if this change could be reverted or otherwise fixed.
> > 
> > This should be fixed with:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
> > da29f2d84bd10234df570b7f07cbd0166e738230
> > 
> > which will likely make it so stable soon.
> 
> It was already in the 5.4.11 kernel release.  Tim, can you try that?
I have successfully tried 5.4.11 and 5.5-rc6. Both don't show this error.

Best regards
Tim


