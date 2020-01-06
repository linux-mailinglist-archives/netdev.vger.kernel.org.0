Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD02131A5D
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgAFVZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:25:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33392 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726713AbgAFVZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:25:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578345921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRAQqVF2QxqwjTpmpka+SSoDOqJy1E6W6q5/OYr1Y6E=;
        b=i5NxcV7Ucqq9/VBoojrmDiCUlcxBneWKzmOPiFXuLDClgLumX46kRj+kiBCcJuqBGwtaOD
        a9Pil7gFBrRSMJ8r7BeOapmcUEJj5sQ+gB2AV7y2mbZ1lPgdDUFaD6A9e3CA9D8Hdqa6lM
        rJhLgaWCeXAgN4c/HJO6i8VWpRrizj4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-RmRaQWgHMtOkfMaZypp2kA-1; Mon, 06 Jan 2020 16:25:17 -0500
X-MC-Unique: RmRaQWgHMtOkfMaZypp2kA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 928E01800D4A;
        Mon,  6 Jan 2020 21:25:16 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 463D47DB5F;
        Mon,  6 Jan 2020 21:25:14 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:25:13 -0800 (PST)
Message-Id: <20200106.132513.1650666329211239718.davem@redhat.com>
To:     ying.xue@windriver.com
Cc:     netdev@vger.kernel.org, maloy@donjonn.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net] tipc: eliminate KMSAN: uninit-value in
 __tipc_nl_compat_dumpit error
From:   David Miller <davem@redhat.com>
In-Reply-To: <1578106116-22543-1-git-send-email-ying.xue@windriver.com>
References: <1578106116-22543-1-git-send-email-ying.xue@windriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ying Xue <ying.xue@windriver.com>
Date: Sat, 4 Jan 2020 10:48:36 +0800

> syzbot found the following crash on:
 ...
> The complaint above occurred because the memory region pointed by attrbuf
> variable was not initialized. To eliminate this warning, we use kcalloc()
> rather than kmalloc_array() to allocate memory for attrbuf.
> 
> Reported-by: syzbot+b1fd2bf2c89d8407e15f@syzkaller.appspotmail.com
> Signed-off-by: Ying Xue <ying.xue@windriver.com>

Applied.

