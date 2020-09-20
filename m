Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0612712AC
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 08:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgITG1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 02:27:15 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:44678 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgITG1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 02:27:15 -0400
Received: from marcel-macbook.fritz.box (p4fefc7f4.dip0.t-ipconnect.de [79.239.199.244])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1E7B8CECA3;
        Sun, 20 Sep 2020 08:25:43 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v1] Bluetooth: Check for encryption key size on connect
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200917181031.v1.1.I67a8b8cd4def8166970ca37109db46d731b62bb6@changeid>
Date:   Sun, 20 Sep 2020 08:18:45 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <428C3B9F-1C03-4BD9-A1AF-21D2F99A7F3C@holtmann.org>
References: <20200917181031.v1.1.I67a8b8cd4def8166970ca37109db46d731b62bb6@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> When receiving connection, we only check whether the link has been
> encrypted, but not the encryption key size of the link.
> 
> This patch adds check for encryption key size, and reject L2CAP
> connection which size is below the specified threshold (default 7)
> with security block.

please include btmon trace in the commit message to demonstrate this.

Regards

Marcel

