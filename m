Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838D4194F42
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgC0Cwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:52:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57682 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0Cwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:52:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0CA815CE71DD;
        Thu, 26 Mar 2020 19:52:51 -0700 (PDT)
Date:   Thu, 26 Mar 2020 19:52:50 -0700 (PDT)
Message-Id: <20200326.195250.1561552278179857131.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 0/4] cls_flower: Use extack in fl_set_key()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1584995986.git.gnault@redhat.com>
References: <cover.1584995986.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 19:52:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Mon, 23 Mar 2020 21:48:45 +0100

> Add missing extack messages in fl_set_key(), so that users can get more
> meaningfull error messages when netlink attributes are rejected.
> 
> Patch 1 also extends extack in tcf_change_indev() (in pkt_cls.h) since
> this function is used by fl_set_key().

Series applied, thanks.
