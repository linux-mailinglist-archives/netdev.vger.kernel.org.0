Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B391A1D1
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 18:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfEJQqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 12:46:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53750 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbfEJQqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 12:46:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7424914F78BCC;
        Fri, 10 May 2019 09:46:51 -0700 (PDT)
Date:   Fri, 10 May 2019 09:46:47 -0700 (PDT)
Message-Id: <20190510.094647.158721076246887498.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, selinux@vger.kernel.org,
        paul@paul-moore.com
Subject: Re: [PATCH net v2] Revert "selinux: do not report error on
 connect(AF_UNSPEC)"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bc0123c474c2c581d673ddf753f7ff75ecf9dc71.1557480936.git.pabeni@redhat.com>
References: <bc0123c474c2c581d673ddf753f7ff75ecf9dc71.1557480936.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 May 2019 09:46:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 10 May 2019 11:37:58 +0200

> This reverts commit c7e0d6cca86581092cbbf2cd868b3601495554cf.
> 
> It was agreed a slightly different fix via the selinux tree.
> 
> v1 -> v2:
>  - use the correct reverted commit hash
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> Note: this is targeting the 'net' tree

Applied.
