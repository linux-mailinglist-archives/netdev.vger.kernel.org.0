Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3B6134F2D
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgAHV4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:56:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58758 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgAHV4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:56:13 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipJJ6-004TJ9-Rn; Wed, 08 Jan 2020 21:56:05 +0000
Date:   Wed, 8 Jan 2020 21:56:04 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Jens Axboe <axboe@kernel.dk>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Pedro Tammela <pctammela@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] [v2] socket: fix unused-function warning
Message-ID: <20200108215604.GI8904@ZenIV.linux.org.uk>
References: <20200108214454.3950090-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108214454.3950090-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 10:44:43PM +0100, Arnd Bergmann wrote:
> When procfs is disabled, the fdinfo code causes a harmless
> warning:
> 
> net/socket.c:1000:13: error: 'sock_show_fdinfo' defined but not used [-Werror=unused-function]
>  static void sock_show_fdinfo(struct seq_file *m, struct file *f)
> 
> Move the function definition up so we can use a single #ifdef
> around it.

Looks sane...
