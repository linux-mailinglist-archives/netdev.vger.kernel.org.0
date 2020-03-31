Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEDEF199DE5
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 20:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgCaSQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 14:16:47 -0400
Received: from correo.us.es ([193.147.175.20]:60268 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgCaSQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 14:16:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 636761E2C65
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 20:16:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53FBA12396A
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 20:16:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 49974123963; Tue, 31 Mar 2020 20:16:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6659D123962;
        Tue, 31 Mar 2020 20:16:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 31 Mar 2020 20:16:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 41A0D4301DE0;
        Tue, 31 Mar 2020 20:16:42 +0200 (CEST)
Date:   Tue, 31 Mar 2020 20:16:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
Message-ID: <20200331181641.anvsbczqh6ymyrrl@salvia>
References: <20200331163559.132240-1-zenczykowski@gmail.com>
 <nycvar.YFH.7.76.2003312012340.6572@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <nycvar.YFH.7.76.2003312012340.6572@n3.vanv.qr>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 08:14:17PM +0200, Jan Engelhardt wrote:
> 
> On Tuesday 2020-03-31 18:35, Maciej Żenczykowski wrote:
> >Signed-off-by: Maciej Żenczykowski <maze@google.com>
> >---
> > include/uapi/linux/netfilter/xt_IDLETIMER.h | 1 +
> > 1 file changed, 1 insertion(+)
> >
> >diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
> >index 434e6506abaa..49ddcdc61c09 100644
> >--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
> >+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
> >@@ -48,6 +48,7 @@ struct idletimer_tg_info_v1 {
> > 
> > 	char label[MAX_IDLETIMER_LABEL_SIZE];
> > 
> >+	__u8 send_nl_msg;   /* unused: for compatibility with Android */
> > 	__u8 timer_type;
> > 
> > 	/* for kernel module internal use only */
> >-- 
> 
> This breaks the ABI for law-abiding Linux users (i.e. the GNU/Linux 
> subgroup of it), which is equally terrible.
> 
> You will have to introduce a IDLETIMER v2.

IIRC, IDLETIMER v1 is in net-next, scheduled for 5.7-rc, there is no
release for this code yet.
