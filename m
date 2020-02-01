Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E02314FA20
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgBATOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:14:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:58592 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgBATOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 14:14:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BCB89AC44;
        Sat,  1 Feb 2020 19:14:41 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 63CD3E0095; Sat,  1 Feb 2020 20:14:41 +0100 (CET)
Date:   Sat, 1 Feb 2020 20:14:41 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Martin T <m4rtntns@gmail.com>
Subject: Re: Why is NIC driver queue depth driver dependent when it allocates
 system memory?
Message-ID: <20200201191441.GC23638@unicorn.suse.cz>
References: <CAJx5YvHH9CoC8ZDz+MwG8RFr3eg2OtDvmU-EaqG76CiAz+W+5Q@mail.gmail.com>
 <CAM_iQpUcGr-MHhWBxhL01O-nxWg1NPM8siEPkYgckyDT+Ku3gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUcGr-MHhWBxhL01O-nxWg1NPM8siEPkYgckyDT+Ku3gA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 01, 2020 at 11:08:37AM -0800, Cong Wang wrote:
> On Thu, Jan 30, 2020 at 5:03 AM Martin T <m4rtntns@gmail.com> wrote:
> >
> > Hi,
> >
> > when I read the source code of for example tg3 driver or e1000e
> > driver, then looks like the driver queue is allocated from system
> > memory. For example, in e1000_ethtool.c kcalloc() is called to
> > allocate GFP_KERNEL memory.
> >
> > If system memory is allocated, then why are there driver-dependent
> > limits? For example, in my workstation the maximum RX/TX queue for the
> > NIC using tg3 driver is 511 while maximum RX/TX queue for the NIC
> > using e1000e driver is 4096:
> 
> I doubt memory is a consideration for driver to decide the number
> of queues. How many CPU's do you have? At least mellanox driver
> uses the number of CPU's to determine the default value. Anyway,
> you can change it to whatever you prefer.

Martin was asking about ring sizes, not about number of queues.

Michal
