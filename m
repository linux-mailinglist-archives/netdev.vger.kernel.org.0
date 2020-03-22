Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF0618E637
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgCVDNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:13:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34422 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVDNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:13:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CF26D15AC1045;
        Sat, 21 Mar 2020 20:13:40 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:13:39 -0700 (PDT)
Message-Id: <20200321.201339.440289928216505781.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     kuba@kernel.org, jianyang.kernel@gmail.com, netdev@vger.kernel.org,
        soheil@google.com, jianyang@google.com
Subject: Re: [PATCH net-next 0/5] selftests: expand txtimestamp with new
 features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+FuTSczRTvZkf1g8ZmfCU=MDESCf5ZBNT4XUe9K8G9mqj4igw@mail.gmail.com>
References: <20200317192509.150725-1-jianyang.kernel@gmail.com>
        <20200317133320.2df0d2b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+FuTSczRTvZkf1g8ZmfCU=MDESCf5ZBNT4XUe9K8G9mqj4igw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:13:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 17 Mar 2020 16:39:33 -0400

> On Tue, Mar 17, 2020 at 4:33 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> Is there any chance we could move/integrate the txtimestamp test into
>> net/?  It's the only test under networking/
 ...
> For a separate follow-up patchset?

Yes.
