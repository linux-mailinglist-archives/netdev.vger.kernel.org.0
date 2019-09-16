Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB0EB37D8
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfIPKOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:14:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:53116 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726173AbfIPKOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 06:14:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E869EB650;
        Mon, 16 Sep 2019 10:14:19 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     <Claudiu.Beznea@microchip.com>
Cc:     <Nicolas.Ferre@microchip.com>, <netdev@vger.kernel.org>
Subject: Re: macb: inconsistent Rx descriptor chain after OOM
References: <mvm4l1chemx.fsf@suse.de>
        <51458d2e-69a5-2a30-2167-7f47a43d9a2f@microchip.com>
X-Yow:  HERE!!  Put THIS on!!  I'm in CHARGE!!
Date:   Mon, 16 Sep 2019 12:14:11 +0200
In-Reply-To: <51458d2e-69a5-2a30-2167-7f47a43d9a2f@microchip.com> (Claudiu
        Beznea's message of "Mon, 16 Sep 2019 10:00:27 +0000")
Message-ID: <mvmmuf4fszw.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sep 16 2019, <Claudiu.Beznea@microchip.com> wrote:

> I will have a look on it. It would be good if you could give me some
> details about the steps to reproduce it.

You need to trigger OOM.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
