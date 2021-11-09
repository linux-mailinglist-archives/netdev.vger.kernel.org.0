Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD82444B50B
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 22:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241924AbhKIWA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 17:00:26 -0500
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:49108 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237422AbhKIWA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 17:00:26 -0500
Received: from omf09.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id B72C8184C6E43;
        Tue,  9 Nov 2021 21:57:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id CE6C81E04D4;
        Tue,  9 Nov 2021 21:57:32 +0000 (UTC)
Message-ID: <1875b0458294d23d8e3260d2824894b095d6a62d.camel@perches.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
From:   Joe Perches <joe@perches.com>
To:     Nadav Amit <namit@vmware.com>
Cc:     "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Juergen Gross <jgross@suse.com>, X86 ML <x86@kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Zack Rusin <zackr@vmware.com>, Deep Shah <sdeep@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Keerthana Kalyanasundaram <keerthanak@vmware.com>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue, 09 Nov 2021 13:57:31 -0800
In-Reply-To: <5C24FB2A-D2C0-4D95-A0C0-B48C4B8D5AF4@vmware.com>
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
         <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
         <5179a7c097e0bb88f95642a394f53c53e64b66b1.camel@perches.com>
         <cb03ca42-b777-3d1a-5aba-b01cd19efa9a@csail.mit.edu>
         <dcbd19fcd1625146f4db267f84abd7412513d20e.camel@perches.com>
         <5C24FB2A-D2C0-4D95-A0C0-B48C4B8D5AF4@vmware.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: CE6C81E04D4
X-Spam-Status: No, score=-4.90
X-Stat-Signature: xphw7gem3ckanztarthni3x91po8eitn
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18k+m4zQxO7Jw0A5AU3JcKPJ/10qFxleFI=
X-HE-Tag: 1636495052-266614
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-11-09 at 00:58 +0000, Nadav Amit wrote:
> > On Nov 8, 2021, at 4:37 PM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2021-11-08 at 16:22 -0800, Srivatsa S. Bhat wrote:
> > 
> > So it's an exploder not an actual maintainer and it likely isn't
> > publically archived with any normal list mechanism.
> > 
> > So IMO "private" isn't appropriate.  Neither is "L:"
> > Perhaps just mark it as what it is as an "exploder".
> > 
> > Or maybe these blocks should be similar to:
> > 
> > M:	Name of Lead Developer <somebody@vmware.com>
> > M:	VMware <foo> maintainers <linux-<foo>-maintainers@vmlinux.com>

Maybe adding entries like

M:	Named maintainer <whoever@vmware.com>
R:	VMware <foo> reviewers <linux-<foo>-maintainers@vmware.com>

would be best/simplest.


