Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688143DBDC1
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhG3Rcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229773AbhG3Rcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:32:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A231B60F4A;
        Fri, 30 Jul 2021 17:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627666356;
        bh=xJWN0HFiIaqSzQzwB/W4SDaTx9XK/Z5Ct592yw17moo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Phymr1PZ0iYBlrNyewhPQ6Ni4ZEmU6LZvC9kD/n8KpEUSuVFe3l4WThWWEEhGlOYQ
         axwxhjoVzZ0T7t5JV+PspNDaNPgb63RonP1rrOq8L7lcX89egU0AuN1/6Wko2yg9/D
         Hhs2XhfmCEk9SnqwYCsuBADxbW0woNy0H33midLdSQKot1SW0dO8yjLOC4+Cj43n2E
         37LKXWOHKOe587X35q0IWBo1b1XyT0cVlNDBHMYVkeybSrDlii6UQ2wYOS8mMDlLMH
         h1MxZ/mb9rOzQ48DcDmNLZdO3EgqrGm33hqzymQzOhT/VKd3b5hfrqBgiAUghLH96h
         UNs/3zC19g6HA==
Date:   Fri, 30 Jul 2021 10:32:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Pavel Skripkin <paskripkin@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH net 4/6] can: usb_8dev: fix memory leak
Message-ID: <20210730103235.62bf3a0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210730070526.1699867-5-mkl@pengutronix.de>
References: <20210730070526.1699867-1-mkl@pengutronix.de>
        <20210730070526.1699867-5-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 09:05:24 +0200 Marc Kleine-Budde wrote:
> Cc: linux-stable <stable@vger.kernel.org>

nit: checkpatch complained about this format of CCing stable
