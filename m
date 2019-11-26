Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0D910A5E0
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 22:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKZVSp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Nov 2019 16:18:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42432 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZVSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 16:18:45 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC9EA14CEC90A;
        Tue, 26 Nov 2019 13:18:44 -0800 (PST)
Date:   Tue, 26 Nov 2019 13:18:44 -0800 (PST)
Message-Id: <20191126.131844.704669469444769854.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net-sctp: replace some sock_net(sk) with just 'net'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191125230937.172098-1-zenczykowski@gmail.com>
References: <20191125.105022.2027962925589066709.davem@davemloft.net>
        <20191125230937.172098-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 13:18:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Mon, 25 Nov 2019 15:09:37 -0800

> From: Maciej ¯enczykowski <maze@google.com>
> 
> It already existed in part of the function, but move it
> to a higher level and use it consistently throughout.
> 
> Safe since sk is never written to.
> 
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied.
