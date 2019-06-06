Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9282A37C1E
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbfFFSUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:20:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55346 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfFFSUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:20:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CF2B314DE103D;
        Thu,  6 Jun 2019 11:20:42 -0700 (PDT)
Date:   Thu, 06 Jun 2019 11:20:42 -0700 (PDT)
Message-Id: <20190606.112042.1012706819212493190.davem@davemloft.net>
To:     toke@redhat.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org
Subject: Re: [PATCH net-next v2 0/2] xdp: Allow lookup into devmaps before
 redirect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 11:20:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please target XDP/eBPF changes to the 'bpf' and 'bpf-next' tree rather
than 'net' and 'net-next'.

Thank you.
