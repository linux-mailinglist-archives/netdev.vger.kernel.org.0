Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D49C0FE
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfHXXdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:33:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48572 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfHXXdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:33:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94C9C15260049;
        Sat, 24 Aug 2019 16:33:31 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:33:31 -0700 (PDT)
Message-Id: <20190824.163331.513378382995833170.davem@davemloft.net>
To:     zhang.lin16@zte.com.cn
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, willemb@google.com,
        edumazet@google.com, deepa.kernel@gmail.com, arnd@arndb.de,
        dh.herrmann@gmail.com, gnault@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        jiang.xuexin@zte.com.cn
Subject: Re: [PATCH] [PATCH v3] sock: fix potential memory leak in
 proto_register()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566522851-24018-1-git-send-email-zhang.lin16@zte.com.cn>
References: <1566522851-24018-1-git-send-email-zhang.lin16@zte.com.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:33:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhanglin <zhang.lin16@zte.com.cn>
Date: Fri, 23 Aug 2019 09:14:11 +0800

> If protocols registered exceeded PROTO_INUSE_NR, prot will be
> added to proto_list, but no available bit left for prot in
> proto_inuse_idx.
> 
> Changes since v2:
> * Propagate the error code properly
> 
> Signed-off-by: zhanglin <zhang.lin16@zte.com.cn>

Applied.
