Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B24D17EB54
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 22:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgCIVjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 17:39:36 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:55317 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgCIVjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 17:39:35 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 67158CECC4;
        Mon,  9 Mar 2020 22:49:02 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [RFC PATCH v5 1/5] Bluetooth: Handle PM_SUSPEND_PREPARE and
 PM_POST_SUSPEND
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200308142005.RFC.v5.1.I62f17edc39370044c75ad43a55a7382b4b8a5ceb@changeid>
Date:   Mon, 9 Mar 2020 22:39:33 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <A815D112-7B0B-47A2-9CD5-C0D2E2115F19@holtmann.org>
References: <20200308212334.213841-1-abhishekpandit@chromium.org>
 <20200308142005.RFC.v5.1.I62f17edc39370044c75ad43a55a7382b4b8a5ceb@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Register for PM_SUSPEND_PREPARE and PM_POST_SUSPEND to make sure the
> Bluetooth controller is prepared correctly for suspend/resume. Implement
> the registration, scheduling and task handling portions only in this
> patch.

is the kernel test robot bug report that just has been posted still valid?

Regards

Marcel

