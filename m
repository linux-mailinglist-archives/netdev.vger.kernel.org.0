Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06E18DB8B
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 00:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgCTXKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 19:10:40 -0400
Received: from ms.lwn.net ([45.79.88.28]:44012 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbgCTXKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 19:10:40 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 5F6412D6;
        Fri, 20 Mar 2020 23:10:38 +0000 (UTC)
Date:   Fri, 20 Mar 2020 17:10:20 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ricardo Ribalda Delgado <ribalda@kernel.org>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        dmaengine@vger.kernel.org, Matthias Maennich <maennich@google.com>,
        Harry Wei <harryxiyou@gmail.com>, x86@kernel.org,
        ecryptfs@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        target-devel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Tyler Hicks <code@tyhicks.com>, Vinod Koul <vkoul@kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-scsi@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 0/2] Don't generate thousands of new warnings when
 building docs
Message-ID: <20200320171020.78f045c5@lwn.net>
In-Reply-To: <cover.1584716446.git.mchehab+huawei@kernel.org>
References: <cover.1584716446.git.mchehab+huawei@kernel.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020 16:11:01 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> This small series address a regression caused by a new patch at
> docs-next (and at linux-next).

I don't know how I missed that mess, sorry.  I plead distracting times or
something like that.  Heck, I think I'll blame everything on the plague
for at least the next few weeks.

Anyway, I've applied this, thanks for cleaning it up.

jon
