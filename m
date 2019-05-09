Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0DB18E34
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfEIQdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:33:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36670 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfEIQdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:33:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 534C514CFB330;
        Thu,  9 May 2019 09:33:40 -0700 (PDT)
Date:   Thu, 09 May 2019 09:33:39 -0700 (PDT)
Message-Id: <20190509.093339.1224227202792578649.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     paul@paul-moore.com, selinux@vger.kernel.org,
        netdev@vger.kernel.org, tdeseyn@redhat.com,
        richard_c_haines@btinternet.com, sds@tycho.nsa.gov,
        marcelo.leitner@gmail.com
Subject: Re: [PATCH net] selinux: do not report error on connect(AF_UNSPEC)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bcfa1b06f277357d89b746a4fced49c0617deef1.camel@redhat.com>
References: <0957f30f-07b8-5e2f-ac71-615f511a5eea@tycho.nsa.gov>
        <CAHC9VhTs+Q4oAiMGkK9QZBJ9G4yY28WFJkc2jjp05DEW1OAhYw@mail.gmail.com>
        <bcfa1b06f277357d89b746a4fced49c0617deef1.camel@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:33:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 09 May 2019 10:40:40 +0200

> @DaveM: if it's ok for you, I'll send a revert for this on netdev and
> I'll send a v2 via the selinux ML, please let me know!

Sure.
