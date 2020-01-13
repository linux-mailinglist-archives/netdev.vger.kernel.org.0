Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7329139808
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 18:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgAMRuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 12:50:16 -0500
Received: from correo.us.es ([193.147.175.20]:53062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgAMRuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 12:50:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BDB226F9C2
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 18:50:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFDDFDA702
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 18:50:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4C87DA705; Mon, 13 Jan 2020 18:50:14 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B94BCDA702;
        Mon, 13 Jan 2020 18:50:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 Jan 2020 18:50:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (50.pool85-54-104.dynamic.orange.es [85.54.104.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8B06C42EF52A;
        Mon, 13 Jan 2020 18:50:12 +0100 (CET)
Date:   Mon, 13 Jan 2020 18:50:11 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [Patch net] netfilter: fix a use-after-free in mtype_destroy()
Message-ID: <20200113175011.zcp4jsr74zn65f6z@salvia>
References: <20200110195308.30651-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110195308.30651-1-xiyou.wangcong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 11:53:08AM -0800, Cong Wang wrote:
> map->members is freed by ip_set_free() right before using it in
> mtype_ext_cleanup() again. So we just have to move it down.

Applied, thanks.
