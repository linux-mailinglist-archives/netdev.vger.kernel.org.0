Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C255A6F4C5
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 20:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfGUSrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 14:47:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33746 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfGUSrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 14:47:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC42E15259C7D;
        Sun, 21 Jul 2019 11:47:45 -0700 (PDT)
Date:   Sun, 21 Jul 2019 11:47:45 -0700 (PDT)
Message-Id: <20190721.114745.123875438153277101.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     kjlu@umn.edu, smccaman@umn.edu, secalert@redhat.com,
        emamd001@umn.edu, vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allocate_flower_entry: should check for null deref
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190721063731.7772-1-navid.emamdoost@gmail.com>
References: <20190721063731.7772-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 11:47:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Sun, 21 Jul 2019 01:37:31 -0500

> allocate_flower_entry does not check for allocation success, but tries
> to deref the result. I only moved the spin_lock under null check, because
>  the caller is checking allocation's status at line 652.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Applied.
