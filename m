Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C5819738D
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgC3Esx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:48:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33066 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgC3Esx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:48:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97CF415C51211;
        Sun, 29 Mar 2020 21:48:52 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:48:51 -0700 (PDT)
Message-Id: <20200329.214851.671430371221812438.davem@davemloft.net>
To:     jianyang.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com, jianyang@google.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next] selftests: move timestamping selftests to net
 folder
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325203207.221383-1-jianyang.kernel@gmail.com>
References: <20200325203207.221383-1-jianyang.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:48:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang.kernel@gmail.com>
Date: Wed, 25 Mar 2020 13:32:07 -0700

> From: Jian Yang <jianyang@google.com>
> 
> For historical reasons, there are several timestamping selftest targets
> in selftests/networking/timestamping. Move them to the standard
> directory for networking tests: selftests/net.
> 
> Signed-off-by: Jian Yang <jianyang@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Applied, thanks.
