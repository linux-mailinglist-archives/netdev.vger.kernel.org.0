Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EA422AF89
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 14:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgGWMj4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Jul 2020 08:39:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56092 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728499AbgGWMj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 08:39:56 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491--lZAuefPNcq8pO6zwbDlzA-1; Thu, 23 Jul 2020 08:39:46 -0400
X-MC-Unique: -lZAuefPNcq8pO6zwbDlzA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD4D5106B244;
        Thu, 23 Jul 2020 12:39:45 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B080B69524;
        Thu, 23 Jul 2020 12:39:44 +0000 (UTC)
Date:   Thu, 23 Jul 2020 14:39:43 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+7ebc2e088af5e4c0c9fa@syzkaller.appspotmail.com
Subject: Re: [Patch net] geneve: fix an uninitialized value in
 geneve_changelink()
Message-ID: <20200723123943.GH3939726@bistromath.localdomain>
References: <20200723015625.19255-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20200723015625.19255-1-xiyou.wangcong@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-07-22, 18:56:25 -0700, Cong Wang wrote:
> geneve_nl2info() sets 'df' conditionally, so we have to
> initialize it by copying the value from existing geneve
> device in geneve_changelink().
> 
> Fixes: 56c09de347e4 ("geneve: allow changing DF behavior after creation")
> Reported-by: syzbot+7ebc2e088af5e4c0c9fa@syzkaller.appspotmail.com
> Cc: Sabrina Dubroca <sd@queasysnail.net>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Ouch. Thanks for fixing this.

Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

This should only be needed in net/stable. In net-next, I removed this
in commit 9e06e8596bc8 (which will conflict with this patch).

-- 
Sabrina

