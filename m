Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0949C170FCB
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgB0Epx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:45:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgB0Epx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:45:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B4EF15B47C82;
        Wed, 26 Feb 2020 20:45:52 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:45:52 -0800 (PST)
Message-Id: <20200226.204552.478443181778716637.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 0/4] mlxsw: Small driver update
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226083920.16232-1-jiri@resnulli.us>
References: <20200226083920.16232-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:45:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Wed, 26 Feb 2020 09:39:16 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> This patchset contains couple of patches not related to each other. They
> are small optimization and extension changes to the driver.

Series applied.
