Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9AAFCE2C6
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfJGNLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:11:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfJGNLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:11:25 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2369614023005;
        Mon,  7 Oct 2019 06:11:24 -0700 (PDT)
Date:   Mon, 07 Oct 2019 15:11:23 +0200 (CEST)
Message-Id: <20191007.151123.309603307225404132.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: Re: [patch net-next 0/2] netdevsim: implement devlink dev_info op
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191007082709.13158-1-jiri@resnulli.us>
References: <20191007082709.13158-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 06:11:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mon,  7 Oct 2019 10:27:07 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Initial implementation of devlink dev_info op - just driver name is
> filled up and sent to user. Bundled with selftest.

Series applied, thanks.
