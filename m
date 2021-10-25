Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3164391AE
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhJYIsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231727AbhJYIsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 04:48:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9099960C40;
        Mon, 25 Oct 2021 08:46:07 +0000 (UTC)
Date:   Mon, 25 Oct 2021 10:46:03 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] net-sysfs: initialize uid and gid before calling
 net_ns_get_ownership
Message-ID: <20211025084603.36owzqhkfhwyrmro@wittgenstein>
References: <a1d7fda6a8e54a766fc9922e3abec8411120c3ac.1635143508.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a1d7fda6a8e54a766fc9922e3abec8411120c3ac.1635143508.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 02:31:48AM -0400, Xin Long wrote:
> Currently in net_ns_get_ownership() it may not be able to set uid or gid
> if make_kuid or make_kgid returns an invalid value, and an uninit-value
> issue can be triggered by this.
> 
> This patch is to fix it by initializing the uid and gid before calling
> net_ns_get_ownership(), as it does in kobject_get_ownership()
> 
> Fixes: e6dee9f3893c ("net-sysfs: add netdev_change_owner()")
> Reported-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Looks good,
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
