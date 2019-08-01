Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF937E152
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 19:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbfHARqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 13:46:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbfHARqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 13:46:17 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2154130C1093;
        Thu,  1 Aug 2019 17:46:17 +0000 (UTC)
Received: from localhost (ovpn-112-46.rdu2.redhat.com [10.10.112.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64B9D60BF4;
        Thu,  1 Aug 2019 17:46:14 +0000 (UTC)
Date:   Thu, 01 Aug 2019 13:46:13 -0400 (EDT)
Message-Id: <20190801.134613.629667082198622967.davem@redhat.com>
To:     geert+renesas@glider.be
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] net: Manufacturer names and spelling fixes
From:   David Miller <davem@redhat.com>
In-Reply-To: <20190731132216.17194-1-geert+renesas@glider.be>
References: <20190731132216.17194-1-geert+renesas@glider.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 01 Aug 2019 17:46:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Wed, 31 Jul 2019 15:22:08 +0200

> This is a set of fixes for (some blatantly) wrong manufacturer names
> and various spelling issues, mostly in Kconfig help texts.

Series applied, thank you Geert.
