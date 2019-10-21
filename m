Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B216CDF521
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfJUScH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:32:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38536 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfJUScH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:32:07 -0400
Received: from localhost (unknown [4.14.35.89])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0F4B14254DE1;
        Mon, 21 Oct 2019 11:32:06 -0700 (PDT)
Date:   Mon, 21 Oct 2019 11:32:06 -0700 (PDT)
Message-Id: <20191021.113206.1532382360389329093.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     linux-kernel@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/16] net: dsa: turn arrays of ports into a
 list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Oct 2019 11:32:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Sat, 19 Oct 2019 23:19:25 -0400

> The dsa_switch structure represents the physical switch device itself,
> and is allocated by the driver. The dsa_switch_tree and dsa_port structures
> represent the logical switch fabric (eventually composed of multiple switch
> devices) and its ports, and are allocated by the DSA core.
 ...

Expecting a v2.
