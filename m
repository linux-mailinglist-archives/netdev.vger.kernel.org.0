Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B2619614E
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgC0WhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:37:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40160 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgC0WhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:37:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F5F115BB5F3B;
        Fri, 27 Mar 2020 15:37:14 -0700 (PDT)
Date:   Fri, 27 Mar 2020 15:37:13 -0700 (PDT)
Message-Id: <20200327.153713.1413768121067153435.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 0/3] s390/qeth: updates 2020-03-27
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327101934.31040-1-jwi@linux.ibm.com>
References: <20200327101934.31040-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Mar 2020 15:37:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Fri, 27 Mar 2020 11:19:31 +0100

> please apply the following patch series for qeth to netdev's net-next
> tree.
> 
> Spring clean edition:
> - remove one sysfs attribute that was never put in use,
> - make support for OSN and OSX devices optional, and
> - probe for removal of the obsolete OSN support.

Series applied, thanks.
