Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024732CD690
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbgLCNVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:21:01 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:48997 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgLCNVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:21:00 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id 61FEFCECFD;
        Thu,  3 Dec 2020 14:27:31 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH v11 4/5] Bluetooth: Refactor read default sys config for
 various types
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201126122109.v11.4.I9231b35b0be815c32c3a3ec48dcd1d68fa65daf4@changeid>
Date:   Thu, 3 Dec 2020 14:20:17 +0100
Cc:     BlueZ development <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        alainm@chromium.org, mcchou@chromium.org, mmandlik@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F1890CC9-FE1B-4165-ABB1-AC44D13D178E@holtmann.org>
References: <20201126122109.v11.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
 <20201126122109.v11.4.I9231b35b0be815c32c3a3ec48dcd1d68fa65daf4@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> Refactor read default system configuration function so that it's capable
> of returning different types than u16
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> ---
> 
> (no changes since v8)
> 
> Changes in v8:
> - Update the commit title and message
> 
> net/bluetooth/mgmt_config.c | 140 +++++++++++++++++++++---------------
> 1 file changed, 84 insertions(+), 56 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

