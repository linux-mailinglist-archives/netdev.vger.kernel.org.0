Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D850415BD59
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgBMLI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:08:57 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51613 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729466AbgBMLI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:08:57 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2CM3-0007iV-Ra; Thu, 13 Feb 2020 12:08:23 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 885FA1013A6; Thu, 13 Feb 2020 12:08:23 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Anchal Agarwal <anchalag@amazon.com>, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org, kamatam@amazon.com,
        sstabellini@kernel.org, konrad.wilk@oracle.com,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        anchalag@amazon.com, xen-devel@lists.xenproject.org,
        vkuznets@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw@amazon.co.uk,
        fllinden@amaozn.com, benh@kernel.crashing.org
Subject: Re: [RFC PATCH v3 00/12] Enable PM hibernation on guest VMs
In-Reply-To: <20200212222935.GA3421@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Date:   Thu, 13 Feb 2020 12:08:23 +0100
Message-ID: <87a75m3ftk.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ancha,

Anchal Agarwal <anchalag@amazon.com> writes:

> Hello,
> I am sending out a v3 version of series of patches that implements guest
> PM hibernation.

can you pretty please thread your patch series so that the 1-n/n mails
have a

  References: <message-id-of-0-of-n-mail@whateveryourclientputsthere>

in the headers? git-send-email does that proper as do other tools.

Collecting the individual mails is painful.

Thanks,

        tglx
