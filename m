Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1469A9E249
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbfH0IWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 04:22:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42910 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfH0IWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 04:22:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DAC29153BFB08;
        Tue, 27 Aug 2019 01:22:44 -0700 (PDT)
Date:   Tue, 27 Aug 2019 01:22:42 -0700 (PDT)
Message-Id: <20190827.012242.418276717667374306.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        sthemmin@microsoft.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add
 and delete alternative ifnames
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190827070808.GA2250@nanopsycho>
References: <20190826151552.4f1a2ad9@cakuba.netronome.com>
        <20190826.151819.804077961408964282.davem@davemloft.net>
        <20190827070808.GA2250@nanopsycho>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 01:22:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Tue, 27 Aug 2019 09:08:08 +0200

> Okay, so if I understand correctly, on top of separate commands for
> add/del of alternative names, you suggest also get/dump to be separate
> command and don't fill this up in existing newling/getlink command.

I'm not sure what to do yet.

David has a point, because the only way these ifnames are useful is
as ways to specify and choose net devices.  So based upon that I'm
slightly learning towards not using separate commands.
