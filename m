Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0EC31493
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfEaSW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:22:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfEaSW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:22:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 201EB14FC92A7
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:22:26 -0700 (PDT)
Date:   Fri, 31 May 2019 11:22:25 -0700 (PDT)
Message-Id: <20190531.112225.1432574615549038295.davem@davemloft.net>
To:     netdev@vger.kernel.org
Subject: MERGE net --> net-next
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 11:22:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I just merged net into net-next, just FYI...
