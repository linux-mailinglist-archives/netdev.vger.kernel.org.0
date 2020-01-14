Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178FA13A31C
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 09:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgANIlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 03:41:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:33882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgANIlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 03:41:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C9258AE6F;
        Tue, 14 Jan 2020 08:41:03 +0000 (UTC)
Message-ID: <1578990223.15925.0.camel@suse.com>
Subject: Re: [PATCH] r8152: Add MAC passthrough support to new device
From:   Oliver Neukum <oneukum@suse.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, davem@davemloft.net,
        hayeswang@realtek.com
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Prashant Malani <pmalani@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Mario Limonciello <mario.limonciello@dell.com>,
        David Chen <david.chen7@dell.com>,
        "open list:USB NETWORKING DRIVERS" <linux-usb@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 14 Jan 2020 09:23:43 +0100
In-Reply-To: <20200114044127.20085-1-kai.heng.feng@canonical.com>
References: <20200114044127.20085-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, den 14.01.2020, 12:41 +0800 schrieb Kai-Heng Feng:
> Device 0xa387 also supports MAC passthrough, therefore add it to the
> whitelst.

Hi,

this list is getting longer and longer. Isn't there a way to do
this generically? ACPI?

	Regards
		Oliver

