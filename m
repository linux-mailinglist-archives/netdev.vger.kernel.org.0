Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7CD7AF7DC
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfIKI1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:27:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40156 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfIKI1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:27:06 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D2C615567B2E;
        Wed, 11 Sep 2019 01:27:05 -0700 (PDT)
Date:   Wed, 11 Sep 2019 10:27:03 +0200 (CEST)
Message-Id: <20190911.102703.2297537348869059180.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 0/3] Mellanox, mlx5 build cleanup
 2019-09-10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190910214542.8433-1-saeedm@mellanox.com>
References: <20190910214542.8433-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 01:27:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 10 Sep 2019 21:45:57 +0000

> This series provides three build warnings cleanup patches for mlx5,
> Originally i wanted to wait a bit more and attach more patches to this
> series, but apparently this can't wait since already 3 different patches
> for the same fix were submitted this week :).
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks.
