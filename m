Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEB4741AC
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfGXWsD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Jul 2019 18:48:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53148 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfGXWsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:48:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C08411543C8DD;
        Wed, 24 Jul 2019 15:48:02 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:48:02 -0700 (PDT)
Message-Id: <20190724.154802.774441566060513360.davem@davemloft.net>
To:     toke@redhat.com
Cc:     idosch@idosch.org, netdev@vger.kernel.org, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped
 packets and metadata
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87imrt4zzg.fsf@toke.dk>
References: <20190722183134.14516-1-idosch@idosch.org>
        <87imrt4zzg.fsf@toke.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 15:48:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Mon, 22 Jul 2019 21:43:15 +0200

> I like this!

I definitely think this is going in the right direction as well.
