Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECFD1191DF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfLJU2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:28:10 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53542 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJU2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:28:10 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iem6v-00205E-I2; Tue, 10 Dec 2019 21:27:57 +0100
Message-ID: <b48794642a7982e2ba97b571fadfd90e08d64d02.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 4/5] ethtool: move string arrays into common
 file
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Dec 2019 21:27:54 +0100
In-Reply-To: <dc15c317b1979aec8276cc2eb36f541f29a67b6e.1575982069.git.mkubecek@suse.cz>
References: <cover.1575982069.git.mkubecek@suse.cz>
         <dc15c317b1979aec8276cc2eb36f541f29a67b6e.1575982069.git.mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> +++ b/net/ethtool/common.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note

Is the Linux-syscall-note relevant here? This isn't really used for
syscalls directly?

The exception says it's "to mark user space API (uapi) header files so
they can be included into non GPL compliant user space application
code".

> +++ b/net/ethtool/common.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */

Same here.

johannes

