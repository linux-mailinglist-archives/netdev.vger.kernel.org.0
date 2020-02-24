Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC8816B23B
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgBXV2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:28:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgBXV2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:28:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 242E9121A82EA;
        Mon, 24 Feb 2020 13:28:53 -0800 (PST)
Date:   Mon, 24 Feb 2020 13:28:52 -0800 (PST)
Message-Id: <20200224.132852.194028728758222231.davem@davemloft.net>
To:     jbi.octave@gmail.com
Cc:     boqun.feng@gmail.com, linux-kernel@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 06/30] sctp: Add missing annotation for
 sctp_transport_walk_stop()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200223231711.157699-7-jbi.octave@gmail.com>
References: <0/30>
        <20200223231711.157699-1-jbi.octave@gmail.com>
        <20200223231711.157699-7-jbi.octave@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 13:28:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>
Date: Sun, 23 Feb 2020 23:16:47 +0000

> Sparse reports a warning at sctp_transport_walk_stop()
> 
> warning: context imbalance in sctp_transport_walk_stop
> 	- wrong count at exit
> 
> The root cause is the missing annotation at sctp_transport_walk_stop()
> Add the missing __releases(RCU) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Applied.
