Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3462184E9D
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgCMSba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:31:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgCMSba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:31:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 446C9159DA2B9;
        Fri, 13 Mar 2020 11:31:29 -0700 (PDT)
Date:   Fri, 13 Mar 2020 11:31:28 -0700 (PDT)
Message-Id: <20200313.113128.1891702081431290686.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     paulb@mellanox.com, saeedm@mellanox.com, ozsh@mellanox.com,
        vladbu@mellanox.com, netdev@vger.kernel.org, jiri@mellanox.com,
        roid@mellanox.com
Subject: Re: [PATCH net-next ct-offload v4 00/15] Introduce connection
 tracking offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313164905.GM2546@localhost.localdomain>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
        <20200312.150600.667394309882963148.davem@davemloft.net>
        <20200313164905.GM2546@localhost.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Mar 2020 11:31:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 13 Mar 2020 13:49:05 -0300

> On Thu, Mar 12, 2020 at 03:06:00PM -0700, David Miller wrote:
>> Applied and queued up for -stable.
> 
> Thanks but, -stable?

Sorry, thinko :-)
