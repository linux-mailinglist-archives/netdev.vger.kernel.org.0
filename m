Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3832C97683
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfHUJ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:56:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:44444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726388AbfHUJ4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 05:56:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 648B7AE21;
        Wed, 21 Aug 2019 09:56:14 +0000 (UTC)
Message-ID: <1566380491.8347.13.camel@suse.com>
Subject: Re: [RFC 0/4] Add support into cdc_ncm for MAC address pass through
From:   Oliver Neukum <oneukum@suse.com>
To:     Charles.Hyde@dellteam.com, linux-acpi@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     Mario.Limonciello@dell.com, gregkh@linuxfoundation.org,
        nic_swsd@realtek.com, netdev@vger.kernel.org
Date:   Wed, 21 Aug 2019 11:41:31 +0200
In-Reply-To: <89a5f8ea30b240babd8750d236ca9ef4@AUSX13MPS303.AMER.DELL.COM>
References: <89a5f8ea30b240babd8750d236ca9ef4@AUSX13MPS303.AMER.DELL.COM>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, den 20.08.2019, 22:15 +0000 schrieb
Charles.Hyde@dellteam.com:
> In recent testing of a Dell Universal Dock D6000, I found that MAC address pass through is not supported in the Linux drivers.

Hi,

thank you for writing this code. It adds cool functionality.
There are, however, a few design issues and minor flaws with it.
I will comment on the patches in the series to point them out.
Could you correct them?

	Regards
		Oliver

