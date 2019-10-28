Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E8BE7CCA
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfJ1XVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:21:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46490 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfJ1XVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:21:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32E6014BE81ED;
        Mon, 28 Oct 2019 16:21:17 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:21:16 -0700 (PDT)
Message-Id: <20191028.162116.1790468674558276909.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com, jiri@mellanox.com
Subject: Re: [PATCH net-next v6 0/2] mv88e6xxx: Allow config of ATU hash
 algorithm
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024230352.24894-1-andrew@lunn.ch>
References: <20191024230352.24894-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 16:21:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Fri, 25 Oct 2019 01:03:50 +0200

> v2:
> 
> Pass a pointer for where the hash should be stored, return a plain
> errno, or 0.
> 
> Document the parameter.
> 
> v3:
> 
> Document type of parameter, and valid range
> Add break statements to default clause of switch
> Directly use ctx->val.vu8
> 
> v4:
> 
> Consistently use devlink, not a mix of devlink and dl.
> Fix allocation of devlink priv
> Remove upper case from parameter name
> Make mask 16 bit wide.
> 
> v5:
> Back to using the parameter name ATU_hash
> 
> v6:
> Rebase net-next/master

Series applied, thanks Andrew.
